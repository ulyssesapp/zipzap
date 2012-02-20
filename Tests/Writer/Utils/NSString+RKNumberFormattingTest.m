//
//  RKNumberFormattingTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+RKNumberFormatting.h"
#import "NSString+RKNumberFormattingTest.h"

@implementation RKNumberFormattingTest

- (void)testRomanNumerals
{
    STAssertEqualObjects([NSString lowerCaseRomanNumeralsFromUnsignedInteger:0],
                         @"0",
                         @"Invalid conversion"
                         );

    STAssertEqualObjects([NSString lowerCaseRomanNumeralsFromUnsignedInteger:1],
                         @"i",
                         @"Invalid conversion"
                         );

    STAssertEqualObjects([NSString lowerCaseRomanNumeralsFromUnsignedInteger:2],
                         @"ii",
                         @"Invalid conversion"
                         );

    STAssertEqualObjects([NSString lowerCaseRomanNumeralsFromUnsignedInteger:4],
                         @"iv",
                         @"Invalid conversion"
                         );
    
    STAssertEqualObjects([NSString upperCaseRomanNumeralsFromUnsignedInteger:1984],
                         @"MXCLXXXIV",
                         @"Invalid conversion"
                         );
}

- (void)testAlphabeticNumerals
{
    STAssertEqualObjects([NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger:0],
                         @"0",
                         @"Invalid conversion"
                         );
    
    STAssertEqualObjects([NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger:1],
                         @"a",
                         @"Invalid conversion"
                         );
    
    STAssertEqualObjects([NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger:2],
                         @"b",
                         @"Invalid conversion"
                         );
    
    STAssertEqualObjects([NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger:26],
                         @"z",
                         @"Invalid conversion"
                         );

    STAssertEqualObjects([NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger:27],
                         @"a",
                         @"Invalid conversion"
                         );
    
    STAssertEqualObjects([NSString upperCaseAlphabeticNumeralsFromUnsignedInteger:28],
                         @"B",
                         @"Invalid conversion"
                         );
    
    STAssertEqualObjects([NSString upperCaseAlphabeticNumeralsFromUnsignedInteger:53],
                         @"A",
                         @"Invalid conversion"
                         );    
}

@end
