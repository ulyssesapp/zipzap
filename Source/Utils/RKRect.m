//
//  RKRect.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKRect.h"

@implementation RKRect

@synthesize rectValue=_rectValue;

+ (RKRect *)rectWithRect:(CGRect)rect
{
    return [[RKRect alloc] initWithRect: rect];
}

- (id)initWithRect:(CGRect)rect
{
    self = [self init];
    
    if (self)
        _rectValue = rect;
    
    return self;
}

@end
