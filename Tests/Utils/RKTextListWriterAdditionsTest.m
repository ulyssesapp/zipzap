//
//  RKTextListStylingWriterAdditionsTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListWriterAdditions.h"
#import "RKTextListWriterAdditionsTest.h"

@implementation RKTextListWriterAdditionsTest

- (void)testConvertRTFFormatCode
{
    RKTextList *listStyle = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"-- %d0 --", @"-- %r1 --", @"-- %R2 --", @"-- %a3 --", @"-- %A4 --", @"-- * --",nil ]];
    
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 0], RKTextListFormatCodeDecimal, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 1], RKTextListFormatCodeLowerCaseRoman, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 2], RKTextListFormatCodeUpperCaseRoman, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 3], RKTextListFormatCodeLowerCaseLetter, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 4], RKTextListFormatCodeUpperCaseLetter, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 5], RKTextListFormatCodeBullet, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 6], RKTextListFormatCodeBullet, @"Invalid format code");
}

- (void)testBuildRTFFormatStringWithoutPrepending
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list
    RKTextList *simpleList = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"-- %d0 --", nil]];

    testString = [simpleList RTFFormatStringOfLevel:0 withPlaceholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)4, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'07-- \\'00 --", @"Invalid format string");

    // Generating a simple list (only bullet point)
    RKTextList *bulletPoint = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"-", nil]];
    
    testString = [bulletPoint RTFFormatStringOfLevel:0 withPlaceholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)0, @"Invalid count of placeholders");
    
    STAssertEqualObjects(testString, @"\\'01-", @"Invalid format string");
    
    // Generating a simple list with keeping the escpae sign and converting RTF-Chars
    RKTextList *keepingChars = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"%%∮{%d0\\%", nil]];

    testString = [keepingChars RTFFormatStringOfLevel:0 withPlaceholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)4, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'06%\\u8750\\{\\'00\\\\%", @"Invalid format string");
}

- (void)testBuildRTFFormatStringWithMultipleMarkers  
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list with multiple markers
    RKTextList *list = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"", @"", @"%d0.%r1.%A2.", nil ]];

    testString = [list RTFFormatStringOfLevel:2 withPlaceholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)3, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)1, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex: 1] unsignedIntegerValue], (NSUInteger)3, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex: 2] unsignedIntegerValue], (NSUInteger)5, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'06\\'00.\\'01.\\'02.", @"Invalid format string");
}

- (void)testBuildMarkerString
{
    NSArray *itemNumbers = [NSArray arrayWithObjects:
                            [NSNumber numberWithUnsignedInteger:3], 
                            [NSNumber numberWithUnsignedInteger:4], 
                            [NSNumber numberWithUnsignedInteger:5], 
                            [NSNumber numberWithUnsignedInteger:6], 
                            [NSNumber numberWithUnsignedInteger:7],
                            nil
                           ];
    RKTextList *prependingList = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"", @"", @"", @"", @"%d0.%r1.%R2.%a3.%A4.-{%%∮\\}", nil ]];
    
    NSString *string = [prependingList markerForItemNumbers: itemNumbers];
    
    STAssertEqualObjects(string, @"3.iv.V.f.G.-\\{%\\u8750\\\\\\}", @"Invalid marker string generated");
    
    // Invalid levels are ignored
    RKTextList *errorneousList = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"", @"", @"", @"", @"%d0.%r1.%R8.%a3.%A4.-", nil ]];
    NSString *erroneousString = [errorneousList markerForItemNumbers: itemNumbers];
    
    STAssertEqualObjects(erroneousString, @"3.iv.??.f.G.-", @"Invalid marker string generated");

}

@end
