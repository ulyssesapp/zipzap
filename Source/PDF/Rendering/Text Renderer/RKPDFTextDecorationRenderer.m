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

NSString *RKPDFRendererUnderlineAttributeName			= @"RKPDFRendererUnderlineAttributeName";
NSString *RKPDFRendererUnderlineColorAttributeName		= @"RKPDFRendererStrikethroughColorAttributeName";

NSString *RKPDFRendererStrikethroughAttributeName		=@"RKPDFRendererStrikethroughAttributeName";
NSString *RKPDFRendererStrikethroughColorAttributeName	= @"RKPDFRendererStrikethroughColorAttributeName";

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
    NSUInteger strikethroughStyle = [[attributedString attribute:RKPDFRendererStrikethroughAttributeName atIndex:range.location effectiveRange:NULL] unsignedIntegerValue];
	CGColorRef strikethroughColor = (__bridge CGColorRef)[attributedString attribute:RKPDFRendererStrikethroughColorAttributeName atIndex:range.location effectiveRange:NULL];
    CGFloat strikethroughOffset = (runRect.size.height / 2.0) - line.descent;

	if (strikethroughStyle)
		[self renderStyle:strikethroughStyle color:strikethroughColor font:font withYOffset:strikethroughOffset keepDescents:NO usingContext:context run:run boundingBox:runRect];

    // Get underline style, color and position
    NSUInteger underlineStyle = [[attributedString attribute:RKPDFRendererUnderlineAttributeName atIndex:range.location effectiveRange:NULL] unsignedIntegerValue];
	CGColorRef underlineColor = (__bridge CGColorRef)[attributedString attribute:RKPDFRendererUnderlineColorAttributeName atIndex:range.location effectiveRange:NULL];

    CGFloat underlineOffset = CTFontGetUnderlinePosition(font) - (CTFontGetUnderlineThickness(font) / 2.0);
	if (!underlineOffset)
		underlineOffset = -line.descent / 2.0;
	
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

	// Set minimum stroke width for fonts with crappy sizes
	if (strokeWidth < 0.5)
		strokeWidth = 0.5f;
	
	// Round stroke width and yOffset to prevent scaling issues in PDF
	strokeWidth = round(strokeWidth / 0.5) * 0.5;
	yOffset = round(yOffset / 0.5) * 0.5;
	
    CGContextSetLineWidth(context.pdfContext, strokeWidth);
	
	// Paint stroke
	CGPoint start = CGPointMake(runRect.origin.x, yOffset);
	CGPoint end = CGPointMake(runRect.origin.x + runRect.size.width, yOffset);
	
	CGContextStrokeLineSegments(pdfContext, (CGPoint[]){start, end}, 2);
		
    // Restore graphics state
    CGContextRestoreGState(pdfContext);
}

@end
