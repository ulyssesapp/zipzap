//
//  RKListStyle+WriterAdditionsTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+WriterAdditionsTest.h"
#import "RKListStyle+WriterAdditions.h"

@implementation RKListStyleWriterAdditionsTest

- (void)testConvertRTFFormatCode
{
    RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: 
                                                                  @"-- %d --", 
                                                                  @"-- %r --", 
                                                                  @"-- %R --", 
                                                                  @"-- %a --", 
                                                                  @"-- %A --", 
                                                                  @"-- * --",
                                                                  nil ]];
    
    STAssertEquals([listStyle formatCodeOfLevel: 0], RKListFormatCodeDecimal, @"Invalid format code");
    STAssertEquals([listStyle formatCodeOfLevel: 1], RKListFormatCodeLowerCaseRoman, @"Invalid format code");
    STAssertEquals([listStyle formatCodeOfLevel: 2], RKListFormatCodeUpperCaseRoman, @"Invalid format code");
    STAssertEquals([listStyle formatCodeOfLevel: 3], RKListFormatCodeLowerCaseLetter, @"Invalid format code");
    STAssertEquals([listStyle formatCodeOfLevel: 4], RKListFormatCodeUpperCaseLetter, @"Invalid format code");
    STAssertEquals([listStyle formatCodeOfLevel: 5], RKListFormatCodeBullet, @"Invalid format code");
    
    // Invalid level selected
    STAssertEquals([listStyle formatCodeOfLevel: 8], RKListFormatCodeBullet, @"Invalid format code");
}

- (void)testBuildRTFFormatStringWithoutPrepending
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list
    RKListStyle *simpleList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"-- %d --", nil]];

    testString = [simpleList formatStringOfLevel:0 placeholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)5, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'09\t-- \\'00 --\t", @"Invalid format string");

    // Generating a simple list (only bullet point)
    RKListStyle *bulletPoint = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"-", nil]];
    
    testString = [bulletPoint formatStringOfLevel:0 placeholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)0, @"Invalid count of placeholders");
    
    STAssertEqualObjects(testString, @"\\'03\t-\t", @"Invalid format string");
    
    // Generating a simple list with keeping the escpae sign and converting RTF-Chars
    RKListStyle *keepingChars = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%%∮{%d\\%", nil]];

    testString = [keepingChars formatStringOfLevel:0 placeholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)5, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'08\t%\\u8750\\{\\'00\\\\%\t", @"Invalid format string");
}

- (void)testBuildRTFFormatStringWithMultipleMarkers  
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list with multiple markers
    RKListStyle *list = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%A.", nil ]];

    testString = [list formatStringOfLevel:2 placeholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)3, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)2, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex: 1] unsignedIntegerValue], (NSUInteger)4, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex: 2] unsignedIntegerValue], (NSUInteger)6, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'08\t\\'00.\\'01.\\'02.\t", @"Invalid format string");
}

- (void)testBuildTextSystemFormatString  
{
    RKListStyle *list = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.ä%%{", @"%*%r.", @"%*%R.", @"%*%a.", @"%*%A.", @"--", nil ]];
    
    STAssertEqualObjects([list systemFormatOfLevel: 0], @"{\\*\\levelmarker \\{decimal\\}.\\u228%\\{}", @"Invalid placeholder");
    STAssertEqualObjects([list systemFormatOfLevel: 1], @"{\\*\\levelmarker \\{lower-roman\\}.}\\levelprepend", @"Invalid placeholder");
    STAssertEqualObjects([list systemFormatOfLevel: 2], @"{\\*\\levelmarker \\{upper-roman\\}.}\\levelprepend", @"Invalid placeholder");
    STAssertEqualObjects([list systemFormatOfLevel: 3], @"{\\*\\levelmarker \\{lower-alpha\\}.}\\levelprepend", @"Invalid placeholder");
    STAssertEqualObjects([list systemFormatOfLevel: 4], @"{\\*\\levelmarker \\{upper-alpha\\}.}\\levelprepend", @"Invalid placeholder");
    STAssertEqualObjects([list systemFormatOfLevel: 5], @"{\\*\\levelmarker --}", @"Invalid placeholder");
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
    RKListStyle *prependingList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%R.", @"%*%a.", @"%*%A.-{%%∮\\}", nil ]];
    
    NSString *string = [prependingList markerForItemNumbers: itemNumbers];
    
    STAssertEqualObjects(string, @"\t3.iv.V.f.G.-\\{%\\u8750\\\\\\}\t", @"Invalid marker string generated");
}

@end
