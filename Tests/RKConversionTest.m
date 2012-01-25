//
//  RKConversionTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversion.h"
#import "RKConversionTest.h"

@implementation RKConversionTest

- (void)testConvertToRTFString
{
    STAssertEqualObjects([RKConversion safeRTFString: @"\\"], @"\\\\", @"Invalid backslash conversion");
    STAssertEqualObjects([RKConversion safeRTFString: @"{"], @"\\{", @"Invalid conversion of {");
    STAssertEqualObjects([RKConversion safeRTFString: @"}"], @"\\}", @"Invalid conversion of }");
}

- (void)testConvertToRTFDate
{
    #warning FIXME: Adapt date to time zone

    STAssertEqualObjects([RKConversion RTFDate: [NSDate dateWithString: @"2001-02-03 04:05:06 +0100"]],
                         @"\\yr2001 \\mo02 \\dy03 \\hr04 \\min05 \\sec06",
                         @"Invalid date conversion"
                         );
}

@end
