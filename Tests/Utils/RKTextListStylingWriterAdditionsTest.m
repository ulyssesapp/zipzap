//
//  RKTextListStylingWriterAdditionsTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListStylingWriterAdditions.h"
#import "RKTextListStylingWriterAdditionsTest.h"

@implementation RKTextListStylingWriterAdditionsTest

- (void)testConvertRTFFormatCode
{
    RKTextListStyling *decimal = [RKTextListStyling textListWithGeneralLevelFormat:@"--- %d ---"];
    RKTextListStyling *lowerRoman = [RKTextListStyling textListWithGeneralLevelFormat:@"--- %r ---"];
    RKTextListStyling *upperRoman = [RKTextListStyling textListWithGeneralLevelFormat:@"--- %R ---"];
    RKTextListStyling *lowerAlpha = [RKTextListStyling textListWithGeneralLevelFormat:@"--- %a ---"];
    RKTextListStyling *upperAlpha = [RKTextListStyling textListWithGeneralLevelFormat:@"--- %A ---"];
    RKTextListStyling *bullet = [RKTextListStyling textListWithGeneralLevelFormat:@"--- * ---"];
    
    STAssertEquals([decimal RTFFormatCodeOfLevel:100], RKTextListFormatCodeDecimal, @"Invalid format code");
    STAssertEquals([lowerRoman RTFFormatCodeOfLevel:100], RKTextListFormatCodeLowerCaseRoman, @"Invalid format code");
    STAssertEquals([upperRoman RTFFormatCodeOfLevel:100], RKTextListFormatCodeUpperCaseRoman, @"Invalid format code");
    STAssertEquals([lowerAlpha RTFFormatCodeOfLevel:100], RKTextListFormatCodeLowerCaseLetter, @"Invalid format code");
    STAssertEquals([upperAlpha RTFFormatCodeOfLevel:100], RKTextListFormatCodeUpperCaseLetter, @"Invalid format code");
    STAssertEquals([bullet RTFFormatCodeOfLevel:100], RKTextListFormatCodeBullet, @"Invalid format code");
}

- (void)testBuildRTFFormatStringWithoutPrepending
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list
    RKTextListStyling *simpleList = [RKTextListStyling textListWithGeneralLevelFormat:@"(%d)"];

    testString = [simpleList RTFFormatStringOfLevel:5 withPlaceholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex:0] unsignedIntegerValue], 2, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'03(\\'04)", @"Invalid format string");

    // Generating a simple list (only bullet point)
    RKTextListStyling *bulletPoint = [RKTextListStyling textListWithGeneralLevelFormat:@"-"];
    
    testString = [bulletPoint RTFFormatStringOfLevel:5 withPlaceholderPositions:&placeholderPositions];
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)0, @"Invalid count of placeholders");
    
    STAssertEqualObjects(testString, @"\\'01-", @"Invalid format string");
    
    // Generating a simple list with keeping the escpae sign and converting RTF-Chars
    RKTextListStyling *keepingChars = [RKTextListStyling textListWithGeneralLevelFormat:@"%%{%d\\%%"];

    testString = [keepingChars RTFFormatStringOfLevel:6 withPlaceholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)1, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex:0] unsignedIntegerValue], 3, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'03%\\{\\'05\\\\%", @"Invalid format string");
}

- (void)testBuildRTFFormatStringWithPrepending    
{
    NSString *testString;
    NSArray *placeholderPositions;
    
    // Generating a simple list with prepending lists
    RKTextListStyling *prependingList = [RKTextListStyling textListWithGeneralLevelFormat:@"%*%d."];

    testString = [prependingList RTFFormatStringOfLevel:3 withPlaceholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)3, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex:0] unsignedIntegerValue], 1, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex:1] unsignedIntegerValue], 3, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex:2] unsignedIntegerValue], 5, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'06\\'00.\\'01.\\'02.", @"Invalid format string");
        
    // Generating a list with different level styles and prepending chars
    RKTextListStyling *multilevelList = [RKTextListStyling textListWithLevelFormats: [NSArray arrayWithObjects: @"%d.", @"(%r)", @"%*%a#", @"%*-", @"%*:", nil]];

    testString = [multilevelList RTFFormatStringOfLevel:4 withPlaceholderPositions:&placeholderPositions];    
    
    STAssertEquals(placeholderPositions.count, (NSUInteger)2, @"Invalid count of placeholders");
    STAssertEquals([[placeholderPositions objectAtIndex:0] unsignedIntegerValue], 2, @"Invalid tag position");
    STAssertEquals([[placeholderPositions objectAtIndex:1] unsignedIntegerValue], 4, @"Invalid tag position");
    
    STAssertEqualObjects(testString, @"\\'06(\\'01)\\'02#-", @"Invalid format string");
}

@end
