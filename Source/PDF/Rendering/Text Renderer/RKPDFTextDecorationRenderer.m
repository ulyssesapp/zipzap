//
//  RKPDFStrikethroughRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextDecorationRenderer.h"

#import "RKPDFLine.h"
#import "RKPDFRenderingContext.h"

NSString *RKPDFStrikethroughColorAttributeName = @"RKPDFStrikethroughColor";

@implementation RKPDFTextDecorationRenderer

+ (NSInteger)priority
{
    return NSIntegerMax;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run line:(RKPDFLine *)line boundingBox:(CGRect)runRect
{
	// Get font to determine stroke
    CTFontRef font = (__bridge CTFontRef)[attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
	
    // Get strikethrough style, color and position
    NSUInteger strikethroughStyle = [[attributedString attribute:RKStrikethroughStyleAttributeName atIndex:range.location effectiveRange:NULL] unsignedIntegerValue];
	CGColorRef strikethroughColor = (__bridge CGColorRef)[attributedString attribute:RKPDFStrikethroughColorAttributeName atIndex:range.location effectiveRange:NULL];
    CGFloat strikethroughOffset = (runRect.size.height / 2.0f) - line.descent;

	if (strikethroughStyle)
		[self renderStyle:strikethroughStyle color:strikethroughColor font:font withYOffset:strikethroughOffset keepDescents:NO usingContext:context run:run boundingBox:runRect];

    // Get underline style, color and position
    NSUInteger underlineStyle = [[attributedString attribute:(__bridge id)kCTUnderlineStyleAttributeName atIndex:range.location effectiveRange:NULL] unsignedIntegerValue];
	CGColorRef underlineColor = (__bridge CGColorRef)[attributedString attribute:(__bridge id)kCTUnderlineColorAttributeName atIndex:range.location effectiveRange:NULL];
    CGFloat underlineOffset = CTFontGetUnderlinePosition(font);
	
	if (!underlineOffset)
		underlineOffset = -line.descent / 2.0f;
	
	if (underlineStyle)
		[self renderStyle:underlineStyle color:underlineColor font:font withYOffset:underlineOffset keepDescents:YES usingContext:context run:run boundingBox:runRect];
}

+ (void)renderStyle:(NSUInteger)style color:(CGColorRef)color font:(CTFontRef)font withYOffset:(CGFloat)yOffset keepDescents:(BOOL)keepDescents usingContext:(RKPDFRenderingContext *)context run:(CTRunRef)run boundingBox:(CGRect)runRect
{
    // Save drawing state
    CGContextRef pdfContext = context.pdfContext;
    CGContextSaveGState(pdfContext);
    
    // Set stroke color
    if (color)
        CGContextSetStrokeColorWithColor(pdfContext, color);
    else {
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceGray();
        CGColorRef blackColor = CGColorCreate(colorspace, (CGFloat[]){0, 1.0});
        CGContextSetStrokeColorWithColor(pdfContext, blackColor);
        CFRelease(blackColor);
    }
	
    // Set stroke width
    CGFloat strokeWidth = font ? CTFontGetUnderlineThickness(font)  : 1.0f;
	
    if (style & RKUnderlineStyleThick)
		strokeWidth *= 2;
	
    CGContextSetLineWidth(context.pdfContext, strokeWidth);
    
	// Paint stroke glyph-by-glyph
	CFIndex glyphCount = CTRunGetGlyphCount(run);
	const CGPoint *glyphPositions = CTRunGetPositionsPtr(run);
	const CGSize *glyphAdvances = CTRunGetAdvancesPtr(run);
	const CGGlyph *glyphs = CTRunGetGlyphsPtr(run);
	CGRect glyphBounds[glyphCount];
	
	if (glyphs && glyphCount) {
		CTFontGetBoundingRectsForGlyphs(font, kCTFontDefaultOrientation, glyphs, glyphBounds, glyphCount);
		
		CGContextBeginPath(pdfContext);
		
		while (glyphCount --) {
			CGPoint glyphPosition = glyphPositions[glyphCount];
			CGSize glyphAdvance = glyphAdvances[glyphCount];
			CGRect glyphBound = glyphBounds[glyphCount];
		
			// If word-wise stroking is requested, ignore empty glyphs
			BOOL closePath = ((style & RKUnderlineByWordMask) && (glyphBound.size.width == 0));

			// Do we need to close the current path?
			if (closePath) {
				if (!CGContextIsPathEmpty(pdfContext)) {
					CGContextClosePath(pdfContext);
					CGContextStrokePath(pdfContext);
					CGContextBeginPath(pdfContext);
				}
				
				continue;
			}
			
			// Get stroke position
			CGPoint startPoint = glyphPosition;
			startPoint.y += yOffset;
			
			CGPoint endPoint = startPoint;
			endPoint.x += glyphAdvance.width + 0.5f;

			if (CGContextIsPathEmpty(pdfContext))
				CGContextMoveToPoint(pdfContext, startPoint.x, startPoint.y);
			else
				CGContextAddLineToPoint(pdfContext, startPoint.x, startPoint.y);
			
			CGContextAddLineToPoint(pdfContext, endPoint.x, endPoint.y);
		}

		if (!CGContextIsPathEmpty(pdfContext)) {
			CGContextClosePath(pdfContext);
			CGContextStrokePath(pdfContext);
		}
	}
		
    // Restore graphics state
    CGContextRestoreGState(pdfContext);
}

@end
