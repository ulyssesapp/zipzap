//
//  RKPDFFrame.m
//  RTFKit
//
//  Created by Friedrich Gräter on 11.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFFrame.h"
#import "RKPDFFrame+PrivateFramesetterMethods.h"

#import "RKPDFRenderingContext.h"
#import "RKPDFTextRenderer.h"
#import "RKPDFTextObject.h"
#import "RKRect.h"

#import "NSAttributedString+PDFUtilities.h"

// Helper used to convert CFRange to NSRange
#define NSRangeFromCFRange(__range)         NSMakeRange(__range.location, __range.length)

@interface RKPDFFrame ()
{
    // The core text frame containing the text layout
    CTFrameRef _frame;

    // The rendering context used for this frame
    RKPDFRenderingContext *_context;
    
    // The attributed string in core text representation after instantiating all RKPDFTextObjects
    NSAttributedString *_attributedString;
    
    // The text range in the original source string (used for providing ranges of text lines inside the source string)
    NSRange _sourceRange;

    // Text ranges of all text objects inside the rendered string (used to calculate ranges of text lines inside the source string)
    NSArray *_textObjectRanges;
    
    // The visible string range inside the source string
    NSRange _visibleStringRange;

    // The original bounding box of the frame
    CGRect _boundingBox;
    
    // The bounding box around the visible content of the frame
    CGRect _visibleBoundingBox;
    
    // The bounding boxes around the text lines of the frame with and without descent
    NSArray *_lineRectsWithoutDescent;
    NSArray *_lineRects;
}

/*!
 @abstract Determines the bounding box of a run
 @discussion The height of the run is taken from the given bounding box (which is usually the bounding box of the line containing the run)
 */
- (CGRect)boundingBoxForRun:(CTRunRef)run insideLine:(CTLineRef)line withBoundingBox:(CGRect)lineRect;

/*!
 @abstract Adds text frame markers for debugging during the rendering of a frame.
 */
- (void)renderDebugFramesWithOptions:(RKPDFWriterRenderingOptions)options;

@end

@implementation RKPDFFrame

@synthesize visibleStringRange=_visibleStringRange, lineRects=_lineRects, lineRectsWithoutDescent=_lineRectsWithoutDescent, boundingBox=_boundingBox, visibleBoundingBox=_visibleBoundingBox;

- (id)initWithFrame:(CTFrameRef)frame attributedString:(NSAttributedString *)attributedString sourceRange:(NSRange)sourceRange textObjectRanges:(NSArray *)textObjectRanges context:(RKPDFRenderingContext *)context
{
    self = [self init];
    
    if (self) {
        _frame = frame;
        CFRetain(_frame);
        
        _attributedString = attributedString;
        _sourceRange = sourceRange;
        _context = context;
        _textObjectRanges = textObjectRanges;
        
        CFRange frameRange = CTFrameGetStringRange(frame);
        
        _visibleStringRange = [self sourceRangeForRange: NSMakeRange(frameRange.location, frameRange.length)];
        
        // Determine bounding box
        CGPathRef framePath = CTFrameGetPath(_frame);
        _boundingBox = CGPathGetBoundingBox(framePath);

        // Determine line boundings
        NSMutableArray *lineRects = [NSMutableArray new];
        NSMutableArray *lineRectsWithoutDescent = [NSMutableArray new];
        
        _lineRects = lineRects;
        _lineRectsWithoutDescent = lineRectsWithoutDescent;
        
        NSArray *lines = (__bridge id)CTFrameGetLines(_frame);
        CGPoint *lineOrigins = alloca(lines.count * sizeof(CGPoint));
        CTFrameGetLineOrigins(_frame, CFRangeMake(0,0), lineOrigins);
        
        [lines enumerateObjectsUsingBlock:^(id lineObject, NSUInteger lineIndex, BOOL *stop) {
            CTLineRef line = (__bridge CTLineRef)lineObject;
            CGPoint lineOrigin = lineOrigins[lineIndex];

            CGFloat ascent;
            CGFloat descent;
            CGFloat leading;
            
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            
            CGRect lineRectWithoutDescent;
            CGRect frameBounds = self.boundingBox;
            CGRect imageBounds = CTLineGetImageBounds(line, _context.pdfContext);
            
            lineRectWithoutDescent.origin.x = frameBounds.origin.x + lineOrigin.x;
            lineRectWithoutDescent.origin.y = frameBounds.origin.y + lineOrigin.y;
            lineRectWithoutDescent.size.height = ascent;
            lineRectWithoutDescent.size.width = imageBounds.size.width;
                        
            CGRect lineRectWithDescent = lineRectWithoutDescent;
            lineRectWithDescent.origin.y -= descent;
            lineRectWithDescent.size.height += descent;

            [lineRects addObject: [RKRect rectWithRect: lineRectWithDescent]];
            [lineRectsWithoutDescent addObject: [RKRect rectWithRect: lineRectWithoutDescent]];
        }];

        // Determine visible size
        _visibleBoundingBox = _boundingBox;
        _visibleBoundingBox.size.height = 0;
        
        if (lineRects.count) {
            CGRect firstLineBox = [lineRects[0] rectValue];
            CGRect lastLineBox = [lineRects.lastObject rectValue];

            _visibleBoundingBox.size.height = (firstLineBox.origin.y + firstLineBox.size.height) - lastLineBox.origin.y;
            _visibleBoundingBox.origin.y = lastLineBox.origin.y;
        }
    }
    
    return self;
}

- (void)dealloc
{
    CFRelease(_frame);
}

- (NSRange)sourceRangeForRange:(NSRange)frameRange
{
    NSRange translatedRange = NSMakeRange(frameRange.location, frameRange.length);
    
    for (NSValue *rangeObject in _textObjectRanges) {
        NSRange textObjectRange = rangeObject.rangeValue;
        
        // The translated range is after the text object range: we just crop the expanded length of the text object
        if (frameRange.location >= (textObjectRange.location + textObjectRange.length)) {
            translatedRange.location -= textObjectRange.length - 1;
            continue;
        }
        
        // The translated range is inside the text object range: we set it to its beginning and crop the overlapping length
        if ((frameRange.location >= textObjectRange.location) && (frameRange.location < textObjectRange.location + textObjectRange.length)) {
            translatedRange.length -= (textObjectRange.length + textObjectRange.location) - frameRange.location -+ 1;
            translatedRange.location -= (frameRange.location - textObjectRange.location);
            continue;
        }
        
        // The translated range contains the text object: we crop the text object out of its length
        if ((frameRange.location <= textObjectRange.location) && ((frameRange.location + frameRange.length) >= (textObjectRange.location + textObjectRange.length))) {
            translatedRange.length -= textObjectRange.length - 1;
            continue;
        }
    }
    
    return NSMakeRange(translatedRange.location + _sourceRange.location, translatedRange.length);
}

- (void)renderWithRenderedRange:(NSRange *)renderedRangeOut usingOrigin:(CGPoint)origin options:(RKPDFWriterRenderingOptions)options block:(void (^)(NSRange, CGRect, NSUInteger, BOOL *))block
{
    __block NSRange renderedRange = NSMakeRange(0, 0);

    NSArray *lines = (__bridge id)CTFrameGetLines(_frame);

    // We move the coordinate system to the actual drawing origin
    CGContextSaveGState(_context.pdfContext);
    CGContextTranslateCTM(_context.pdfContext, origin.x - self.boundingBox.origin.x, origin.y - self.boundingBox.origin.y);
    CGContextSetTextMatrix(_context.pdfContext, CGAffineTransformIdentity);

    // Only used for debugging: Draw text frames
    [self renderDebugFramesWithOptions: options];
    
    // Render lines
    [lines enumerateObjectsUsingBlock:^(id lineObject, NSUInteger lineIndex, BOOL *stop) {
        CTLineRef line = (__bridge CTLineRef)lineObject;
        CGRect lineRectWithDescent = [self.lineRects[lineIndex] rectValue];
        CGRect lineRectWithoutDescent = [self.lineRectsWithoutDescent[lineIndex] rectValue];
        CFRange lineRange = CTLineGetStringRange(line);
        
        // Query the acceptance of line
        if (block) {
            *stop = NO;

            block([self sourceRangeForRange: NSMakeRange(lineRange.location, lineRange.length)], lineRectWithDescent, lineIndex, stop);
            if (*stop)
                return;
        }
        
        // Update rendered range
        renderedRange.length += lineRange.length;
        
        // Apply text renderer
        NSArray *runs = (__bridge id)CTLineGetGlyphRuns(line);
        CGContextSetTextPosition(_context.pdfContext, lineRectWithoutDescent.origin.x, lineRectWithoutDescent.origin.y);
        
        for (NSUInteger runIndex = 0; runIndex < runs.count; runIndex ++) {
            CGContextSaveGState(_context.pdfContext);
            
            CTRunRef run = (__bridge CTRunRef)[runs objectAtIndex: runIndex];
            
            // Calculate the position of the run
            CFRange runRange = CTRunGetStringRange(run);
            CGRect runRect = [self boundingBoxForRun:run insideLine:line withBoundingBox:lineRectWithDescent];
            
            NSDictionary *runAttributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
            
            // Apply baseline offset, if any
            CGContextSetTextPosition(_context.pdfContext, lineRectWithoutDescent.origin.x, lineRectWithoutDescent.origin.y + [runAttributes[RKBaselineOffsetAttributeName] floatValue]);

            // Apply pre-renderer (negative priority)
            NSArray *renderers = runAttributes[RKTextRendererAttributeName];
            NSInteger rendererIndex = 0;
            
            for (; rendererIndex < renderers.count; rendererIndex ++) {
                Class renderer = [renderers objectAtIndex: rendererIndex];
                if ([renderer priority] > 0)
                    break;

                [renderer renderUsingContext:_context attributedString:_attributedString range:NSRangeFromCFRange(runRange) run:run boundingBox:runRect];
            }
            
            // Render run (if there is no replacing renderer)
            CTRunDraw(run, _context.pdfContext, CFRangeMake(0,0));

            // Apply text-object renderer
            RKPDFTextObject *textObject = runAttributes[RKTextObjectAttributeName];
            if (textObject)
                [textObject renderUsingContext:_context rect:runRect];
            
            // Apply post-renderer (positive priority)
            for (; rendererIndex < renderers.count; rendererIndex ++) {
                Class renderer = [renderers objectAtIndex: rendererIndex];
                [renderer renderUsingContext:_context attributedString:_attributedString range:NSRangeFromCFRange(runRange) run:run boundingBox:runRect];
            }
            
            CGContextRestoreGState(_context.pdfContext);
        }
    }];
    
    // Provide stats about the actually rendered frame
    if (renderedRangeOut)
        *renderedRangeOut = [self sourceRangeForRange: renderedRange];
    
    // Restore graphics context
    CGContextRestoreGState(_context.pdfContext);
}

- (CGRect)boundingBoxForRun:(CTRunRef)run insideLine:(CTLineRef)line withBoundingBox:(CGRect)lineRect
{
    const CGSize *glyphAdvances = CTRunGetAdvancesPtr(run);
    CGFloat runWidth = 0;
    NSUInteger glyphCount = CTRunGetGlyphCount(run);
    
    while (glyphCount --)
        runWidth += glyphAdvances[glyphCount].width;
    
    CFRange runRange = CTRunGetStringRange(run);
    CGRect runRect = CGRectMake(lineRect.origin.x + CTLineGetOffsetForStringIndex(line, runRange.location, NULL), lineRect.origin.y, runWidth, lineRect.size.height);

    return runRect;
}

- (void)renderDebugFramesWithOptions:(RKPDFWriterRenderingOptions)options
{
    // Add bounding boxes around text, if requested
    if (options & RKPDFWriterShowTextFrames) {
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
    if (options & RKPDFWriterShowBoundingBoxes) {
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
