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

- (void)testTagFontStyle
{
    NSFont *font = [NSFont fontWithName:@"Times-BoldItalic" size:16];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];

    // Tagging defined font
    [RKInlineStyleWriter tag:string withFont:font inRange:NSMakeRange(1, 2) resources:resources];

    // Tagging default font
    [RKInlineStyleWriter tag:string withFont:nil inRange:NSMakeRange(3, 1) resources:resources];    
    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                          // Defined font
                          "\\f0 "
                          "\\fs16 "
                          "\\b "
                          "\\i "
                          "bc"
                          "\\b0 "
                          "\\i0 "
                          // Default font
                          "\\f1 "
                          "\\fs12 "
                          "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *fontFamilies = [resources fontFamilyNames];
    STAssertEquals([fontFamilies count], (NSUInteger)2, @"Invalid font family count");
    STAssertEqualObjects([fontFamilies objectAtIndex:0], @"Times-Roman", @"Invalid font family");
    STAssertEqualObjects([fontFamilies objectAtIndex:1], @"Helvetica", @"Invalid font family");  
}

- (void)testBackgroundColorStyle
{
    NSColor *color = [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:0.5];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];

    // Defined color
    [RKInlineStyleWriter tag:string withBackgroundColor:color inRange:NSMakeRange(1,2) resources:resources];
    // Default color
    [RKInlineStyleWriter tag:string withBackgroundColor:nil inRange:NSMakeRange(3,2) resources:resources];

    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                         // Defined color
                         "\\cb2 "
                         "bc"
                         // Default color
                         "\\cb1 "
                         "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

- (void)testForegroundColorStyle
{
    NSColor *color = [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:0.5];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Defined color
    [RKInlineStyleWriter tag:string withForegroundColor:color inRange:NSMakeRange(1,2) resources:resources];
    // Default color
    [RKInlineStyleWriter tag:string withForegroundColor:nil inRange:NSMakeRange(3,2) resources:resources];
    
    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                         // Defined color
                         "\\cf2 "
                         "bc"
                         // Default color
                         "\\cf0 "
                         "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

- (void)testUnderlineStyle
{
    RKTaggedString *taggedString;
    
    // Default style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:0 inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid underline style");

    // Single line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:NSUnderlineStyleSingle inRange:NSMakeRange(1,1) ];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ul b\\ulnone c", @"Invalid underline style");

    // Double line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:NSUnderlineStyleDouble inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldb b\\ulnone c", @"Invalid underline style");

    // Thick line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:NSUnderlineStyleThick inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulth b\\ulnone c", @"Invalid underline style");

    // Dashed line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlinePatternDash) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldash b\\ulnone c", @"Invalid underline style");

    // Dash-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlinePatternDashDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldashd b\\ulnone c", @"Invalid underline style");

    // Dash-Dot-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlinePatternDashDotDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldashdd b\\ulnone c", @"Invalid underline style");

    // Thick Dashed line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleThick | NSUnderlinePatternDash) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdash b\\ulnone c", @"Invalid underline style");
    
    // Thick Dash-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleThick | NSUnderlinePatternDashDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdashd b\\ulnone c", @"Invalid underline style");
    
    // Thick Dash-Dot-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleThick | NSUnderlinePatternDashDotDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdashdd b\\ulnone c", @"Invalid underline style");
    
    // Wordwise, single underline
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];  
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlineByWordMask) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulw b\\ulnone c", @"Invalid underline style");

    // Wordwise, double underline (additional styles are placed after \ulw)
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];  
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleDouble | NSUnderlineByWordMask) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulw \\uldb b\\ulnone c", @"Invalid underline style");
}

- (void)testUnderlineColor
{
    RKTaggedString *taggedString;
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:0 inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a \ulc0 bc", @"Invalid underline style");
    
}

@end
