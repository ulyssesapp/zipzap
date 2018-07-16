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
    XCTAssertEqualObjects([NSString rk_lowerCaseRomanNumeralsFromUnsignedInteger:0],
                         @"0",
                         @"Invalid conversion"
                         );

    XCTAssertEqualObjects([NSString rk_lowerCaseRomanNumeralsFromUnsignedInteger:1],
                         @"i",
                         @"Invalid conversion"
                         );

    XCTAssertEqualObjects([NSString rk_lowerCaseRomanNumeralsFromUnsignedInteger:2],
                         @"ii",
                         @"Invalid conversion"
                         );

    XCTAssertEqualObjects([NSString rk_lowerCaseRomanNumeralsFromUnsignedInteger:4],
                         @"iv",
                         @"Invalid conversion"
                         );
    
    XCTAssertEqualObjects([NSString rk_upperCaseRomanNumeralsFromUnsignedInteger:1984],
                         @"MXCLXXXIV",
                         @"Invalid conversion"
                         );
}

- (void)testAlphabeticNumerals
{
    XCTAssertEqualObjects([NSString rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:0],
                         @"0",
                         @"Invalid conversion"
                         );
    
    XCTAssertEqualObjects([NSString rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:1],
                         @"a",
                         @"Invalid conversion"
                         );
    
    XCTAssertEqualObjects([NSString rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:2],
                         @"b",
                         @"Invalid conversion"
                         );
    
    XCTAssertEqualObjects([NSString rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:26],
                         @"z",
                         @"Invalid conversion"
                         );

    XCTAssertEqualObjects([NSString rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:27],
                         @"a",
                         @"Invalid conversion"
                         );
    
    XCTAssertEqualObjects([NSString rk_upperCaseAlphabeticNumeralsFromUnsignedInteger:28],
                         @"B",
                         @"Invalid conversion"
                         );
    
    XCTAssertEqualObjects([NSString rk_upperCaseAlphabeticNumeralsFromUnsignedInteger:53],
                         @"A",
                         @"Invalid conversion"
                         );    
}

@end
