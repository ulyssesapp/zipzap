//
//  RKListEnumeratorTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 04.04.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListEnumeratorTest.h"
#import "RKListCounter.h"
#import "RKListStyle.h"
#import "RKListItem.h"

@implementation RKListEnumeratorTest

- (void)testEnumeratingListItem
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

    // Create a simple list
    RKListStyle *listStyleA = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%*%d.", @"%*%d.", @"%*%d.", @"%*%d.", nil] styles:nil];
	RKListItem *listAItemA = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:0 resetIndex:NSUIntegerMax];
	RKListItem *listAItemAA = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:1 resetIndex:NSUIntegerMax];
    RKListItem *listAItemAB = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:1 resetIndex:NSUIntegerMax];
    RKListItem *listAItemABA = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:2 resetIndex:NSUIntegerMax];
    RKListItem *listAItemABAA = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:3 resetIndex:NSUIntegerMax];
	RKListItem *listAItemB = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:0 resetIndex:NSUIntegerMax];
	
	// Override index for partiuclar item
	RKListItem *listAItemC = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:0 resetIndex:44];
	RKListItem *listAItemD = [[RKListItem alloc] initWithStyle:listStyleA indentationLevel:0 resetIndex:NSUIntegerMax];
    
    // Create a list, where level 4 will start the item count with 12
    RKListStyle *listStyleB = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%*%d.", @"%*%d.", @"%*%d.", @"%*%d.", nil] styles:nil startNumbers:overrides];
    RKListItem *listBItemA = [[RKListItem alloc] initWithStyle:listStyleB indentationLevel:0 resetIndex:NSUIntegerMax];
	RKListItem *listBItemAA = [[RKListItem alloc] initWithStyle:listStyleB indentationLevel:1 resetIndex:NSUIntegerMax];
    RKListItem *listBItemAB = [[RKListItem alloc] initWithStyle:listStyleB indentationLevel:1 resetIndex:NSUIntegerMax];
    RKListItem *listBItemABA = [[RKListItem alloc] initWithStyle:listStyleB indentationLevel:2 resetIndex:NSUIntegerMax];
    RKListItem *listBItemABAA = [[RKListItem alloc] initWithStyle:listStyleB indentationLevel:3 resetIndex:NSUIntegerMax];
    RKListItem *listBItemB = [[RKListItem alloc] initWithStyle:listStyleB indentationLevel:0 resetIndex:NSUIntegerMax];
    
    RKListCounter *enumerator = [RKListCounter new];
    
    XCTAssertEqualObjects([enumerator markerForListItem: listAItemA], @"1.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemA], @"1.", @"Invalid marker");    

    XCTAssertEqualObjects([enumerator markerForListItem: listAItemAA], @"1.1.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemAA], @"1.1.", @"Invalid marker");

    XCTAssertEqualObjects([enumerator markerForListItem: listAItemAB], @"1.2.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemAB], @"1.2.", @"Invalid marker");    

    XCTAssertEqualObjects([enumerator markerForListItem: listAItemABA], @"1.2.1.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemABA], @"1.2.1.", @"Invalid marker");  

    XCTAssertEqualObjects([enumerator markerForListItem: listAItemABAA], @"1.2.1.1.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemABAA], @"1.2.1.12.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemABAA], @"1.2.1.13.", @"Invalid marker");
    
    XCTAssertEqualObjects([enumerator markerForListItem: listAItemB], @"2.", @"Invalid marker");
	XCTAssertEqualObjects([enumerator markerForListItem: listAItemC], @"44.", @"Invalid marker");
	XCTAssertEqualObjects([enumerator markerForListItem: listAItemD], @"45.", @"Invalid marker");
	
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemB], @"2.", @"Invalid marker");

    [enumerator resetCounterOfList: listStyleA];

    XCTAssertEqualObjects([enumerator markerForListItem: listAItemB], @"1.", @"Invalid marker");
    XCTAssertEqualObjects([enumerator markerForListItem: listBItemB], @"3.", @"Invalid marker");  
}

@end
