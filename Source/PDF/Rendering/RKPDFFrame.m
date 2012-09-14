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
		
		while (remainingParagraphRange.length > 0) {
			BOOL isFirstLineOfParagraph = !lineOfParagraph;

			// Suggested width
			CGFloat suggestedWidth = [self maximumWidthForAttributedString:attributedString inRange:remainingParagraphRange isFirstInParagraph:isFirstLineOfParagraph];
			
			// Layout line
			RKPDFLine *line = [[RKPDFLine alloc] initWithAttributedString:attributedString inRange:remainingParagraphRange usingWidth:suggestedWidth maximumHeight:_boundingBox.size.height context:_context];
			NSRange lineRange = line.visibleRange;
			
			// Determine line placement
			BOOL isLastLineOfParagraph = (remainingParagraphRange.location + lineRange.length) == NSMaxRange(paragraphRange);
			
			CGFloat yOffset = 0;
			CGRect lineRect = [self rectForLine:line isFirstInParagraph:isFirstLineOfParagraph isLastInParagraph:isLastLineOfParagraph yOffset:&yOffset];

			// Stop, if there is not enough place for this line (if it is the first line of the frame, we accept it anyway, to prevent endless loops)
			if (((lineRect.size.height + _visibleBoundingBox.size.height) > _maximumHeight) && (_visibleBoundingBox.size.height > 0)) {
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
				RKPDFLine *succeedingLine = [[RKPDFLine alloc] initWithAttributedString:attributedString inRange:succeedingLineRange usingWidth:widowWidth maximumHeight:_maximumHeight context:_context];
				nextLineHeight = succeedingLine.size.height;
				
				widowFollows = NSMaxRange(succeedingLine.visibleRange) == NSMaxRange(remainingParagraphRange);
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
		_visibleBoundingBox.size.height -= line.size.height;
		
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

- (CGRect)rectForLine:(RKPDFLine *)line isFirstInParagraph:(BOOL)isFirstInParagraph isLastInParagraph:(BOOL)isLastInParagraph yOffset:(CGFloat *)yOffsetOut
{
	RKParagraphStyleWrapper *paragraphStyle = line.paragraphStyle;
	CGRect lineRect;
	CGFloat yOffset = 0;
	
	// Determine line origin
	lineRect.origin = CGPointMake(_visibleBoundingBox.origin.x, _visibleBoundingBox.origin.y - line.size.height);
	lineRect.size = line.size;
	
	// Apply indentation
	if (isFirstInParagraph)
		lineRect.origin.x += paragraphStyle.firstLineHeadIndent;
	else
		lineRect.origin.x += paragraphStyle.headIndent;
	
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
	
	// Apply paragraph spacing
	if (isFirstInParagraph) {
		CGFloat spacingBefore = paragraphStyle.paragraphSpacingBefore;
		
		lineRect.origin.y -= spacingBefore;
		lineRect.size.height += spacingBefore;
	}
	
	if (isLastInParagraph) {
		CGFloat spacingAfter = paragraphStyle.paragraphSpacing;
		
		lineRect.origin.y -= spacingAfter;
		lineRect.size.height += spacingAfter;
		yOffset += spacingAfter;
	}
	
	// Apply line spacing
	CGFloat lineSpacing = paragraphStyle.lineSpacing;
	lineRect.origin.y -= lineSpacing;
	lineRect.size.height += lineSpacing;
	yOffset += lineSpacing;

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
	
	CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[attributedString attribute:(__bridge NSString*)kCTParagraphStyleAttributeName atIndex:range.location effectiveRange:NULL];
	CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent);
	CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent);
	
	if (isFirstInParagraph && (firstLineHeadIndent < width))
		width -= firstLineHeadIndent;
	else if (headIndent < width)
		width -= headIndent;
	
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
	return (expectedLineHeight + _visibleBoundingBox.size.height) <= self.maximumHeight;
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
