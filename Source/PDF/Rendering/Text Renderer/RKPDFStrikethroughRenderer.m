//
//  RKPDFStrikethroughRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFStrikethroughRenderer.h"

#import "RKPDFRenderingContext.h"

NSString *RKPDFStrikethroughColorAttributeName = @"RKPDFStrikethroughColor";

@implementation RKPDFStrikethroughRenderer

+ (NSInteger)priority
{
    return NSIntegerMax;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run boundingBox:(CGRect)runRect
{
    NSFont *font = [attributedString attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];    
    
    // Get strikethrough style
    NSUInteger style = [[attributedString attribute:NSStrikethroughStyleAttributeName atIndex:range.location effectiveRange:NULL] unsignedIntegerValue];
    if (!style)
        return;

    // Get strikethrough position
    CGPoint startPoint = runRect.origin;
    startPoint.y += runRect.size.height / 2;
    
    CGFloat baselineOffset = [[attributedString attribute:NSBaselineOffsetAttributeName atIndex:range.location effectiveRange:NULL] floatValue];
    startPoint.y += baselineOffset / 2;
    
    CGPoint endPoint = startPoint;
    endPoint.x += runRect.size.width;
    
    // Save drawing state
    CGContextRef pdfContext = context.pdfContext;
    CGContextSaveGState(pdfContext);
    
    // Set color for strikethrough
    CGColorRef color = (__bridge CGColorRef)[attributedString attribute:RKPDFStrikethroughColorAttributeName atIndex:range.location effectiveRange:NULL];
    if (color)
        CGContextSetStrokeColorWithColor(pdfContext, color);
    else {
        CGColorRef blackColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        CGContextSetStrokeColorWithColor(pdfContext, blackColor);
        CFRelease(blackColor);
    }

    // Set stroke width
    CGFloat strokeWidth = font ? font.underlineThickness : 1.0f;

    if (style & NSUnderlineStyleThick)
        CGContextSetLineWidth(context.pdfContext, strokeWidth * 2);
    else
        CGContextSetLineWidth(context.pdfContext, strokeWidth);
    
    // Paint stroke
    CGContextStrokeLineSegments(context.pdfContext, (CGPoint[]){startPoint, endPoint}, 2);
    
    // Restore graphics state
    CGContextRestoreGState(pdfContext);
}

@end
