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

    // Indexing the same color again should deliver the same index
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
    STAssertEquals(resourceManager.attachmentFileWrappers.count, (NSUInteger)1, @"Invalid count of files");
    
    NSFileWrapper *registeredFileWrapper = [resourceManager.attachmentFileWrappers.allValues objectAtIndex:0];
    
    STAssertEqualObjects([resourceManager.attachmentFileWrappers.allKeys objectAtIndex:0], @"0.png", @"Invalid filename");
    
    STAssertEqualObjects([registeredFileWrapper regularFileContents], [originalFileWrapper regularFileContents], @"File contents differ");
}

- (void)testRegisteringListItem
{
    NSArray *overrides = [NSArray arrayWithObjects: 
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 12],                         
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],
                          nil
                          ];
    
    // Create a list, where level 4 will start the item count with 12
    RKListStyle *textList = [RKListStyle textListWithLevelFormats:[NSArray new] withOveridingStartItemNumbers:overrides];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Initialization
    NSArray *itemNumbers = [resources incrementItemNumbersForListLevel:0 ofList:textList];
    STAssertEquals(itemNumbers.count, (NSUInteger)1, @"Invalid item count");
    STAssertEquals([[itemNumbers objectAtIndex:0] unsignedIntegerValue], (NSUInteger)1, @"Invalid item number");
    
    // Increment existing
    itemNumbers = [resources incrementItemNumbersForListLevel:0 ofList:textList];
    STAssertEquals(itemNumbers.count, (NSUInteger)1, @"Invalid item count");
    STAssertEquals([[itemNumbers objectAtIndex:0] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");    

    // Extend existing
    itemNumbers = [resources incrementItemNumbersForListLevel:3 ofList:textList];
    STAssertEquals(itemNumbers.count, (NSUInteger)4, @"Invalid item count");
    STAssertEquals([[itemNumbers objectAtIndex:0] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:1] unsignedIntegerValue], (NSUInteger)1, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:2] unsignedIntegerValue], (NSUInteger)1, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:3] unsignedIntegerValue], (NSUInteger)12, @"Invalid item number");
    
    // Increment extension
    itemNumbers = [resources incrementItemNumbersForListLevel:3 ofList:textList];
    STAssertEquals(itemNumbers.count, (NSUInteger)4, @"Invalid item count");
    STAssertEquals([[itemNumbers objectAtIndex:0] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:1] unsignedIntegerValue], (NSUInteger)1, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:2] unsignedIntegerValue], (NSUInteger)1, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:3] unsignedIntegerValue], (NSUInteger)13, @"Invalid item number");
    
    // Truncate and increment
    itemNumbers = [resources incrementItemNumbersForListLevel:1 ofList:textList];
    STAssertEquals(itemNumbers.count, (NSUInteger)2, @"Invalid item count");
    STAssertEquals([[itemNumbers objectAtIndex:0] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:1] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");

    // Extend again
    itemNumbers = [resources incrementItemNumbersForListLevel:3 ofList:textList];
    STAssertEquals(itemNumbers.count, (NSUInteger)4, @"Invalid item count");
    STAssertEquals([[itemNumbers objectAtIndex:0] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:1] unsignedIntegerValue], (NSUInteger)2, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:2] unsignedIntegerValue], (NSUInteger)1, @"Invalid item number");
    STAssertEquals([[itemNumbers objectAtIndex:3] unsignedIntegerValue], (NSUInteger)12, @"Invalid item number");
}

@end
