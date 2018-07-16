//
//  NSString+RKNumberFormatting.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+RKNumberFormatting.h"

@implementation NSString (RKNumberFormatting)

+ (NSString *)rk_lowerCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number
{
    static NSDictionary *romanNumeralsMap = nil;
    static NSArray *romanNumeralsOrdering = nil;
    
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        romanNumeralsMap = 
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

		romanNumeralsOrdering = [[romanNumeralsMap allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:NO]]];
	});
    
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

+ (NSString *)rk_upperCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number
{
    return [[self rk_lowerCaseRomanNumeralsFromUnsignedInteger:number] uppercaseString];
}

+ (NSString *)rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number
{
    if (number == 0)
        return @"0";
    
    return [NSString stringWithFormat:@"%c", 'a' + (((int)number - 1) % 26) ];
}

+ (NSString *)rk_upperCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number
{
    return [[self rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:number] uppercaseString];
}

+ (NSString *)rk_chicagoManualOfStyleNumeralsFromUnsignedInteger:(NSUInteger)number
{
    static NSArray *markers;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		markers = @[@"*", @"†", @"‡", @"§"];
	});
    
    if (number == 0)
        return @"0";
    
    number -= 1;
    
    NSString *marker = markers[number % 4];
    NSMutableString *numerals = [NSMutableString new];
    
    // The Chicago Manual of Style enumerates: *, †, ‡, §, **, ††, ...
    do {
        [numerals appendString: marker];
	}while (number /= 4);
    
    return numerals;
}

@end
