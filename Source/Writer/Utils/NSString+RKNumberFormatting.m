//
//  NSString+RKNumberFormatting.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+RKNumberFormatting.h"

@implementation NSString (RKNumberFormatting)

+ (NSString *)lowerCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number
{
    static NSDictionary *romanNumeralsMap = nil;
    static NSArray *romanNumeralsOrdering = nil;
    
    romanNumeralsMap = (romanNumeralsMap) ?: 
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"i", [NSNumber numberWithUnsignedInteger:1],
         @"x", [NSNumber numberWithUnsignedInteger:10],
         @"c", [NSNumber numberWithUnsignedInteger:100],
         @"m", [NSNumber numberWithUnsignedInteger:1000],
         @"iv", [NSNumber numberWithUnsignedInteger:4],
         @"xl", [NSNumber numberWithUnsignedInteger:40],
         @"cd", [NSNumber numberWithUnsignedInteger:400],
         @"v", [NSNumber numberWithUnsignedInteger:5],
         @"l", [NSNumber numberWithUnsignedInteger:50],
         @"d", [NSNumber numberWithUnsignedInteger:500],
         @"ix", [NSNumber numberWithUnsignedInteger:9],
         @"xc", [NSNumber numberWithUnsignedInteger:900],
         @"cm", [NSNumber numberWithUnsignedInteger:9000],                          
         nil
        ];

    romanNumeralsOrdering = (romanNumeralsOrdering) ?:
        [[romanNumeralsMap allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO]]];    
    
    if (number == 0)
        return @"0";

    NSMutableString *romanNumber = [NSMutableString new];
    NSUInteger remainder = number;
    
    for (NSNumber *numeralValueObject in romanNumeralsOrdering) {
        NSUInteger numeralValue = [numeralValueObject unsignedIntegerValue];
        
        while (remainder >= numeralValue) {
            [romanNumber appendString:  [romanNumeralsMap objectForKey: numeralValueObject]];
            remainder -= numeralValue;
        }
    }
    
    return romanNumber;
}

+ (NSString *)upperCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number
{
    return [[self lowerCaseRomanNumeralsFromUnsignedInteger:number] uppercaseString];
}

+ (NSString *)lowerCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number
{
    if (number == 0)
        return @"0";
    
    return [NSString stringWithFormat:@"%c", 'a' + ((number - 1) % 26) ];
}

+ (NSString *)upperCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number
{
    return [[self lowerCaseAlphabeticNumeralsFromUnsignedInteger:number] uppercaseString];
}

@end
