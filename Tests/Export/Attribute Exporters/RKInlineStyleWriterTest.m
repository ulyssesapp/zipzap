//
//  RKFontStyleWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKInlineStyleWriterTest.h"
#import "RKInlineStyleWriter+TestExtensions.h"
#import "RKInlineStyleWriter.h"

@implementation RKInlineStyleWriterTest

- (void)testTagSingleFontStyle
{
    NSFont *font = [NSFont fontWithName:@"Helvetica-BoldOblique" size:16];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    [RKInlineStyleWriter tag:string withFont:font inRange:NSMakeRange(1, 2) resources:resources];
    
    // Test tagging
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                          "\\f0 "
                          "\\fs16 "
                          "\\b "
                          "\\i "
                          "bc"
                          "\\b0 "
                          "\\i0 "
                          "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *fontFamilies = [resources fontFamilyNames];
    STAssertEquals([fontFamilies count], (NSUInteger)1, @"Invalid font family count");
    STAssertEqualObjects([fontFamilies objectAtIndex:0], @"Helvetica", @"Invalid font family");    
}

- (void)testTagMultipleFontStyles
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abcdef"];
    NSFont *fontA = [NSFont fontWithName:@"Times-Roman" size:8];
    NSFont *fontB = [NSFont fontWithName:@"Helvetica-BoldOblique" size:16];
    RKResourcePool *resources = [RKResourcePool new];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[attributedString string]];
    
    [attributedString addAttribute:NSFontAttributeName value:fontA range:NSMakeRange(0, 2)];
    [attributedString addAttribute:NSFontAttributeName value:fontB range:NSMakeRange(2, 2)];

    [RKInlineStyleWriter tag:taggedString withFontStylesOfAttributedString:attributedString resources:resources];
    
    // Test tagging
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @"\\f0 "
                          "\\fs8 "
                          "ab"
                          "\\f1 "
                          "\\fs16 "
                          "\\b "
                          "\\i "
                          "cd"
                          "\\b0 "
                          "\\i0 "
                          // Default of the text system is Helvetica, 12pt
                          "\\f1 "
                          "\\fs12 "
                          "ef",
                         @"Invalid font styles"
                         );

    // Test resource manager
    NSArray *fontFamilies = [resources fontFamilyNames];
    STAssertEquals([fontFamilies count], (NSUInteger)2, @"Invalid font family count");
    STAssertEqualObjects([fontFamilies objectAtIndex:0], @"Times-Roman", @"Invalid font family");    
    STAssertEqualObjects([fontFamilies objectAtIndex:1], @"Helvetica", @"Invalid font family");    
    
}

@end
