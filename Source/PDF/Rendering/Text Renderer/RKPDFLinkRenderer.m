//
//  RKPDFLinkRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFLinkRenderer.h"

#import "RKPDFRenderingContext.h"

@implementation RKPDFLinkRenderer

+ (NSInteger)priority
{
    return 100;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run boundingBox:(CGRect)runRect
{
    id link = [attributedString attribute:NSLinkAttributeName atIndex:range.location effectiveRange:NULL];
    NSURL *URL;
    
    if ([link isKindOfClass: NSString.class])
        URL = [NSURL URLWithString: link];
    else if ([link isKindOfClass: NSURL.class])
        URL = link;
    else
        NSAssert(false, @"Invalid argument");
    
    CGPDFContextSetURLForRect(context.pdfContext, (__bridge CFURLRef)URL, runRect);
}

@end
