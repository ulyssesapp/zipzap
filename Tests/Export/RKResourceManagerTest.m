//
//  RKResourceManagerTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourceManagerTest.h"
#import "RKResourceManager.h"

@implementation RKResourceManagerTest

- (void)testIndexingFonts
{
    RKResourceManager *resourceManager = [[RKResourceManager alloc] init];
  
    // Find font regardless of its traits and size
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Helvetica" size:8]], (NSUInteger)0, @"Font not added");
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Helvetica-Oblique" size:128]], (NSUInteger)0, @"Traits or size not ignored");

    // Different font names should deliver a different index
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Times-Roman" size:18]], (NSUInteger)1, @"Missing font or size not ignored");
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Verdana" size:28]], (NSUInteger)2, @"Missing font");

    // Indexing the same fonts again should deliver the same index
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Times-Italic" size:99]], (NSUInteger)1, @"Index not reused or traits/size not ignored");
    STAssertEquals([resourceManager indexOfFont: [NSFont fontWithName:@"Helvetica-Bold" size:99]], (NSUInteger)0, @"Index not reused or traits/size not ignored");

}

- (void)testIndexingColors
{
    RKResourceManager *resourceManager = [[RKResourceManager alloc] init];
    
    // Find color regardless of its alpha channel
    STAssertEquals([resourceManager indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.1]], (NSUInteger)0, @"Missing color");
    STAssertEquals([resourceManager indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:0.9]], (NSUInteger)0, @"Alpha channel not ignored");
                    
    // Different colors should deliver a different index
    STAssertEquals([resourceManager indexOfColor: [NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:0.4]], (NSUInteger)1, @"Missing color");

    // Indexing the same fonts again should deliver the same index
    STAssertEquals([resourceManager indexOfColor: [NSColor colorWithSRGBRed:0.1 green:0.2 blue:0.3 alpha:1]], (NSUInteger)1, @"Index not reused or alpha not ignored");
    STAssertEquals([resourceManager indexOfColor:[NSColor colorWithSRGBRed:0.3 green:0.2 blue:0.1 alpha:1]], (NSUInteger)0, @"Index not reused or alpha not ignored");
}

@end
