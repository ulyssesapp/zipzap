//
//  RKHeaderDefinitionsContainerTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderDefinitionsContainerTest.h"
#import "RKHeaderDefinitionsContainer.h"
#import "RKDocument.h"
#import "RKSection.h"

@implementation RKHeaderDefinitionsContainerTest

- (RKDocument *)documentWithAttributedStrings:(NSArray*)strings
{
    NSMutableArray *sections = [NSMutableArray array];
    
    for (NSAttributedString *string in strings) {
        [sections addObject: [RKSection sectionWithContent: string]];
    }
    
    return [RKDocument documentWithSections: sections];
}

- (void)testNoSections
{
    RKDocument *document = [[RKDocument alloc] init];
    RKHeaderDefinitionsContainer *headerDefinitions = [RKHeaderDefinitionsContainer headerDefinitionsFromDocument: document];
    
    STAssertEquals([headerDefinitions.collectedFonts count], (NSUInteger)0, @"Header definitions collected for empty input");
    STAssertEquals([headerDefinitions.collectedColors count], (NSUInteger)0, @"Header definitions collected for empty input");
}

- (void)testPureTextCollection
{
    RKDocument *document = [RKDocument documentWithAttributedString: [[NSAttributedString alloc] initWithString:@"abcd"]];
    RKHeaderDefinitionsContainer *headerDefinitions = [RKHeaderDefinitionsContainer headerDefinitionsFromDocument: document];
    
    STAssertEquals([headerDefinitions.collectedFonts count], (NSUInteger)0, @"Header definitions collected for empty input");
    STAssertEquals([headerDefinitions.collectedColors count], (NSUInteger)0, @"Header definitions collected for empty input");
}

- (void)testCollectingFonts
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"1234567"];

    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:8] range:NSMakeRange(0,1)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica-Bold" size:16] range:NSMakeRange(1,1)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:32] range:NSMakeRange(2,1)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Times-Roman" size:64] range:NSMakeRange(3,1)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Verdana-Italic" size:64] range:NSMakeRange(4,1)];
    
    RKDocument *document = [RKDocument documentWithAttributedString: attributedString];
    RKHeaderDefinitionsContainer *headerDefinitions = [RKHeaderDefinitionsContainer headerDefinitionsFromDocument: document];

    // We expect nothing else to be collected than fonts
    STAssertEquals([headerDefinitions.collectedColors count], (NSUInteger)0, @"Colors should not be collected");

    // We expect that every font is collected only once, without the different variants in size and traits
    STAssertEquals([headerDefinitions.collectedFonts count], (NSUInteger)3, @"Invalid count of filtered fonts");
    
    // Find font regardless of its traits and size
    STAssertEquals([headerDefinitions indexOfFont: [NSFont fontWithName:@"Helvetica" size:8]], (NSUInteger)0, @"Missing font");
    STAssertEquals([headerDefinitions indexOfFont: [NSFont fontWithName:@"Helvetica-Italic" size:128]], NSNotFound, @"Traits not ignored");

    // Different font names should deliver a different index
    STAssertEquals([headerDefinitions indexOfFont: [NSFont fontWithName:@"Times-Roman" size:18]], (NSUInteger)1, @"Missing font or size not ignored");
    STAssertEquals([headerDefinitions indexOfFont: [NSFont fontWithName:@"Verdana" size:28]], (NSUInteger)2, @"Missing font");

    STAssertEquals([headerDefinitions indexOfFont: [NSFont fontWithName:@"Menlo" size:8]], NSNotFound, @"Missing font");
}

- (void)testCollectingColors
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"1234567"];
    
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.1] range:NSMakeRange(0,1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:0.4] range:NSMakeRange(1,1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.0] range:NSMakeRange(2,1)];
    
    RKDocument *document = [RKDocument documentWithAttributedString: attributedString];
    RKHeaderDefinitionsContainer *headerDefinitions = [RKHeaderDefinitionsContainer headerDefinitionsFromDocument: document];
    
    // We expect nothing else to be collected than colors
    STAssertEquals([headerDefinitions.collectedFonts count], (NSUInteger)0, @"Fonts should not be collected");
    
    // We expect that every color is collected only once, without the different variants in size and traits
    STAssertEquals([headerDefinitions.collectedColors count], (NSUInteger)2, @"Invalid count of filtered colors");
    
    // Find color regardless of its alpha channel
    STAssertEquals([headerDefinitions indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.1]], (NSUInteger)0, @"Missing color");
    STAssertEquals([headerDefinitions indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.9]], (NSUInteger)0, @"Alpha channel not ignored");
                    
    // Different colors should deliver a different index
    STAssertEquals([headerDefinitions indexOfColor: [NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:0.4]], (NSUInteger)1, @"Missing color");
}

- (void)testCollectingInMultipleSections
{
    NSMutableAttributedString *firstSection = [[NSMutableAttributedString alloc] initWithString:@"sec1"];
    NSMutableAttributedString *secondSection = [[NSMutableAttributedString alloc] initWithString:@"sec2"];
    NSMutableAttributedString *thirdSection = [[NSMutableAttributedString alloc] initWithString:@"sec3"];
    
    [firstSection addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:8] range:NSMakeRange(0,1)];
    [secondSection addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Times-Roman" size:8] range:NSMakeRange(0,1)];
    [thirdSection addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Verdana-Bold" size:8] range:NSMakeRange(0,1)];

    [firstSection addAttribute:NSBackgroundColorAttributeName value:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.1] range:NSMakeRange(0,1)];
    [thirdSection addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:0.0] range:NSMakeRange(2,1)];
    
    RKDocument *document = [self documentWithAttributedStrings: [NSArray arrayWithObjects: firstSection, secondSection, thirdSection, nil]];
    RKHeaderDefinitionsContainer *headerDefinitions = [RKHeaderDefinitionsContainer headerDefinitionsFromDocument: document];

    STAssertEquals([headerDefinitions.collectedColors count], (NSUInteger)2, @"Colors not collected");
    STAssertEquals([headerDefinitions.collectedFonts count], (NSUInteger)3, @"Fonts not collected");
}


@end
