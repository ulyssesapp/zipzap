//
//  RKPDFTextObject.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

@implementation RKPDFTextObject

- (CGFloat)preferredHeightForMaximumSize:(CGSize)frameSize
{
	return 0;
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context rect:(CGRect)rect
{
    return;
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex frameSize:(CGSize)size
{
    NSAssert(false, @"Abstract method called");
    return nil;
}

@end
