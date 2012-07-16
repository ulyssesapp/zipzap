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

#import "NSAttributedString+PDFUtilities.h"

#define NSRangeFromCFRange(__range)         NSMakeRange(__range.location, __range.length)

@interface RKPDFFrame ()
{
    CTFrameRef _frame;
    
    NSAttributedString *_attributedString;
    NSRange _sourceRange;
    NSRange _visibleStringRange;
    NSArray *_textObjectRanges;
    RKPDFRenderingContext *_context;
}

@end

@implementation RKPDFFrame

@synthesize visibleStringRange=_visibleStringRange;

- (id)initWithFrame:(CTFrameRef)frame attributedString:(NSAttributedString *)attributedString sourceRange:(NSRange)sourceRange textObjectRanges:(NSArray *)textObjectRanges context:(RKPDFRenderingContext *)context
{
    self = [self init];
    
    if (self) {
        CFRetain(frame);
        _frame = frame;
        
        _attributedString = attributedString;
        _sourceRange = sourceRange;
        _context = context;
        _textObjectRanges = textObjectRanges;
        
        CFRange frameRange = CTFrameGetStringRange(frame);
        
        _visibleStringRange = [self sourceRangeForRange: NSMakeRange(frameRange.location, frameRange.length)];
    }
    
    return self;
}

- (void)dealloc
{
    //CFRelease(_frame);
}

- (CGRect)boundingBox
{
    CGPathRef path = CTFrameGetPath(_frame);
    CGRect boundingBox = CGPathGetBoundingBox(path);
    
    return boundingBox;
}

- (NSRange)sourceRangeForRange:(NSRange)translatedRange
{
    NSRange sourceRange = NSMakeRange(_sourceRange.location + translatedRange.location, translatedRange.length);
    
    #warning To be done!
    
    return sourceRange;
}

- (void)renderWithRenderedRange:(NSRange *)renderedRangeOut renderedBoundingBox:(CGRect *)renderedBoundingBoxOut usingBlock:(void(^)(NSRange lineRange, BOOL *stop))block
{
    __block NSRange renderedRange = NSMakeRange(0, 0);
    __block CGRect renderedBoundingBox = self.boundingBox;
    renderedBoundingBox.size.height = 0;

    NSArray *lines = (__bridge id)CTFrameGetLines(_frame);
    CGPoint *lineOrigins = alloca(lines.count * sizeof(CGPoint));

    CGContextSaveGState(_context.pdfContext);
    CGContextSetTextMatrix(_context.pdfContext, CGAffineTransformIdentity);
    
    CTFrameGetLineOrigins(_frame, CFRangeMake(0,0), lineOrigins);
    
    [lines enumerateObjectsUsingBlock:^(id lineObject, NSUInteger lineIndex, BOOL *stop) {
        CTLineRef line = (__bridge CTLineRef)lineObject;
        CGRect lineRectWithDescent = [self boundingBoxForLine:line usingLineOrigin:lineOrigins[lineIndex] includingDescent:YES];
        CGRect lineRectWithoutDescent = [self boundingBoxForLine:line usingLineOrigin:lineOrigins[lineIndex] includingDescent:NO];
        CFRange lineRange = CTLineGetStringRange(line);
        
        // Query the acceptance of line
        if (block) {
            block([self sourceRangeForRange: NSMakeRange(lineRange.location, lineRange.length)], stop);
            if (*stop)
                return;
        }
        
        // Update rendered range
        renderedRange.length += lineRange.length;
        renderedBoundingBox.size.height += lineRectWithDescent.size.height;
        
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
            if (runAttributes[NSBaselineOffsetAttributeName])
                CGContextSetTextPosition(_context.pdfContext, lineRectWithoutDescent.origin.x, lineRectWithoutDescent.origin.y + [runAttributes[NSBaselineOffsetAttributeName] floatValue]);
            
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
    
    if (renderedBoundingBoxOut)
        *renderedBoundingBoxOut = renderedBoundingBox;
    
    // Restore graphics context
    CGContextRestoreGState(_context.pdfContext);
}

- (CGRect)boundingBoxForLine:(CTLineRef)line usingLineOrigin:(CGPoint)lineOrigin includingDescent:(BOOL)includingDescent
{
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    CGRect boundingBox;
    CGRect frameBounds = self.boundingBox;
    CGRect imageBounds = CTLineGetImageBounds(line, _context.pdfContext);

    boundingBox.origin.x = frameBounds.origin.x + lineOrigin.x;
    boundingBox.origin.y = frameBounds.origin.y + lineOrigin.y - (includingDescent ? descent : 0);
    boundingBox.size.height = ascent + (includingDescent ? descent : 0);
    boundingBox.size.width = imageBounds.size.width;
    
    return boundingBox;
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

@end
