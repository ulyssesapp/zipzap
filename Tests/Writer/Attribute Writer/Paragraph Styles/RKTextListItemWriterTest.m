//
//  RKTextListItemWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListItemWriter.h"
#import "RKTextListItemWriterTest.h"

@interface RKTextListItemWriterTest ()

- (void)assertListItemAtParagraphIndex:(NSUInteger)paragraphIndex
                    ofAttributedString:(NSAttributedString *)attributedString 
                       withIndentation:(NSUInteger)indentation 
                           withMarkers:(NSArray *)markers 
                   withPrependSettings:(NSArray *)prependSettings
               withStartingItemNumbers:(NSArray *)startingItemNumber;

@end

@implementation RKTextListItemWriterTest

- (RKTextListItem *)generateListItem
{
    RKTextList *textList = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects:@"%d.", @"%*%r.", @"%*%a.", nil]];
    RKTextListItem *textListItem = [RKTextListItem textListItemWithTextList:textList withIndentationLevel:2];

    return textListItem;
}

- (NSAttributedString *)generateComplexList
{
    RKTextList *textList = [RKTextList textListWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%a.", nil] 
                                  withOveridingStartItemNumbers:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger: 1], [NSNumber numberWithInteger: 0],
                                                                 [NSNumber numberWithInteger: 3], [NSNumber numberWithInteger: 1], 
                                                                 [NSNumber numberWithInteger: 1], [NSNumber numberWithInteger: 2], 
                                                                 nil
                                                                 ]
                            ];
    
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"A"] usingList:textList withIndentationLevel:0];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AA"] usingList:textList withIndentationLevel:1];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AAA"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AAB"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AAC"] usingList:textList withIndentationLevel:2];    
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AB"] usingList:textList withIndentationLevel:1];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ABA"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ABB"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ABC"] usingList:textList withIndentationLevel:2];    
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AC"] usingList:textList withIndentationLevel:1];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ACA"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ACB"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ACC"] usingList:textList withIndentationLevel:2];    
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"B"] usingList:textList withIndentationLevel:0];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BA"] usingList:textList withIndentationLevel:1];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BAA"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BAB"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BAC"] usingList:textList withIndentationLevel:2];    
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BB"] usingList:textList withIndentationLevel:1];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BBA"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BBB"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BBC"] usingList:textList withIndentationLevel:2];    
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BC"] usingList:textList withIndentationLevel:1];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BCA"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BCB"] usingList:textList withIndentationLevel:2];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BCC"] usingList:textList withIndentationLevel:2];   
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"C"] usingList:textList withIndentationLevel:0];

    return testString;
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

- (void)assertListItemAtParagraphIndex:(NSUInteger)paragraphIndex
                    ofAttributedString:(NSAttributedString *)attributedString 
                       withIndentation:(NSUInteger)indentation 
                           withMarkers:(NSArray *)markers 
                   withPrependSettings:(NSArray *)prependSettings
               withStartingItemNumbers:(NSArray *)startingItemNumber
{
    __block NSRange paragraphRange;
    __block NSUInteger currentParagraphIndex = 0;
    
    [[attributedString string] enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         if (currentParagraphIndex == paragraphIndex) {
             paragraphRange = enclosingRange;
             *stop = true;
         }
         
         currentParagraphIndex ++;
     }];
        
    NSParagraphStyle *paragraphStyle = [attributedString attribute:NSParagraphStyleAttributeName atIndex:paragraphRange.location effectiveRange:nil];

    NSArray *textLists = paragraphStyle.textLists;
    STAssertNotNil(textLists, @"No text lists found");
    
    STAssertEquals(textLists.count - 1, indentation, @"Wrong indentation level");

    [textLists enumerateObjectsUsingBlock:^(NSTextList *textList, NSUInteger index, BOOL *stop) {
        STAssertEqualObjects(textList.markerFormat, [markers objectAtIndex:index], @"Invalid marker format");

        STAssertEquals((textList.listOptions & NSTextListPrependEnclosingMarker) == NSTextListPrependEnclosingMarker, 
                       [[prependSettings objectAtIndex:index] intValue], 
                       @"Invalid prepend setting");

        STAssertEquals(textList.startingItemNumber, 
                       [[startingItemNumber objectAtIndex:index] integerValue],
                       @"Invalid item start number"
                       );
    }];
}

- (void)testRereadingListsWithCocoa
{
    NSAttributedString *testString = [self generateComplexList];
    NSAttributedString *converted = [self convertAndRereadRTF:testString documentAttributes:NULL];
    
    // Test acceptance of list items
    [self assertListItemAtParagraphIndex:0
                      ofAttributedString:converted
                         withIndentation:0
                             withMarkers:[NSArray arrayWithObjects: @"{decimal}.", nil]
                     withPrependSettings:[NSArray arrayWithObjects: [NSNumber numberWithInt: 0], nil]
                 withStartingItemNumbers:[NSArray arrayWithObjects: [NSNumber numberWithInt: 1], nil]
     ];
    
    [self assertListItemAtParagraphIndex:1
                      ofAttributedString:converted
                         withIndentation:1
                             withMarkers:[NSArray arrayWithObjects: @"{decimal}.", @"{lower-roman}.", nil]
                     withPrependSettings:[NSArray arrayWithObjects: [NSNumber numberWithInt: 0], [NSNumber numberWithInt: 1], nil]
                 withStartingItemNumbers:[NSArray arrayWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], nil]
     ];    
    
    [self assertListItemAtParagraphIndex:2
                      ofAttributedString:converted
                         withIndentation:2
                             withMarkers:[NSArray arrayWithObjects: @"{decimal}.", @"{lower-roman}.", @"{lower-alpha}.", nil]
                     withPrependSettings:[NSArray arrayWithObjects: [NSNumber numberWithInt: 0], [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 1], nil]
                 withStartingItemNumbers:[NSArray arrayWithObjects: [NSNumber numberWithInt: 1], [NSNumber numberWithInt: 3], [NSNumber numberWithInt: 1], nil]
     ];        
    
    // Test acceptance of replacement strings
    STAssertEqualObjects([converted string],
                         @"\t1.\tA\n"
                         "\t1.iii.\tAA\n"
                         "\t1.iii.a.\tAAA\n"
                         "\t1.iii.b.\tAAB\n"
                         "\t1.iii.c.\tAAC\n"
                         "\t1.iv.\tAB\n"
                         "\t1.iv.a.\tABA\n"
                         "\t1.iv.b.\tABB\n"
                         "\t1.iv.c.\tABC\n"
                         "\t1.v.\tAC\n"
                         "\t1.v.a.\tACA\n"
                         "\t1.v.b.\tACB\n"
                         "\t1.v.c.\tACC\n"
                         "\t2.\tB\n"
                         "\t2.iii.\tBA\n"
                         "\t2.iii.a.\tBAA\n"
                         "\t2.iii.b.\tBAB\n"
                         "\t2.iii.c.\tBAC\n"
                         "\t2.iv.\tBB\n"
                         "\t2.iv.a.\tBBA\n"
                         "\t2.iv.b.\tBBB\n"
                         "\t2.iv.c.\tBBC\n"
                         "\t2.v.\tBC\n"
                         "\t2.v.a.\tBCA\n"
                         "\t2.v.b.\tBCB\n"
                         "\t2.v.c.\tBCC\n"
                         "\t3.\tC\n",
                         @"Invalid conversion"
                         );
}

- (void)testComplexListsAreCompatibleToManualReferenceTest
{
    NSAttributedString *testString = [self generateComplexList];
   
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithAttributedString: testString];
    NSData *converted = [document RTF];
    
    [self assertRTF: converted withTestDocument: @"list"];
}

@end
