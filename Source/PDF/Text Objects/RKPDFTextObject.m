//
//  RKPDFTextObject.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

@implementation RKPDFTextObject

- (void)renderUsingContext:(RKPDFRenderingContext *)context rect:(CGRect)rect
{
    return;
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex
{
    NSAssert(false, @"Abstract method called");
    return nil;
}

@end
