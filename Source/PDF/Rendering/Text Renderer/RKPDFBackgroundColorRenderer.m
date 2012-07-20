//
//  RKPDFBackgroundColorRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFBackgroundColorRenderer.h"

#import "RKPDFRenderingContext.h"

NSString *RKPDFBackgroundColorAttributeName = @"RKPDFBackgroundColor";

@implementation RKPDFBackgroundColorRenderer

+ (NSInteger)priority
{
    return -NSIntegerMax;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run boundingBox:(CGRect)runRect
{
    CGColorRef color = (__bridge CGColorRef)[attributedString attribute:RKPDFBackgroundColorAttributeName atIndex:range.location effectiveRange:NULL];
    CGContextRef pdfContext = context.pdfContext;
    
    CGContextSaveGState(pdfContext);

    CGContextSetFillColorWithColor(pdfContext, color);
    CGContextFillRect(context.pdfContext, runRect);
    
    CGContextRestoreGState(pdfContext);
}

@end
