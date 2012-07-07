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
        @{@1U: @"i",
         @10U: @"x",
         @100U: @"c",
         @1000U: @"m",
         @4U: @"iv",
         @40U: @"xl",
         @400U: @"cd",
         @5U: @"v",
         @50U: @"l",
         @500U: @"d",
         @9U: @"ix",
         @900U: @"xc",
         @9000U: @"cm"};

    romanNumeralsOrdering = (romanNumeralsOrdering) ?:
        [[romanNumeralsMap allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:NO]]];    
    
    if (number == 0)
        return @"0";

    NSMutableString *romanNumber = [NSMutableString new];
    NSUInteger remainder = number;
    
    for (NSNumber *numeralValueObject in romanNumeralsOrdering) {
        NSUInteger numeralValue = [numeralValueObject unsignedIntegerValue];
        
        while (remainder >= numeralValue) {
            [romanNumber appendString:  romanNumeralsMap[numeralValueObject]];
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
    
    return [NSString stringWithFormat:@"%c", 'a' + (((int)number - 1) % 26) ];
}

+ (NSString *)upperCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number
{
    return [[self lowerCaseAlphabeticNumeralsFromUnsignedInteger:number] uppercaseString];
}

+ (NSString *)chicagoManualOfStyleNumeralsFromUnsignedInteger:(NSUInteger)number
{
    static NSArray *markers;
    markers = @[@"*", @"†", @"‡", @"§"];
    
    if (number == 0)
        return @"0";
    
    number -= 1;
    
    NSString *marker = markers[number % 4];
    NSMutableString *numerals = [NSMutableString new];
    
    // The Chicago Manual of Style enumerates: *, †, ‡, §, **, ††, ...
    while (number /= 4)
        [numerals appendString: marker];
    
    return numerals;
}

@end
