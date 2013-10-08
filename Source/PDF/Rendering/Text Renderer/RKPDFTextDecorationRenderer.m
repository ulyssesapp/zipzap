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

    CGFloat underlineOffset = CTFontGetUnderlinePosition(font) - (CTFontGetUnderlineThickness(font) / 2.0f);
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
    CGFloat strokeWidth = font ? CTFontGetUnderlineThickness(font) : 1.0f;
    if (style & RKUnderlineStyleThick)
		strokeWidth *= 2;

	// Round stroke width and yOffset to prevent scaling issues in PDF
	strokeWidth = round(strokeWidth * 2.0) / 2.0;
	yOffset = round(yOffset * 2.0) / 2.0;
	
    CGContextSetLineWidth(context.pdfContext, strokeWidth);
	
	// Paint stroke
	CGPoint start = CGPointMake(runRect.origin.x, yOffset);
	CGPoint end = CGPointMake(runRect.origin.x + runRect.size.width, yOffset);
	
	CGContextStrokeLineSegments(pdfContext, (CGPoint[]){start, end}, 2);
		
    // Restore graphics state
    CGContextRestoreGState(pdfContext);
}

@end
