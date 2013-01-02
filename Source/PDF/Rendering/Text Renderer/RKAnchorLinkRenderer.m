//
//  RKAnchorLinkRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAnchorLinkRenderer.h"

#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFUtilities.h"

@implementation RKAnchorLinkRenderer

+ (NSInteger)priority
{
    return 100;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run line:(RKPDFLine *)line boundingBox:(CGRect)runRect
{
    NSString *anchor = [attributedString attribute:RKPDFAnchorLinkAttributeName atIndex:range.location effectiveRange:NULL];

    // Transform coordinates to current CTM
    runRect = CGRectApplyAffineTransform(runRect, CGContextGetCTM(context.pdfContext));
    
    // Place link
    CGPDFContextSetDestinationForRect(context.pdfContext, (__bridge CFStringRef)anchor, runRect);
}

@end
