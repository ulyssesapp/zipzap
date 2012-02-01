//
//  RKResourcePoolTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePoolTest.h"

@implementation RKResourcePoolTest

- (void)testIndexingFonts
{
    RKResourcePool *resourceManager = [RKResourcePool new];
  
    // Find font regardless of its traits and size
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Helvetica" size:8]], (NSUInteger)0, @"Font not indexed");
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Helvetica-Oblique" size:128]], (NSUInteger)0, @"Traits or size not ignored");

    // Different font names should deliver a different index
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Times-Roman" size:18]], (NSUInteger)1, @"Missing font or size not ignored");
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Menlo" size:28]], (NSUInteger)2, @"Missing font");

    // Indexing the same fonts again should deliver the same index
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Times-Italic" size:99]], (NSUInteger)1, @"Index not reused or traits/size not ignored");
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Helvetica-Bold" size:99]], (NSUInteger)0, @"Index not reused or traits/size not ignored");

    NSArray *collectedFonts = [resourceManager fontFamilyNames];

    STAssertEquals([collectedFonts count], (NSUInteger)3, @"Unexpected font count");

    // Non-standard traits are kept
    STAssertEqualObjects([collectedFonts objectAtIndex:0], @"Helvetica", @"Unexpected font");
    STAssertEqualObjects([collectedFonts objectAtIndex:1], @"Times-Roman", @"Unexpected font");
    STAssertEqualObjects([collectedFonts objectAtIndex:2], @"Menlo-Regular", @"Unexpected font");
}

- (void)testIndexingColors
{
    RKResourcePool *resourceManager = [RKResourcePool new];
    
    // Find color regardless of its alpha channel
    STAssertEquals([resourceManager indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.1]], (NSUInteger)2, @"Color not indexed");
    STAssertEquals([resourceManager indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.9]], (NSUInteger)2, @"Alpha channel not ignored");
                    
    // Different colors should deliver a different index
    STAssertEquals([resourceManager indexOfColor: [NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:0.4]], (NSUInteger)3, @"Color not indexed");

    // Indexing the same fonts again should deliver the same index
    STAssertEquals([resourceManager indexOfColor: [NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:1]], (NSUInteger)3, @"Index not reused or alpha not ignored");
    STAssertEquals([resourceManager indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:1]], (NSUInteger)2, @"Index not reused or alpha not ignored");
}

- (void)testRegisteringFileWrappers
{
    RKResourcePool *resourceManager = [RKResourcePool new];
    
    const char fileContent[] = {0, 1, 2};
    NSFileWrapper *originalFileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents:[NSData dataWithBytes:fileContent length:3]];
    
    [originalFileWrapper setFilename:@"foo.png"];
    
    NSString *registeredFilename = [resourceManager registerFileWrapper:originalFileWrapper];
    
    STAssertEqualObjects(registeredFilename, @"0.png", @"Invalid filename generated");
    STAssertEquals(resourceManager.fileWrappers.count, (NSUInteger)1, @"Invalid count of files");
    
    NSFileWrapper *registeredFileWrapper = [resourceManager.fileWrappers objectAtIndex:0];
    
    STAssertTrue(originalFileWrapper != registeredFileWrapper, @"Identical wrappers");
    STAssertEqualObjects(registeredFileWrapper.filename, @"0.png", @"Invalid filename");
    
    STAssertEqualObjects([registeredFileWrapper regularFileContents], [originalFileWrapper regularFileContents], @"File contents differ");
    
}

- (void)testRegisteringTextListHeads
{
    RKResourcePool *resources = [RKResourcePool new];
    
    NSTextList *headA = [NSTextList new];
    NSTextList *headB = [NSTextList new];

    NSUInteger headAIndex = [resources indexOfList:headA];
    NSUInteger headBIndex = [resources indexOfList:headB];
    
    STAssertEquals(headAIndex, (NSUInteger)0, @"Invalid head index");
    STAssertEquals(headBIndex, (NSUInteger)1, @"Invalid head index");
}

- (void)testRegisteringTextListNestings
{
    RKResourcePool *resources = [RKResourcePool new];
    
    NSTextList *headA = [NSTextList new];
    NSTextList *headB = [NSTextList new];

    NSUInteger headAIndex = [resources indexOfList:headA];
    NSUInteger headBIndex = [resources indexOfList:headB];    
    
    NSTextList *levelAA = [NSTextList new];
    NSTextList *levelAAA = [NSTextList new];
    NSTextList *levelBB = [NSTextList new];
    
    [resources registerLevelSettings:[NSArray arrayWithObjects:headA, levelAA, nil] forListIndex:headAIndex];
    [resources registerLevelSettings:[NSArray arrayWithObjects:headB, levelBB, nil] forListIndex:headBIndex];

    // Setting lists descriptions
    NSArray *levelSettingsA = [resources levelDescriptionsOfList:headAIndex];

    STAssertEqualObjects([levelSettingsA objectAtIndex:0], headA, @"Invalid list level descriptor");    
    STAssertEqualObjects([levelSettingsA objectAtIndex:1], levelAA, @"Invalid list level descriptor");

    NSArray *levelSettingsB = [resources levelDescriptionsOfList:headBIndex];
    STAssertEqualObjects([levelSettingsB objectAtIndex:0], headB, @"Invalid list level descriptor");    
    STAssertEqualObjects([levelSettingsB objectAtIndex:1], levelBB, @"Invalid list level descriptor");
    
    // Extending list descriptions
    [resources registerLevelSettings:[NSArray arrayWithObjects:headA, levelAA, levelAAA, nil] forListIndex:headAIndex];
    
    levelSettingsA = [resources levelDescriptionsOfList:headAIndex];
    
    STAssertEqualObjects([levelSettingsA objectAtIndex:0], headA, @"Invalid list level descriptor");    
    STAssertEqualObjects([levelSettingsA objectAtIndex:1], levelAA, @"Invalid list level descriptor");
    STAssertEqualObjects([levelSettingsA objectAtIndex:2], levelAAA, @"Invalid list level descriptor");
    
    // Overwriting list descriptions without loosing more nested elements
    [resources registerLevelSettings:[NSArray arrayWithObjects:headA, levelBB, levelAAA, nil] forListIndex:headAIndex];
    
    levelSettingsA = [resources levelDescriptionsOfList:headAIndex];
    
    STAssertEqualObjects([levelSettingsA objectAtIndex:0], headA, @"Invalid list level descriptor");    
    STAssertEqualObjects([levelSettingsA objectAtIndex:1], levelBB, @"Invalid list level descriptor");
    STAssertEqualObjects([levelSettingsA objectAtIndex:2], levelAAA, @"Invalid list level descriptor");

    // Never overwrite head element
    STAssertThrows(([resources registerLevelSettings:[NSArray arrayWithObjects:headB, levelAA, levelAAA, nil] forListIndex:headAIndex]), @"Head element was overwritten");
}
    

@end
