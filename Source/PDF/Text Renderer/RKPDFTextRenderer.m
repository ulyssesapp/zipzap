//
//  RKPDFTextRenderer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextRenderer.h"

@implementation RKPDFTextRenderer

+ (NSUInteger)priority
{
    NSAssert(false, @"Abstract method called");
    return 0;
}

+ (void)renderUsingContext:(RKPDFRenderingContext *)context run:(CTRunRef)run
{
    NSAssert(false, @"Abstract method called");
    return;
}

@end
