//
//  RKStringConvenienceAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 15.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStringConvenienceAdditions.h"

@implementation NSString (RKStringConvenienceAdditions)

+ (NSString *)stringWithRTFGroupTag:(NSString *)tag body:(NSString *)body
{
    return [NSString stringWithFormat:@"{\\%@ %@}", tag, body];
}

@end
