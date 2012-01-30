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
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ul\\ulstyle1 b\\ulnone c", @"Invalid underline style");

    // Double line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:NSUnderlineStyleDouble inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldb\\ulstyle9 b\\ulnone c", @"Invalid underline style");

    // Thick line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:NSUnderlineStyleThick inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulth\\ulstyle2 b\\ulnone c", @"Invalid underline style");

    // Dashed line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlinePatternDash) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldash\\ulstyle513 b\\ulnone c", @"Invalid underline style");

    // Dash-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlinePatternDashDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldashd\\ulstyle769 b\\ulnone c", @"Invalid underline style");

    // Dash-Dot-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlinePatternDashDotDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldashdd\\ulstyle1025 b\\ulnone c", @"Invalid underline style");

    // Thick Dashed line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleThick | NSUnderlinePatternDash) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdash\\ulstyle514 b\\ulnone c", @"Invalid underline style");
    
    // Thick Dash-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleThick | NSUnderlinePatternDashDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdashd\\ulstyle770 b\\ulnone c", @"Invalid underline style");
    
    // Thick Dash-Dot-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleThick | NSUnderlinePatternDashDotDot) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdashdd\\ulstyle1026 b\\ulnone c", @"Invalid underline style");
    
    // Wordwise, single underline
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];  
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleSingle | NSUnderlineByWordMask) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulw\\ulstyle32769 b\\ulnone c", @"Invalid underline style");

    // Wordwise, double underline (additional styles are placed after \ulw)
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];  
    [RKInlineStyleWriter tag:taggedString withUnderlineStyle:(NSUnderlineStyleDouble | NSUnderlineByWordMask) inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulw\\uldb\\ulstyle32777 b\\ulnone c", @"Invalid underline style");
}

- (void)testUnderlineColor
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineColor:nil inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid underline style");
    
    // Setting a color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withUnderlineColor:[NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1] inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulc2 b\\ulc0 c", @"Invalid underline style");

    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

- (void)testStrikethroughStyle
{
    RKTaggedString *taggedString;
    
    // Default style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKInlineStyleWriter tag:taggedString withStrikethroughStyle:0 inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid strikethrough style");
 
    // Single style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKInlineStyleWriter tag:taggedString withStrikethroughStyle:NSUnderlineStyleSingle inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\strike\\strikestyle1 b\\strike0 c", @"Invalid strikethrough style");

    // Double style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKInlineStyleWriter tag:taggedString withStrikethroughStyle:NSUnderlineStyleDouble inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\striked1\\strikestyle9 b\\striked0 c", @"Invalid strikethrough style");
}

- (void)testStrikethroughColor
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withStrikethroughColor:nil inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid strikethrough style");
    
    // Setting a color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withStrikethroughColor:[NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1] inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\strikec2 b\\strikec0 c", @"Invalid strikethrough style");
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

- (void)testStrokeWidth
{
    RKTaggedString *taggedString;
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withStrokeWidth:0 inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid stroke width");
    
    // Setting a color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withStrokeWidth:30 inRange:NSMakeRange(1,1)];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\outl\\strokewidth30 b\\outl0\\strokewidth0 c", @"Invalid stroke width");
}

- (void)testStrokeColor
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withStrokeColor:nil inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid strikethrough style");
    
    // Setting a color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withStrokeColor:[NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:0.5] inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\strokec2 b\\strokec0 c", @"Invalid strikethrough style");
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

- (void)testShadow
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];    
    NSShadow *shadow = [NSShadow new];
    
    [shadow setShadowColor:[NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:0.5]];
    [shadow setShadowOffset:NSMakeSize(2.0, 3.0)];
    [shadow setShadowBlurRadius:4.0];
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withShadowStyle:nil inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid stroke width");
    
    // Setting a shadow
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKInlineStyleWriter tag:taggedString withShadowStyle:shadow inRange:NSMakeRange(1,1) resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\shad\\shadx40\\shady60\\shadr80\\shadc2 b\\shad0 c", @"Invalid shadow");

    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

@end

