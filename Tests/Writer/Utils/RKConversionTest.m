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
    XCTAssertEqualObjects([@"abc \\ def" RTFEscapedString], @"abc \\\\ def", @"Invalid backslash conversion");
    XCTAssertEqualObjects([@"abc { def" RTFEscapedString], @"abc \\{ def", @"Invalid conversion of {");
    XCTAssertEqualObjects([@"abc } def" RTFEscapedString], @"abc \\} def", @"Invalid conversion of }");
    XCTAssertEqualObjects([@"abc \n def" RTFEscapedString], @"abc \\par\n def", @"Invalid conversion of }");
    XCTAssertEqualObjects([@"abc \t def" RTFEscapedString], @"abc \\tab  def", @"Invalid conversion of }");
    XCTAssertEqualObjects([@"abc \f def" RTFEscapedString], @"abc \\page\n def", @"Invalid conversion of }");    

    // Converting also characters in CP1252 to unicode
    XCTAssertEqualObjects([@"abc ä def" RTFEscapedString], @"abc \\u228  def", @"Invalid unicode conversion");
    
    // Converting a pure unicode charracter
    XCTAssertEqualObjects([@"abc ∮ def" RTFEscapedString], @"abc \\u8750  def", @"Invalid unicode conversion");
}

- (void)testConvertToRTFDate
{
    NSDateComponents *customComponents = [NSDateComponents new];

    // Date with two digits
    [customComponents setYear:2001];
    [customComponents setMonth:12];
    [customComponents setDay:13];
    [customComponents setHour:14];
    [customComponents setMinute:15];
    [customComponents setSecond:16];
    
    NSDate *customDate = [[NSCalendar currentCalendar] dateFromComponents:customComponents];
    
    XCTAssertEqualObjects([customDate RTFDate],
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
    
    XCTAssertEqualObjects([customDate RTFDate],
                         @"\\yr2001 \\mo2 \\dy3 \\hr4 \\min5 \\sec6",
                         @"Invalid date conversion"
                         );    
}

- (void)testConvertToRTFHexData
{
    const char testData[9*16] = 
                           {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
                           };
    NSData *data = [NSData dataWithBytes:testData length:9*16];
    NSString *conversion = [data stringWithRTFHexEncoding];
    
    XCTAssertEqualObjects(conversion, 
                         @"000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f\n"
                          "000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f000102030405060708090a0b0c0d0e0f\n"
                          "000102030405060708090a0b0c0d0e0f",
                         @"Invalid conversion"
                         );
    
    
}

- (void)testSanitizeFilenameForRTFD
{
    XCTAssertEqualObjects(@"foauoaus", [@"föäüóàûß" sanitizedFilenameForRTFD], @"Invalid sanitization of diacritic characters");
    XCTAssertEqualObjects(@"x___x", [@"x\\{}x" sanitizedFilenameForRTFD], @"Invalid sanitization of RTF characters");
    XCTAssertEqualObjects(@"x___x", [@"x?*/x" sanitizedFilenameForRTFD], @"Invalid sanitization of non-filename characters");
    XCTAssertEqualObjects(@"_-", [@"∮-" sanitizedFilenameForRTFD], @"Invalid sanitization of UTF-8 characters");
}

@end
