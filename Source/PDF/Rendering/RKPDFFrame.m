//
//  RKPDFFrame.m
//  RTFKit
//
//  Created by Friedrich Gräter on 12.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFFrame.h"

#import "RKRect.h"
#import "RKPDFLine.h"
#import "RKPDFRenderingContext.h"
#import "RKDocument+PDFUtilities.h"
#import "RKParagraphStyleWrapper.h"

@interface RKPDFFrame ()
{
	// The context used to layout the frame
	RKPDFRenderingContext *_context;
	
	// An array of lines (RKPDFLine) of the frame
	NSMutableArray *_lines;
	
	// The boundaries of the line (RKRect)
	NSMutableArray *_boundaryForLine;

	// The veritcal offset of the lines inside their bounding boxes (NSNumber)
	NSMutableArray *_yOffsetsForLine;
	
	// The content paragraph ranges inside the frame
	NSMutableArray *_paragraphRanges;
	
	// The visible bounding box around the frame
	CGRect _visibleBoundingBox;
}


@end

@implementation RKPDFFrame

- (id)initWithRect:(CGRect)boundingBox growingDirection:(RKPDFFrameGrowingDirection)growingDirection context:(RKPDFRenderingContext *)context
{
	self = [super init];
	
	if (self) {
		_boundingBox = boundingBox;
		_growingDirection = growingDirection;

		_context = context;
		_lines = [NSMutableArray new];
		_boundaryForLine = [NSMutableArray new];
		_yOffsetsForLine = [NSMutableArray new];
		_visibleBoundingBox = CGRectMake(boundingBox.origin.x, 0, boundingBox.size.width, 0);
		_maximumHeight = boundingBox.size.height;
		
		// The origin of the visible bounding box depends on the growing direction of the frame
		switch (growingDirection) {
			case RKPDFFrameGrowingDownwards:
				_visibleBoundingBox.origin.y = boundingBox.origin.y + boundingBox.size.height;
				break;
				
			case RKPDFFrameGrowingUpwards:
				_visibleBoundingBox.origin.y = boundingBox.origin.y;
				break;

			default:
				NSAssert(false, @"Unknown growing direction for frame: %lu", growingDirection);
		}

	}
	
	return self;
}


#pragma mark - Line managment

- (void)appendAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range usingWidowWidth:(CGFloat)widowWidth block:(void(^)(NSRange lineRange, CGFloat lineHeight, CGFloat nextLineHeight, NSUInteger lineOfParagraph, BOOL widowFollows, BOOL *stop))block;
{
	[attributedString.string enumerateSubstringsInRange:range options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange paragraphRange, BOOL *stop) {
		__block NSUInteger lineOfParagraph = 0;
		NSRange remainingParagraphRange = paragraphRange;

		// When rendering starts inside a paragraph, we will not assume to render the paragraph's first line (e.g. for ignore before spacings and first line indents)
		if (range.location && !NSEqualRanges([attributedString.string paragraphRangeForRange: paragraphRange], paragraphRange)) {
			lineOfParagraph = 1;
		}
				
		// Render paragraphs
		while (remainingParagraphRange.length > 0) {
			BOOL isFirstInFrame = (_lines.count == 0) && (range.location != 0);			
			BOOL isFirstLineOfParagraph = !lineOfParagraph;

			// Suggested width
			CGFloat suggestedWidth = [self maximumWidthForAttributedString:attributedString inRange:remainingParagraphRange isFirstInParagraph:isFirstLineOfParagraph];
			
			// Layout line
			RKPDFLine *line = [[RKPDFLine alloc] initWithAttributedString:attributedString inRange:remainingParagraphRange usingWidth:suggestedWidth maximumHeight:_boundingBox.size.height justificationAllowed:YES context:_context];
			NSRange lineRange = line.visibleRange;
			
			// Determine line position in paragraph
			BOOL isLastLineOfParagraph = (remainingParagraphRange.location + lineRange.length) == NSMaxRange(paragraphRange);
			
			if (isLastLineOfParagraph || ([attributedString.string rangeOfString:@"\u2028" options:0 range:lineRange].length)) {
				// De-register unused footnotes
				[_context unregisterNotesInAttributedString:line.content range:NSMakeRange(0, line.content.length)];
				
				// If our line is the last in a paragraph or has enforces a line break: do not justify it
				line = [[RKPDFLine alloc] initWithAttributedString:attributedString inRange:remainingParagraphRange usingWidth:suggestedWidth maximumHeight:_boundingBox.size.height justificationAllowed:NO context:_context];
				NSAssert(lineRange.length == line.visibleRange.length, @"Line range should not change after unjustifying a line");
			}
			
			// Determine line placement
			CGFloat yOffset = 0;
			CGRect lineRect = [self rectForLine:line isFirstInParagraph:isFirstLineOfParagraph isLastInParagraph:isLastLineOfParagraph isFirstInFrame:isFirstInFrame yOffset:&yOffset];

			// Stop, if there is not enough place for this line
			if (![self canAppendLineWithHeight: lineRect.size.height]) {
				// De-register unused footnotes
				[_context unregisterNotesInAttributedString:line.content range:NSMakeRange(0, line.content.length)];
				
				*stop = YES;
				return;
			}
			
			// Register line to frame
			[self appendLine:line withRect:lineRect yOffset:yOffset];
			
			// Detect, whether the next line could be a widow
			NSRange succeedingLineRange = NSMakeRange(NSMaxRange(lineRange), remainingParagraphRange.length - lineRange.length);
			CGFloat nextLineHeight = 0;
			BOOL widowFollows = NO;
			
			if (widowWidth && succeedingLineRange.length && (succeedingLineRange.location < NSMaxRange(remainingParagraphRange))) {
				RKPDFLine *succeedingLine = [[RKPDFLine alloc] initWithAttributedString:attributedString inRange:succeedingLineRange usingWidth:widowWidth maximumHeight:_maximumHeight justificationAllowed:YES context:_context];
				nextLineHeight = lineRect.size.height;
				
				widowFollows = NSMaxRange(succeedingLine.visibleRange) == NSMaxRange(remainingParagraphRange);
				
				// Unregister all footnotes from line
				[_context unregisterNotesInAttributedString:succeedingLine.content range:NSMakeRange(0, succeedingLine.content.length)];
			}
			
			// The block must be executed last, since it is allowed to remove lines within
			if (block)
				block(lineRange, line.size.height, nextLineHeight, lineOfParagraph, widowFollows, stop);
			
			// Update remaining paragraph size
			remainingParagraphRange.location += lineRange.length;
			remainingParagraphRange.length -= lineRange.length;
			
			if (*stop)
				break;
			
			lineOfParagraph ++;
		}
	}];
}

- (void)removeLinesFromEnd:(NSUInteger)lineCount
{
	while (lineCount --) {
		RKPDFLine *line = _lines.lastObject;
		CGRect lineRect = [_boundaryForLine.lastObject rectValue];
		
		_visibleStringLength -= line.visibleRange.length;
		_visibleBoundingBox.size.height -= lineRect.size.height;
		
		[_lines removeLastObject];
		[_boundaryForLine removeLastObject];
		[_yOffsetsForLine removeLastObject];
		
		switch (_growingDirection) {
			case RKPDFFrameGrowingDownwards:
				_visibleBoundingBox.origin.y += lineRect.size.height;
				break;
				
			case RKPDFFrameGrowingUpwards:
				[self moveLinesByPoints: -lineRect.size.height];
				break;
		}
	}
}

- (CGRect)rectForLine:(RKPDFLine *)line isFirstInParagraph:(BOOL)isFirstInParagraph isLastInParagraph:(BOOL)isLastInParagraph isFirstInFrame:(BOOL)isFirstInFrame yOffset:(CGFloat *)yOffsetOut
{
	RKParagraphStyleWrapper *paragraphStyle = line.paragraphStyle;
	RKAdditionalParagraphStyle *additionalParagraphStyle = line.additionalParagraphStyle;
	CGRect lineRect;
	CGFloat yOffset = 0;
	
	// Determine line origin
	lineRect.origin = CGPointMake(_visibleBoundingBox.origin.x, _visibleBoundingBox.origin.y);
	lineRect.size = line.size;
	
	// Apply head indentation
	if (isFirstInParagraph)
		lineRect.origin.x += paragraphStyle.firstLineHeadIndent;
	else
		lineRect.origin.x += paragraphStyle.headIndent;
	
	// Apply tail indentation
	if (paragraphStyle.tailIndent > 0)
		lineRect.size.width = paragraphStyle.tailIndent - lineRect.origin.x;
	else
		lineRect.size.width += paragraphStyle.tailIndent;
	
	
	// Adjust text alignment
	switch (paragraphStyle.textAlignment) {
		case kCTLeftTextAlignment:
		case kCTNaturalTextAlignment:
		case kCTJustifiedTextAlignment:
			break;
			
		case kCTCenterTextAlignment:
			lineRect.origin.x += (_visibleBoundingBox.size.width - lineRect.size.width) / 2.0f;
			break;

		case kCTRightTextAlignment:
			lineRect.origin.x += _visibleBoundingBox.size.width - lineRect.size.width;
			break;
	}

	if (!additionalParagraphStyle.overrideLineHeightAndSpacing) {
		// Apply line spacing
		CGFloat lineSpacing = paragraphStyle.lineSpacing;
		lineRect.origin.y -= lineSpacing;
		lineRect.size.height += lineSpacing;
		yOffset += lineSpacing;
		
		// Apply relative line height rules
		CGFloat newHeight = lineRect.size.height;
		
		if (paragraphStyle.lineHeightMultiple)
			newHeight *= paragraphStyle.lineHeightMultiple;
		
		// Apply maximum / minimum line heights
		if (paragraphStyle.maximumLineHeight && (newHeight > paragraphStyle.maximumLineHeight))
			newHeight = paragraphStyle.maximumLineHeight;
		
		if (newHeight < paragraphStyle.minimumLineHeight)
			newHeight = paragraphStyle.minimumLineHeight;

		lineRect.origin.y -= newHeight;
		lineRect.size.height = newHeight;
	}
	else {
		// Set line hight from base line distance
		lineRect.origin.y -= additionalParagraphStyle.baselineDistance;
		lineRect.size.height = additionalParagraphStyle.baselineDistance;
	}
	
	// Apply paragraph spacing to all paragraphs that are not the first on a page
	if (isFirstInParagraph && !isFirstInFrame) {
		CGFloat spacingBefore = paragraphStyle.paragraphSpacingBefore;
		
		lineRect.origin.y -= spacingBefore;
		lineRect.size.height += spacingBefore;
	}
	
	if (isLastInParagraph) {
		CGFloat spacingAfter = paragraphStyle.paragraphSpacing;
		
		yOffset += spacingAfter;
		lineRect.origin.y -= spacingAfter;
		lineRect.size.height += spacingAfter;
	}
	
	// Round coordinates to allow proper PDF scaling
	lineRect.origin.x = round(lineRect.origin.x / 0.5) * 0.5;
	lineRect.origin.y = round(lineRect.origin.y / 0.5) * 0.5;
	lineRect.size.height = round(lineRect.size.height / 0.5) * 0.5;
	lineRect.size.width = round(lineRect.size.width / 0.5) * 0.5;
	yOffset = round(yOffset / 0.5) * 0.5;
	
	// Determine offset within line
	if (yOffsetOut)
		*yOffsetOut = yOffset;
	
	return lineRect;
}

- (CGFloat)maximumWidthForAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range isFirstInParagraph:(BOOL)isFirstInParagraph
{
	CGFloat width = _boundingBox.size.width;
	CGFloat headIndent = 0;
	CGFloat firstLineHeadIndent = 0;
	CGFloat tailIndent = 0;
	
	CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[attributedString attribute:(__bridge NSString*)kCTParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
	CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
	CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
	CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent);
	
	if (isFirstInParagraph && (firstLineHeadIndent < width))
		width -= firstLineHeadIndent;
	else if (headIndent < width)
		width -= headIndent;
	
	if (tailIndent > 0)
		width -= _boundingBox.size.width - tailIndent;
	else
		width += tailIndent;

	return width;
}

- (void)appendLine:(RKPDFLine *)line withRect:(CGRect)lineRect yOffset:(CGFloat)yOffset
{
	// Register line
	[_lines addObject: line];
	[_boundaryForLine addObject: [RKRect rectWithRect: lineRect]];
	[_yOffsetsForLine addObject: @(yOffset)];
	
	// Update placement of bounding box
	switch (_growingDirection) {
		case RKPDFFrameGrowingDownwards:
			_visibleBoundingBox.origin.y -= lineRect.size.height;
			break;
			
		case RKPDFFrameGrowingUpwards:
			[self moveLinesByPoints: lineRect.size.height];
			break;
	}
	
	// Update height of bounding box
	_visibleBoundingBox.size.height += lineRect.size.height;
	
	// Update visible string length
	_visibleStringLength += line.visibleRange.length;
}

- (RKPDFLine *)lineAtIndex:(NSUInteger)lineIndex
{
	return [_lines objectAtIndex: lineIndex];
}

- (RKPDFLine *)lastLine
{
	return _lines.lastObject;
}

- (BOOL)canAppendLineWithHeight:(CGFloat)expectedLineHeight
{
	// Can we append a further line with the expected height?
	return ((expectedLineHeight + _visibleBoundingBox.size.height) < self.maximumHeight);
}

- (void)moveLinesByPoints:(CGFloat)points
{
	for (NSUInteger index = 0; index < _boundaryForLine.count; index ++) {
		CGRect newRectValue = [_boundaryForLine[index] rectValue];
		newRectValue.origin.y += points;
		
		RKRect *newRect = [RKRect rectWithRect: newRectValue];
		[_boundaryForLine replaceObjectAtIndex:index withObject:newRect];
	}
}

#pragma mark - Rendering methods

- (void)renderUsingOptions:(RKPDFWriterRenderingOptions)options
{
	// Draw bounding boxes, if required
	[self renderDebugFramesUsingOptions: options];
		
	// Render content lines
	[_lines enumerateObjectsUsingBlock:^(RKPDFLine *line, NSUInteger lineIndex, BOOL *stop) {
		CGRect lineBounds = [_boundaryForLine[lineIndex] rectValue];
		CGFloat yOffset = [_yOffsetsForLine[lineIndex] floatValue];
		
		CGPoint lineOrigin = lineBounds.origin;
		lineOrigin.y += yOffset;
		
		[line renderUsingOrigin: lineOrigin];
	}];

}

- (void)renderDebugFramesUsingOptions:(RKPDFWriterRenderingOptions)options
{
    // Add bounding boxes around text, if requested
    if (options & RKPDFWriterShowVisibleFrameBounds) {
        CGRect frameRect = self.visibleBoundingBox;
		
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef fillColor = CGColorCreate(rgbColorSpace, (CGFloat[]){0, 0, 0, 0.1});
        
        CGContextSaveGState(_context.pdfContext);
        CGContextSetFillColorWithColor(_context.pdfContext, fillColor);
        CGContextFillRect(_context.pdfContext, frameRect);
        CGContextRestoreGState(_context.pdfContext);
        
        CFRelease(fillColor);
        CFRelease(rgbColorSpace);
    }
	
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
