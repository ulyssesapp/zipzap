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
    STAssertEqualObjects([@"\\" RTFEscapedString], @"\\\\", @"Invalid backslash conversion");
    STAssertEqualObjects([@"{" RTFEscapedString], @"\\{", @"Invalid conversion of {");
    STAssertEqualObjects([@"}" RTFEscapedString], @"\\}", @"Invalid conversion of }");
}

- (void)testConvertToRTFDate
{
    NSDateComponents *customComponents = [[NSDateComponents alloc] init];

    // Date with two digits
    [customComponents setYear:2001];
    [customComponents setMonth:12];
    [customComponents setDay:13];
    [customComponents setHour:14];
    [customComponents setMinute:15];
    [customComponents setSecond:16];
    
    NSDate *customDate = [[NSCalendar currentCalendar] dateFromComponents:customComponents];
    
    STAssertEqualObjects([customDate RTFDate],
                         @"\\yr2001 \\mo12 \\dy13 \\hr14 \\min15 \\sec16",
                         @"Invalid date conversion"
                         );
    
    // Date with single digits
    [customComponents setYear:2001];
    [customComponents setMonth:2];
    [customComponents setDay:3];
    [customComponents setHour:4];
    [customComponents setMinute:5];
    [customComponents setSecond:6];
    
   customDate = [[NSCalendar currentCalendar] dateFromComponents:customComponents];
    
    STAssertEqualObjects([customDate RTFDate],
                         @"\\yr2001 \\mo2 \\dy3 \\hr4 \\min5 \\sec6",
                         @"Invalid date conversion"
                         );    
}

@end
