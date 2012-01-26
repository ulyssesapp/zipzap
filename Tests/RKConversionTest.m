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
    NSDateComponents *customComponents = [[NSDateComponents alloc] init];

    [customComponents setYear:2001];
    [customComponents setMonth:2];
    [customComponents setDay:3];
    [customComponents setHour:4];
    [customComponents setMinute:5];
    [customComponents setSecond:6];
    
    NSDate *customDate = [[NSCalendar currentCalendar] dateFromComponents:customComponents];
    
    STAssertEqualObjects([RKConversion RTFDate: customDate],
                         @"\\yr2001 \\mo02 \\dy03 \\hr04 \\min05 \\sec06",
                         @"Invalid date conversion"
                         );
}

@end
