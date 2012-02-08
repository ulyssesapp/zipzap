//
//  RKTextListItemWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListItemWriter.h"
#import "RKTextListItemWriterTest.h"

@implementation RKTextListItemWriterTest

- (RKTextListItem *)generateListItem
{
    RKTextList *textList = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects:@"%d.", @"%*%r.", @"%*%a.", nil]];
    RKTextListItem *textListItem = [RKTextListItem textListItemWithTextList:textList withIndentationLevel:2];

    return textListItem;
}

- (void)testRegisterListItemToPool
{
    RKTextListItem *textListItem = [self generateListItem];

    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"aaa"];
    RKResourcePool *resourcePool = [RKResourcePool new];
    
    [RKTextListItemWriter addTagsForAttribute:textListItem toTaggedString:taggedString inRange:NSMakeRange(0, 1) withAttachmentPolicy:0 resources:resourcePool];
    [RKTextListItemWriter addTagsForAttribute:textListItem toTaggedString:taggedString inRange:NSMakeRange(0, 1) withAttachmentPolicy:0 resources:resourcePool];
    [RKTextListItemWriter addTagsForAttribute:textListItem toTaggedString:taggedString inRange:NSMakeRange(0, 1) withAttachmentPolicy:0 resources:resourcePool];    

    // Text List properly registered
    NSArray *textLists = [resourcePool textLists];

    STAssertEquals(textLists.count, (NSUInteger)1, @"Invalid text list count");
    STAssertEquals([textLists objectAtIndex: 0], textListItem.textList, @"Invalid text list registered");    

    // Item counts properly incremented
    NSArray *itemNumbers = [resourcePool incrementItemNumbersForListLevel:2 ofList:textListItem.textList];    

    STAssertEquals(itemNumbers.count, (NSUInteger)3, @"Invalid text list count");
    STAssertEquals([[itemNumbers objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)1, @"Invalid text list registered");    
    STAssertEquals([[itemNumbers objectAtIndex: 1] unsignedIntegerValue], (NSUInteger)1, @"Invalid text list registered");    
    STAssertEquals([[itemNumbers objectAtIndex: 2] unsignedIntegerValue], (NSUInteger)4, @"Invalid text list registered");        
}

- (void)testGenerateListTags
{
    RKTextListItem *textListItem = [self generateListItem];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"aaa"];
    RKResourcePool *resourcePool = [RKResourcePool new];
    
    // Set item numbers to 2.1.3
    [resourcePool incrementItemNumbersForListLevel:0 ofList:textListItem.textList];
    [resourcePool incrementItemNumbersForListLevel:0 ofList:textListItem.textList];

    [resourcePool incrementItemNumbersForListLevel:2 ofList:textListItem.textList];
    [resourcePool incrementItemNumbersForListLevel:2 ofList:textListItem.textList];
    [resourcePool incrementItemNumbersForListLevel:2 ofList:textListItem.textList];
        
    // Generate item number (will increment to 2.1.4)
    [RKTextListItemWriter addTagsForAttribute:textListItem toTaggedString:taggedString inRange:NSMakeRange(0, 1) withAttachmentPolicy:0 resources:resourcePool];

    STAssertEqualObjects([taggedString flattenedRTFString],
                         @"\\ls1\\ilvl2 "
                          "{\\listtext\t2.i.d.\t}aaa",
                         @"Invalid list tagging"
                         );
}

@end
