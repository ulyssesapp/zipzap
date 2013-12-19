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
	
	// Contains all footnotes (or parts of it) that couldn't be appended to the current column
	NSMutableAttributedString *_remainingFootnotes;
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
		
		_remainingFootnotes = [NSMutableAttributedString new];
		
		_contentFrame = [[RKPDFFrame alloc] initWithRect:boundingBox growingDirection:RKPDFFrameGrowingDownwards context:context];
		_footnotesFrame = [[RKPDFFrame alloc] initWithRect:boundingBox growingDirection:RKPDFFrameGrowingUpwards context:context];
		
		_footnotesFrame.maximumHeight = _boundingBox.size.height - self.footnoteAreaSpacing;
	}
	
	return self;
}

- (void)appendContent:(NSAttributedString *)contentString inRange:(NSRange)range
{
	__block BOOL lineFailed = NO;
	__block BOOL pageBreak = NO;
	
	// We enforce the layout of the first line of a column, if no other content was layed out. Required for preventing infinite loops.
	BOOL enforceFirstLine = (_footnotesFrame.lines.count == 0);
	
	[_contentFrame appendAttributedString:contentString inRange:range enforceFirstLine:enforceFirstLine usingWidowWidth:_widowWidth block:^(NSRange lineRange, CGFloat lineHeight, CGFloat nextLineHeight, NSUInteger lineOfParagraph, BOOL widowFollows, BOOL *stop) {
		// To prevent infinite loops: disable widow control for first line of a column if also no footnotes have been appended.
		BOOL atLeastOneLine = (_footnotesFrame.lines.count > 1) || (_contentFrame.lines.count > 1);
		
		// Reduce possible space for footnotes
		_footnotesFrame.maximumHeight = _boundingBox.size.height - _contentFrame.visibleBoundingBox.size.height -  self.footnoteAreaSpacing;
		
		// Collect and instantiate all footnotes for the current line
		NSArray *registeredFootnotes = [_context registeredPageNotesInAttributedString:contentString range:lineRange];
		
		[registeredFootnotes enumerateObjectsUsingBlock:^(NSDictionary *noteDescriptor, NSUInteger footnoteIndex, BOOL *stop) {
			// Instantiate and append footnote
			NSMutableAttributedString *footnoteString = [[NSAttributedString attributedStringWithNote:noteDescriptor[RKFootnoteObjectKey] enumerationString:noteDescriptor[RKFootnoteEnumerationStringKey] context:_context] mutableCopy];
			
			// Add single newline to footnote, if required
			[footnoteString.mutableString replaceOccurrencesOfString:@"\n" withString:@"" options:NSAnchoredSearch|NSBackwardsSearch range:NSMakeRange(0, footnoteString.length)];
			if (footnoteIndex < registeredFootnotes.count)
				[footnoteString.mutableString appendString:@"\n"];

			// Append footnote. If there isn't enough space, keep remainder of footnote in remainingFootnoteContents. Only if there isn't even space for the first footnote, skip it entirely.
			NSUInteger appendedFootnoteLength = [self appendFootnote:footnoteString forContentLine:_contentFrame.lines.count isFirstFootnoteOfLine:(footnoteIndex == 0)];
			
			// Stop if we even failed to add the first footnote of a line...
			if ((footnoteIndex == 0) && !appendedFootnoteLength) {
				lineFailed = YES;
				*stop = YES;
				return;
			}
		}];

		// If adding this line and its footnotes will result in a orphan or a widow: remove it and stop.
		lineFailed = lineFailed | (atLeastOneLine && widowFollows && ![_contentFrame canAppendLineWithHeight: nextLineHeight]);
		
		// Line failed: remove it from the end and stop (if it is the first line of the column, ignore it to prevent endless loops).
		if (lineOfParagraph && lineFailed) {
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
		NSRange paragraphRange = [contentString.string paragraphRangeForRange: line.visibleRange];
		BOOL isOrphan = (line == _contentFrame.lastLine) && (line.visibleRange.location == paragraphRange.location) && (NSMaxRange(paragraphRange) > NSMaxRange(line.visibleRange));

		// Stop if neither an orphan nor an "keepWithFollowingParagraph" would remain on the column's end
		if (!line.additionalParagraphStyle.keepWithFollowingParagraph && !isOrphan) {
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

	if ((orphanedParagraphsUntilLine > 0) && (orphanedParagraphsUntilLine < _contentFrame.lines.count)) {
		// We have to remove some orphaned headlines (however, we do this only, if they are not the first of the page to prevent infinite loops)
		[self removeLinesFromEnd: _contentFrame.lines.count - orphanedParagraphsUntilLine];
	}
}

- (void)appendFootnote:(NSAttributedString *)attributedString
{
	[self appendFootnote:attributedString forContentLine:NSNotFound isFirstFootnoteOfLine:NO];
}

- (NSUInteger)appendFootnote:(NSAttributedString *)footnoteString forContentLine:(NSUInteger)contentLine isFirstFootnoteOfLine:(BOOL)isFirstFootnoteOfLine
{
	__block NSUInteger appendedLength = 0;
	
	[_footnotesFrame appendAttributedString:footnoteString inRange:NSMakeRange(0, footnoteString.length) enforceFirstLine:YES usingWidowWidth:_widowWidth block:^(NSRange lineRange, CGFloat lineHeight, CGFloat nextLineHeight, NSUInteger lineOfParagraph, BOOL widowFollows, BOOL *stop) {
		// This line of the footnote would create a widow, so just skip it completely.
		if (widowFollows && (lineOfParagraph > 0) && ![_footnotesFrame canAppendLineWithHeight: nextLineHeight]) {
			[self removeFootnoteLinesFromEnd: 1];
			*stop = YES;
			
			return;
		}
		
		// Associate this footnote line to the given content line, to allow later removal...
		[_contentLineForFootnoteLine setObject:@(contentLine) forKey:@(_footnotesFrame.lines.count - 1)];
		appendedLength += lineRange.length;
	}];
	
	
	// Constrain content frame, so it does not overlap our footnotes
	_contentFrame.maximumHeight = self.maximumContentHeight;
	
	// Register footnote
	if (appendedLength || !isFirstFootnoteOfLine)
		[_remainingFootnotes appendAttributedString: [footnoteString attributedSubstringFromRange: NSMakeRange(appendedLength, footnoteString.length - appendedLength)]];
	
	return appendedLength;
}

- (void)removeLinesFromEnd:(NSUInteger)lineCount
{
	while (lineCount --) {
		// Remove all footnotes for the line (we expect that 'removeLinesFormEnd' is only called, if footnotes are continuously added to the column)
		NSArray *footnoteLines = [_contentLineForFootnoteLine allKeysForObject: @(_contentFrame.lines.count - 1)];

		// Remove lines from rendered footnotes buffer
		[_footnotesFrame removeLinesFromEnd: footnoteLines.count];
		[_contentLineForFootnoteLine removeObjectsForKeys: footnoteLines];
		
		// Provide more space for footnotes again
		RKPDFLine *line = [_contentFrame lastLine];
		_footnotesFrame.maximumHeight += line.size.height;
		
		// Unregister all footnotes of the line from context
		[_context unregisterNotesInAttributedString:line.content range:NSMakeRange(0, line.content.length)];
		
		// Remove the line from the visible portion
		[_contentFrame removeLinesFromEnd: 1];
	}
}

- (void)removeFootnoteLinesFromEnd:(NSUInteger)lineCount
{
	// We have a widow: remove the footnote from the end
	NSNumber *correspondingContentLine = [_contentLineForFootnoteLine objectForKey: @(_footnotesFrame.lines.count - 1)];
	
	// We have to erase the content upto the corresponding content line
	if (correspondingContentLine)
		[self removeLinesFromEnd: _contentFrame.lines.count - correspondingContentLine.unsignedIntegerValue];
	else
		[_footnotesFrame removeLinesFromEnd: 1];
	
	// Extend content area again
	_contentFrame.maximumHeight = self.maximumContentHeight;
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
	if (self.footnotesFrame.lines.count) {
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
