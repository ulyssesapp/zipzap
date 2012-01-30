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

@end
