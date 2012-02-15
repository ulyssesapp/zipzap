//
//  RKTextListStylingWriterAdditionsTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListWriterAdditions.h"
#import "RKTextListWriterAdditionsTest.h"
#import "RKTextListWriterAdditions+TextExtensions.h"

@implementation RKTextListWriterAdditionsTest

- (void)testDetectPrependingFormat
{
    RKListStyle *textList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%*---%d---", @"---%d%--%*", @"%d", @"* %d *", @"%%*%d", nil]];
    
    STAssertTrue([textList isPrependingLevel: 0], @"Prepending was not detected");
    STAssertTrue([textList isPrependingLevel: 1], @"Prepending was not detected");
    STAssertFalse([textList isPrependingLevel: 2], @"Prepending was detected wrongly");
    STAssertFalse([textList isPrependingLevel: 3], @"Prepending was detected wrongly");
    STAssertFalse([textList isPrependingLevel: 4], @"Prepending was detected wrongly");    
}

- (void)testDetectPlaceholderOfLevel
{
    RKListStyle *textList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%*---%d%r---", @"---%r%--%*", @"%R", @"* %a *", @"%%*%A", @"-", @"%%", nil]];
    
    STAssertEqualObjects([textList enumerationPlaceholderOfLevel: 0], @"%d", @"Placeholder not found");
    STAssertEqualObjects([textList enumerationPlaceholderOfLevel: 1], @"%r", @"Placeholder not found");
    STAssertEqualObjects([textList enumerationPlaceholderOfLevel: 2], @"%R", @"Placeholder not found");
    STAssertEqualObjects([textList enumerationPlaceholderOfLevel: 3], @"%a", @"Placeholder not found");
    STAssertEqualObjects([textList enumerationPlaceholderOfLevel: 4], @"%A", @"Placeholder not found");
    STAssertNil([textList enumerationPlaceholderOfLevel: 5], @"Invalid placeholder found");
    STAssertNil([textList enumerationPlaceholderOfLevel: 6], @"Invalid placeholder found");
}

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
    
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 0], RKTextListFormatCodeDecimal, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 1], RKTextListFormatCodeLowerCaseRoman, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 2], RKTextListFormatCodeUpperCaseRoman, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 3], RKTextListFormatCodeLowerCaseLetter, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 4], RKTextListFormatCodeUpperCaseLetter, @"Invalid format code");
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 5], RKTextListFormatCodeBullet, @"Invalid format code");
    
    // Invalid level selected
    STAssertEquals([listStyle RTFFormatCodeOfLevel: 8], RKTextListFormatCodeBullet, @"Invalid format code");
}

- (void)testBuildNormalizedFormatString
{
    RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:
                                                                  @"%d.",
                                                                  @"%*%r.",
                                                                  @"%*%r.",
                                                                  @"-%a-",
                                                                  @"%d:%*",
                                                                  nil
                                                                  ]];
    
    STAssertEqualObjects([listStyle normalizedFormatOfLevel: 0], @"%d0.", @"Invalid normalization");
    STAssertEqualObjects([listStyle normalizedFormatOfLevel: 1], @"%d0.%r1.", @"Invalid normalization");
    STAssertEqualObjects([listStyle normalizedFormatOfLevel: 2], @"%d0.%r1.%r2.", @"Invalid normalization");
    STAssertEqualObjects([listStyle normalizedFormatOfLevel: 3], @"-%a3-", @"Invalid normalization");
    STAssertEqualObjects([listStyle normalizedFormatOfLevel: 4], @"%d4:-%a3-", @"Invalid normalization");
}

- (void)testBuildRTFFormatStringWithoutPrepending
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list
    RKListStyle *simpleList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"-- %d --", nil]];

    testString = [simpleList RTFFormatStringOfLevel:0 withPlaceholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)5, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'09\t-- \\'00 --\t", @"Invalid format string");

    // Generating a simple list (only bullet point)
    RKListStyle *bulletPoint = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"-", nil]];
    
    testString = [bulletPoint RTFFormatStringOfLevel:0 withPlaceholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)0, @"Invalid count of placeholders");
    
    STAssertEqualObjects(testString, @"\\'03\t-\t", @"Invalid format string");
    
    // Generating a simple list with keeping the escpae sign and converting RTF-Chars
    RKListStyle *keepingChars = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%%∮{%d\\%", nil]];

    testString = [keepingChars RTFFormatStringOfLevel:0 withPlaceholderPositions:&placeholderPositions];    
    
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

    testString = [list RTFFormatStringOfLevel:2 withPlaceholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)3, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)2, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex: 1] unsignedIntegerValue], (NSUInteger)4, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex: 2] unsignedIntegerValue], (NSUInteger)6, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'08\t\\'00.\\'01.\\'02.\t", @"Invalid format string");
}

- (void)testBuilCocoaFormatString  
{
    RKListStyle *list = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%R.", @"%*%a.", @"%*%A.", @"--", nil ]];
    
    STAssertEqualObjects([list cocoaRTFFormatStringOfLevel: 0], @"\\{decimal\\}.", @"Invalid placeholder");
    STAssertEqualObjects([list cocoaRTFFormatStringOfLevel: 1], @"\\{lower-roman\\}.", @"Invalid placeholder");
    STAssertEqualObjects([list cocoaRTFFormatStringOfLevel: 2], @"\\{upper-roman\\}.", @"Invalid placeholder");
    STAssertEqualObjects([list cocoaRTFFormatStringOfLevel: 3], @"\\{lower-alpha\\}.", @"Invalid placeholder");
    STAssertEqualObjects([list cocoaRTFFormatStringOfLevel: 4], @"\\{upper-alpha\\}.", @"Invalid placeholder");
    STAssertEqualObjects([list cocoaRTFFormatStringOfLevel: 5], @"--", @"Invalid placeholder");
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
