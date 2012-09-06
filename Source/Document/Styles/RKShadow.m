//
//  RKShadow.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKShadow.h"

#if TARGET_OS_IPHONE
@implementation RKShadow

@synthesize shadowBlurRadius, shadowOffset, shadowColor;

- (BOOL)isEqual:(RKShadow *)other
{
    if (![other isKindOfClass: RKShadow.class])
        return NO;
    
    return (self.shadowBlurRadius == other.shadowBlurRadius) && (self.shadowOffset.width == other.shadowOffset.width) && (self.shadowOffset.height == other.shadowOffset.height) && (CGColorEqualToColor(self.shadowColor, other.shadowColor));
}

@end
#endif
