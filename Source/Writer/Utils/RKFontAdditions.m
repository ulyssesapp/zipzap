//
//  RKFontAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFontAdditions.h"

@implementation NSFont (RKDefaults)

+ (NSFont *)RTFdefaultFont
{
    return [NSFont fontWithName:@"Helvetica" size:12];
}

@end
