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

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run boundingBox:(CGRect)runRect
{
    NSString *anchor = [attributedString attribute:RKPDFAnchorAttributeName atIndex:range.location effectiveRange:NULL];
    
    CGPDFContextAddDestinationAtPoint(context.pdfContext, (__bridge CFStringRef)anchor, runRect.origin);
}

@end
