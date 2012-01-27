//
//  RKHeaderWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriterTest.h"
#import "RKBodyWriter.h"
#import "RKResourcePool.h"
#import "RKHeaderWriter.h"
#import "RKHeaderWriter+TestExtensions.h"


@implementation RKHeaderWriterTest

- (NSDate *)customDateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *customComponents = [NSDateComponents new];
    
    [customComponents setYear:year];
    [customComponents setMonth:month];
    [customComponents setDay:day];
    [customComponents setHour:hour];
    [customComponents setMinute:minute];
    [customComponents setSecond:second];
    
    return [[NSCalendar currentCalendar] dateFromComponents:customComponents];
}

- (void)testGeneratingFontTable
{
    RKResourcePool *resources = [RKResourcePool new];
    
    // Register some fonts
    [resources indexOfFont:[NSFont fontWithName:@"Times-Roman" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Helvetica-Oblique" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Menlo-Bold" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Monaco" size:8]];    
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter fontTableFromResourceManager:resources], 
                         @"{\\fonttbl"
                          "\\f0\\fnil\\fcharset0 Times;"
                          "\\f1\\fnil\\fcharset0 Helvetica;"
                          "\\f2\\fnil\\fcharset0 Menlo;"
                          "\\f3\\fnil\\fcharset0 Monaco;"
                          "}",
                         @"Invalid font table generated"
                         );
}

- (void)testGeneratingColorTable
{
    RKResourcePool *resources = [RKResourcePool new];
    
    // Register some fonts
    [resources indexOfColor:[NSColor colorWithSRGBRed:0 green:1 blue:0.5 alpha:1]];
    [resources indexOfColor:[NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:1]];
    [resources indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.5 blue:0.1 alpha:1]];
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter colorTableFromResourceManager:resources], 
                         @"{\\colortbl;"
                         "\\red255\\green255\\blue255;"
                         "\\red0\\green255\\blue127;"
                         "\\red25\\green51\\blue76;"
                         "\\red76\\green127\\blue25;"                         
                         "}",
                         @"Invalid color table generated"
                         );
}

- (void)testGeneratingDocumentInfo
{
    RKDocument *document = [RKDocument new];
    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Title {} \\ ",    NSTitleDocumentAttribute,
                                 @"Company",        NSCompanyDocumentAttribute,
                                 @"Copyright",      NSCopyrightDocumentAttribute,
                                 @"Subject",        NSSubjectDocumentAttribute,
                                 @"Author",         NSAuthorDocumentAttribute,
                                 @"Keywords",       NSKeywordsDocumentAttribute,
                                 @"Comment",        NSCommentDocumentAttribute,
                                 @"Editor",         NSEditorDocumentAttribute,
                                 [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6],  NSCreationTimeDocumentAttribute,
                                 [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1],  NSModificationTimeDocumentAttribute,
                                 @"Manager",        NSManagerDocumentAttribute,
                                 @"Category",       NSCategoryDocumentAttribute,
                                 nil
                                ];

    [document setMetadata: metaData];
    
    STAssertEqualObjects([RKHeaderWriter documentMetaDataFromDocument:document],
                          @"{\\info"
                                "{\\title Title \\{\\} \\\\ }"
                                "{\\*\\company Company}"
                                "{\\*\\copyright Copyright}"
                                "{\\subject Subject}"
                                "{\\author Author}"
                                "{\\keywords Keywords}"
                                "{\\doccomm Comment}"
                                "{\\editor Editor}"
                                "{\\creatim \\yr2001 \\mo2 \\dy3 \\hr4 \\min5 \\sec6}"
                                "{\\revtim \\yr2006 \\mo5 \\dy4 \\hr3 \\min2 \\sec1}"
                                "{\\manager Manager}"
                                "{\\category Category}"
                            "}",
                          @"Invalid document meta data"
                         );
}

- (void)testGeneratingDocumentFormattingData
{
    RKDocument *document = [RKDocument new];
    RKPageInsets insets = {.top = 100.0, .left = 200.0, .right = 300.0, .bottom = 400.0};

    // Test setting: Hyphenation, Footnotes, Overriding default size / margins, portrait format
    [document setHyphenationEnabled:YES];
    [document setFootnotePlacement:RKFootnotePlacementSamePage];
    [document setPageSize:NSMakeSize(100.0, 200.0)];
    [document setPageInsets:insets];
    [document setPageOrientation:RKPageOrientationPortrait];

    STAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\hyphauto"
                          "\\fet0"
                          "\\paperw2000"
                          "\\paperh4000"
                          "\\margt2000"
                          "\\margl4000"
                          "\\margr6000"
                          "\\margb8000"
                          "\\uc0 ",
                          @"Document formatting options not correctly translated"
                         );

    // Test setting: No Hyphenation, Document endnotes, landscape format    
    [document setHyphenationEnabled:NO];
    [document setFootnotePlacement:RKFootnotePlacementDocumentEnd];
    [document setPageOrientation:RKPageOrientationLandscape];
    
    STAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet1\\enddoc\\aenddoc"
                         "\\landscape"
                         "\\paperw2000"
                         "\\paperh4000"
                         "\\margt2000"
                         "\\margl4000"
                         "\\margr6000"
                         "\\margb8000"
                         "\\uc0 ",
                         @"Document formatting options not correctly translated"
                         );    
    
    // Test setting: No Hyphenation, Section endnotes, landscape format    
    [document setHyphenationEnabled:NO];
    [document setFootnotePlacement:RKFootnotePlacementSectionEnd];
    [document setPageOrientation:RKPageOrientationLandscape];
    
    STAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @ "\\fet1\\endnotes\\aendnotes"
                         "\\landscape"
                         "\\paperw2000"
                         "\\paperh4000"
                         "\\margt2000"
                         "\\margl4000"
                         "\\margr6000"
                         "\\margb8000"
                         "\\uc0 ",
                         @"Document formatting options not correctly translated"
                         );  
}


@end
