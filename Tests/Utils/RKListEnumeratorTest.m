//
//  RKListEnumeratorTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 04.04.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListEnumeratorTest.h"
#import "RKListEnumerator.h"
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
    RKListStyle *listStyleA = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%*%d.", @"%*%d.", @"%*%d.", @"%*%d.", nil]];
    RKListItem *listAItemA = [RKListItem listItemWithStyle:listStyleA indentationLevel:0];
    RKListItem *listAItemAA = [RKListItem listItemWithStyle:listStyleA indentationLevel:1];
    RKListItem *listAItemAB = [RKListItem listItemWithStyle:listStyleA indentationLevel:1];
    RKListItem *listAItemABA = [RKListItem listItemWithStyle:listStyleA indentationLevel:2];
    RKListItem *listAItemABAA = [RKListItem listItemWithStyle:listStyleA indentationLevel:3];
    RKListItem *listAItemB = [RKListItem listItemWithStyle:listStyleA indentationLevel:0];    
    
    // Create a list, where level 4 will start the item count with 12
    RKListStyle *listStyleB = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%*%d.", @"%*%d.", @"%*%d.", @"%*%d.", nil] startNumbers:overrides];
    RKListItem *listBItemA = [RKListItem listItemWithStyle:listStyleB indentationLevel:0];
    RKListItem *listBItemAA = [RKListItem listItemWithStyle:listStyleB indentationLevel:1];
    RKListItem *listBItemAB = [RKListItem listItemWithStyle:listStyleB indentationLevel:1];
    RKListItem *listBItemABA = [RKListItem listItemWithStyle:listStyleB indentationLevel:2];
    RKListItem *listBItemABAA = [RKListItem listItemWithStyle:listStyleB indentationLevel:3];
    RKListItem *listBItemB = [RKListItem listItemWithStyle:listStyleB indentationLevel:0];    
    
    RKListEnumerator *enumerator = [RKListEnumerator new];
    
    STAssertEqualObjects([enumerator markerForListItem: listAItemA], @"1.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemA], @"1.", @"Invalid marker");    

    STAssertEqualObjects([enumerator markerForListItem: listAItemAA], @"1.1.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemAA], @"1.1.", @"Invalid marker");

    STAssertEqualObjects([enumerator markerForListItem: listAItemAB], @"1.2.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemAB], @"1.2.", @"Invalid marker");    

    STAssertEqualObjects([enumerator markerForListItem: listAItemABA], @"1.2.1.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemABA], @"1.2.1.", @"Invalid marker");  

    STAssertEqualObjects([enumerator markerForListItem: listAItemABAA], @"1.2.1.1.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemABAA], @"1.2.1.12.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemABAA], @"1.2.1.13.", @"Invalid marker");
    
    STAssertEqualObjects([enumerator markerForListItem: listAItemB], @"2.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemB], @"2.", @"Invalid marker");  

    [enumerator resetCounterOfList: listStyleA];

    STAssertEqualObjects([enumerator markerForListItem: listAItemB], @"1.", @"Invalid marker");
    STAssertEqualObjects([enumerator markerForListItem: listBItemB], @"3.", @"Invalid marker");  
}

@end
