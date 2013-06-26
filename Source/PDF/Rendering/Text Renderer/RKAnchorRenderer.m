//
//  RKAnchorRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAnchorRenderer.h"

#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFUtilities.h"

@implementation RKAnchorRenderer

+ (NSInteger)priority
{
    return 100;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run line:(RKPDFLine *)line boundingBox:(CGRect)runRect
{
    NSString *anchor = [attributedString attribute:RKPDFAnchorAttributeName atIndex:range.location effectiveRange:NULL];
 
    // Transform coordinates to current CTM
    runRect = CGRectApplyAffineTransform(runRect, CGContextGetCTM(context.pdfContext));
    
    // Displace destination rect, so we do not jump under the baseline of the run that should be linked
    runRect.origin.y += runRect.size.height;
    runRect.size.height = 1;
    
    // Place anchor
    CGPDFContextAddDestinationAtPoint(context.pdfContext, (__bridge CFStringRef)anchor, runRect.origin);
}

@end
