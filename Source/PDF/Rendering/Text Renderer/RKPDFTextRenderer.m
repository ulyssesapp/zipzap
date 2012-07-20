//
//  RKPDFTextRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextRenderer.h"

@implementation RKPDFTextRenderer

+ (NSInteger)priority
{
    NSAssert(false, @"Abstract method called");
    return 0;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString range:(NSRange)range run:(CTRunRef)run boundingBox:(CGRect)runRect
{
    NSAssert(false, @"Abstract method called");
    return;
}

@end
