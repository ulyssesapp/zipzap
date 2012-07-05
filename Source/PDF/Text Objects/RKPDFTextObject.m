//
//  RKPDFTextObject.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

@implementation RKPDFTextObject

+ (NSString *)attributeName
{
    NSAssert(false, @"Abstract method called");
    return nil;
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex
{
    NSAssert(false, @"Abstract method called");
    return;
}

- (CGFloat)widthUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex
{
    NSAssert(false, @"Abstract method called");
    return 0;
}

- (CGFloat)lineAscentUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex
{
    NSAssert(false, @"Abstract method called");
    return 0;
}

- (CGFloat)lineDescentUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex
{
    NSAssert(false, @"Abstract method called");
    return 0;
}

@end
