//
//  RKPDFColumn.m
//  RTFKit
//
//  Created by Friedrich Gräter on 13.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFColumn.h"

#import "RKPDFLine.h"
#import "RKPDFFrame.h"
#import "RKPDFRenderingContext.h"
#import "RKDocument+PDFUtilities.h"

#import "NSAttributedString+PDFUtilities.h"

@interface RKPDFColumn ()
{
	// The context used for layouting the frame
	RKPDFRenderingContext *_context;
	
	// The expected widow width of the column
	CGFloat _widowWidth;

	// Specifies which content line belongs to which footnote line
	NSMutableDictionary *_contentLineForFootnoteLine;
	
	// The buffer for storing all footnotes that have been appended to the column (might also contain content that is not shown)
	NSMutableAttributedString *_footnotes;
}

@end

@implementation RKPDFColumn

- (id)initWithRect:(CGRect)boundingBox widowWidth:(CGFloat)widowWidth context:(RKPDFRenderingContext *)context
{
	self = [super init];
	
	if (self) {
		_context = context;
		_boundingBox = boundingBox;
		_widowWidth = widowWidth;
		
		_contentLineForFootnoteLine = [NSMutableDictionary new];
		
		_footnotes = [NSMutableAttributedString new];
		
		_contentFrame = [[RKPDFFrame alloc] initWithRect:boundingBox growingDirection:RKPDFFrameGrowingDownwards context:context];
		_footnotesFrame = [[RKPDFFrame alloc] initWithRect:boundingBox growingDirection:RKPDFFrameGrowingUpwards context:context];
	}
	
	return self;
}

- (void)appendContent:(NSAttributedString *)contentString inRange:(NSRange)range
{
	__block BOOL lineFailed = NO;
	__block BOOL pageBreak = NO;

	[_contentFrame appendAttributedString:contentString inRange:range usingWidowWidth:_widowWidth block:^(NSRange lineRange, CGFloat lineHeight, CGFloat nextLineHeight, NSUInteger lineOfParagraph, BOOL widowFollows, BOOL *stop) {
		// Reduce possible space for footnotes
		_footnotesFrame.maximumHeight = _boundingBox.size.height - _contentFrame.visibleBoundingBox.size.height -  self.footnoteAreaSpacing;
		
		// Collect and instantiate all footnotes for the current line
		NSArray *registeredFootnotes = [_context registeredPageNotesInAttributedString:contentString range:lineRange];
		
		[registeredFootnotes enumerateObjectsUsingBlock:^(NSDictionary *noteDescriptor, NSUInteger footnoteIndex, BOOL *stop) {
			NSUInteger lastVisibleFootnote = _footnotes.length + 1;
			
			// Instantiate and append footnote
			NSMutableAttributedString *footnoteString = [[NSAttributedString attributedStringWithNote:noteDescriptor[RKFootnoteObjectKey] enumerationString:noteDescriptor[RKFootnoteEnumerationStringKey] context:_context] mutableCopy];
			
			// Add single newline to footnote, if required
			[footnoteString.mutableString replaceOccurrencesOfString:@"\n" withString:@"" options:NSAnchoredSearch|NSBackwardsSearch range:NSMakeRange(0, footnoteString.length)];
			if (footnoteIndex < registeredFootnotes.count)
				[footnoteString.mutableString appendString:@"\n"];

			// Append footnote
			[self appendFootnotes:footnoteString forContentLine:(_contentFrame.lines.count-1)];
			
			if (!footnoteIndex && self.visibleFootnotesLength < lastVisibleFootnote) {
				// We could not even add the beginning of the first footnote of the line: revert the current content line and stop
				lineFailed = YES;
				*stop = YES;
				return;
			}
		}];

		// If adding this line and its footnotes will result in a orphan or a widow: remove it and stop.
		lineFailed = lineFailed | (widowFollows && ![_contentFrame canAppendLineWithHeight: nextLineHeight]);
		
		// Line failed: remove it from the end and stop (if it is the first line of the column, ignore it to prevent endless loops).
		if (lineOfParagraph && lineFailed) {
			[self removeLinesFromEnd: 1];
			
			// We don't like to create an orphan, when removing a widow
			if (widowFollows && (lineOfParagraph == 1))
				[self removeLinesFromEnd: 1];
			
			*stop = YES;
			return;
		}
		
		// Page break: stop after this line
		if ([contentString.string rangeOfString:@"\f" options:0 range:NSMakeRange(range.location, _contentFrame.visibleStringLength)].length) {
			*stop = YES;
			pageBreak = YES;
			return;
		}
	}];
	
	// Control for orphaned paragraphs is not needed if we have a page break
	if (pageBreak)
		return;
	
	// If we could not append everything to this column: do we need to make a page break before an earlier paragraph because it is set to keep with following paragraphs
	__block NSUInteger orphanedParagraphsUntilLine = NSUIntegerMax;
	
	[_contentFrame.lines enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(RKPDFLine *line, NSUInteger lineIndex, BOOL *stop) {
		if (!line.additionalParagraphStyle.keepWithFollowingParagraph) {
			// Orphaned paragraphs are only interesting, when scanning from the end of the string
			*stop = YES;
			return;
		}
		
		// Do not put a column break before a "kept with following" if it has not a succeeding paragraph
		if (NSMaxRange(line.visibleRange) >= NSMaxRange(range)) {
			*stop = YES;
			return;
		}
			
		orphanedParagraphsUntilLine = lineIndex;
	}];

	if (orphanedParagraphsUntilLine && (orphanedParagraphsUntilLine < _contentFrame.lines.count)) {
		// We have to remove some orphaned headlines (however, we do this only, if they are not the first of the page to prevent infinite loops)
		[self removeLinesFromEnd: _contentFrame.lines.count - orphanedParagraphsUntilLine];
	}
}

- (void)appendFootnotes:(NSAttributedString *)footnoteString
{
	[_footnotes appendAttributedString: footnoteString];
	
	[_footnotesFrame appendAttributedString:footnoteString inRange:NSMakeRange(0, footnoteString.length) usingWidowWidth:_widowWidth block:^(NSRange lineRange, CGFloat lineHeight, CGFloat nextLineHeight, NSUInteger lineOfParagraph, BOOL widowFollows, BOOL *stop) {

		if (!(widowFollows || !lineOfParagraph) || [_footnotesFrame canAppendLineWithHeight: lineHeight]) {
			return;
		}
		
		[self removeFootnoteLinesFromEnd: 1];
		
		// No further lines added, since we had a widow
		*stop = YES;
	}];
	
	// Constrain content frame, so it does not overlap our footnotes
	_contentFrame.maximumHeight = self.maximumContentHeight;
}

- (void)appendFootnotes:(NSAttributedString *)footnoteString forContentLine:(NSUInteger)contentLine
{
	NSUInteger firstFootnoteLine = _footnotesFrame.lines.count;
	
	[self appendFootnotes: footnoteString];
	
	for (NSUInteger footnoteLineIndex = firstFootnoteLine; footnoteLineIndex < _footnotesFrame.lines.count; footnoteLineIndex ++) {
		[_contentLineForFootnoteLine setObject:@(contentLine) forKey:@(footnoteLineIndex)];
	}
}

- (void)removeLinesFromEnd:(NSUInteger)lineCount
{
	while (lineCount --) {
		// Remove all footnotes for the line (we expect that 'removeLinesFormEnd' is only called, if footnotes are continuously added to the column)
		NSArray *footnoteLines = [_contentLineForFootnoteLine allKeysForObject: @(_contentFrame.lines.count - 1)];
		[_footnotesFrame removeLinesFromEnd: footnoteLines.count];
		[_contentLineForFootnoteLine removeObjectsForKeys: footnoteLines];
		
		// Provide more space for footnotes again
		RKPDFLine *line = [_contentFrame lastLine];
		_footnotesFrame.maximumHeight += line.size.height;
		
		// Remove the line from the visible portion
		[_contentFrame removeLinesFromEnd: 1];
	}
}

- (void)removeFootnoteLinesFromEnd:(NSUInteger)lineCount
{
	// We have a widow: remove the footnote from the end and
	NSNumber *correspondingContentLine = [_contentLineForFootnoteLine objectForKey: @(_footnotesFrame.lines.count - 1)];
	
	// We have to erase the content upto the corresponding content line
	if (correspondingContentLine)
		[self removeLinesFromEnd: _contentFrame.lines.count - correspondingContentLine.unsignedIntegerValue];
	else
		[_footnotesFrame removeLinesFromEnd: 1];
	
	// Extend content area again
	_contentFrame.maximumHeight = self.maximumContentHeight;
}

- (NSUInteger)visibleFootnotesLength
{
	return _footnotesFrame.visibleStringLength;
}

- (CGFloat)maximumContentHeight
{
	return _boundingBox.size.height - _footnotesFrame.visibleBoundingBox.size.height - ((_footnotesFrame.lines.count > 0) ? self.footnoteAreaSpacing  : 0);
}

- (CGFloat)footnoteAreaSpacing
{
	return _context.document.footnoteAreaDividerSpacingBefore + _context.document.footnoteAreaDividerSpacingAfter + _context.document.footnoteAreaDividerWidth;
}


#pragma mark - Rendering

- (void)renderWithOptions:(RKPDFWriterRenderingOptions)options
{
	RKPDFWriterRenderingOptions frameOptions = options & ~RKPDFWriterShowMaximumFrameBounds;
	
	// Render debug frames, if requested
	[self renderDebugFramesUsingOptions: options];
	
	// Render content and footnote frames
	[self.contentFrame renderUsingOptions:frameOptions];
	[self.footnotesFrame renderUsingOptions:frameOptions];
	
	// Draw footnote separator, if any
	if (self.visibleFootnotesLength) {
		[_context.document drawFootnoteSeparatorForBoundingBox:self.footnotesFrame.visibleBoundingBox toContext:_context];
	}
}

- (void)renderDebugFramesUsingOptions:(RKPDFWriterRenderingOptions)options
{
    // Show text frames
    if (options & RKPDFWriterShowMaximumFrameBounds) {
        CGRect frameRect = self.boundingBox;
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef frameColor = CGColorCreate(rgbColorSpace, (CGFloat[]){0, 0, 0, 0.2});
		
        CGContextSaveGState(_context.pdfContext);
        CGContextSetStrokeColorWithColor(_context.pdfContext, frameColor);
        CGContextSetLineWidth(_context.pdfContext, 0.5);
        CGContextStrokeRect(_context.pdfContext, frameRect);
        CGContextRestoreGState(_context.pdfContext);
        
        CFRelease(frameColor);
        CFRelease(rgbColorSpace);
    }
}


@end
