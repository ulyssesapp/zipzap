//
//  RKTextListItemWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItemWriter.h"
#import "RKListItemWriterTest.h"

@interface RKListItemWriterTest ()

#if !TARGET_OS_IPHONE
- (void)assertListItemAtParagraphIndex:(NSUInteger)paragraphIndex
                    ofAttributedString:(NSAttributedString *)attributedString 
                       withIndentation:(NSUInteger)indentation 
                           withMarkers:(NSArray *)markers 
                   withPrependSettings:(NSArray *)prependSettings
               withStartingItemNumbers:(NSArray *)startingItemNumber;
#endif

@end

@implementation RKListItemWriterTest

- (RKListItem *)generateListItem
{
	NSArray *styles = @[@{RKListStyleMarkerLocationKey:@10, RKListStyleMarkerWidthKey:@20},
						@{RKListStyleMarkerLocationKey:@11, RKListStyleMarkerWidthKey:@21},
						@{RKListStyleMarkerLocationKey:@12, RKListStyleMarkerWidthKey:@22}
						];
		
    RKListStyle *textList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d.", @"%*%r.", @"%*%a.", nil] styles:styles];
	RKListItem *textListItem = [[RKListItem alloc] initWithStyle:textList indentationLevel:2 resetIndex:NSUIntegerMax];

    return textListItem;
}

- (NSAttributedString *)generateComplexList
{
	NSArray *styles = @[@{RKListStyleMarkerLocationKey:@100, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@110, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@120, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@130, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@140, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@150, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@160, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@170, RKListStyleMarkerWidthKey:@50},
						@{RKListStyleMarkerLocationKey:@180, RKListStyleMarkerWidthKey:@50}
					   ];
	
    RKListStyle *textList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects: @"%d.", @"%*%r.", @"%*%a.", nil]
															styles:styles
                                                      startNumbers:[NSArray arrayWithObjects:
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 3],
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 1],
																	[NSNumber numberWithInteger: 1],
																	nil
                                                                   ]
                            ];
    
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:@""];
    
	[testString appendListItem:[[NSAttributedString alloc] initWithString:@"A\nB"] withStyle:textList withIndentationLevel:0 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AA"] withStyle:textList withIndentationLevel:1 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AAA"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AAB"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AAC"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AB"] withStyle:textList withIndentationLevel:1 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ABA"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ABB"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ABC"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"AC"] withStyle:textList withIndentationLevel:1 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ACA"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ACB"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"ACC"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"B"] withStyle:textList withIndentationLevel:0 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BA"] withStyle:textList withIndentationLevel:1 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BAA"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BAB"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BAC"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BB"] withStyle:textList withIndentationLevel:1 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BBA"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BBB"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BBC"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BC"] withStyle:textList withIndentationLevel:1 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BCA"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BCB"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"BCC"] withStyle:textList withIndentationLevel:2 resetIndex:NSUIntegerMax];
    
    [testString appendListItem:[[NSAttributedString alloc] initWithString:@"C"] withStyle:textList withIndentationLevel:0 resetIndex:NSUIntegerMax];

    return testString;
}

- (void)testRegisterListItemToPool
{
    RKListItem *textListItem = [self generateListItem];

    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"aaa"];
    RKResourcePool *resourcePool = [RKResourcePool new];
    
    [RKListItemWriter addTagsForAttribute:RKListItemAttributeName value:textListItem effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resourcePool];
    [RKListItemWriter addTagsForAttribute:RKListItemAttributeName value:textListItem effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resourcePool];
    [RKListItemWriter addTagsForAttribute:RKListItemAttributeName value:textListItem effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resourcePool];

    // Text List properly registered
    NSDictionary *textLists = [resourcePool.listCounter listStyles];

    XCTAssertEqual(textLists.count, (NSUInteger)1, @"Invalid text list count");
    XCTAssertEqual([textLists.allValues objectAtIndex: 0], textListItem.listStyle, @"Invalid text list registered");

    // Item counts properly incremented
	NSArray *itemNumbers = [resourcePool.listCounter incrementItemNumbersForListLevel:2 ofList:textListItem.listStyle resetIndex:NSUIntegerMax];

    XCTAssertEqual(itemNumbers.count, (NSUInteger)3, @"Invalid text list count");
    XCTAssertEqual([[itemNumbers objectAtIndex: 0] unsignedIntegerValue], (NSUInteger)1, @"Invalid text list registered");    
    XCTAssertEqual([[itemNumbers objectAtIndex: 1] unsignedIntegerValue], (NSUInteger)1, @"Invalid text list registered");    
    XCTAssertEqual([[itemNumbers objectAtIndex: 2] unsignedIntegerValue], (NSUInteger)4, @"Invalid text list registered");        
}

- (void)testGenerateListTags
{
    RKListItem *textListItem = [self generateListItem];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"aaa"];
    RKResourcePool *resourcePool = [RKResourcePool new];
    
    // Set item numbers to 2.1.3
    [resourcePool.listCounter incrementItemNumbersForListLevel:0 ofList:textListItem.listStyle resetIndex:NSUIntegerMax];
    [resourcePool.listCounter incrementItemNumbersForListLevel:0 ofList:textListItem.listStyle resetIndex:NSUIntegerMax];

    [resourcePool.listCounter incrementItemNumbersForListLevel:2 ofList:textListItem.listStyle resetIndex:NSUIntegerMax];
    [resourcePool.listCounter incrementItemNumbersForListLevel:2 ofList:textListItem.listStyle resetIndex:NSUIntegerMax];
    [resourcePool.listCounter incrementItemNumbersForListLevel:2 ofList:textListItem.listStyle resetIndex:NSUIntegerMax];
        
    // Generate item number (will increment to 2.1.4)
    [RKListItemWriter addTagsForAttribute:RKListItemAttributeName value:textListItem effectiveRange:NSMakeRange(0,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resourcePool];
    
    XCTAssertEqualObjects([taggedString flattenedRTFString],
                         @"\\ls1\\ilvl2 "
                          "{\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 \\listtext\t2.i.d.\t}a\\par\\pardaa",
                         @"Invalid list tagging"
                         );
}

#if !TARGET_OS_IPHONE
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
    XCTAssertNotNil(textLists, @"No text lists found");
    
    XCTAssertEqual(textLists.count - 1, indentation, @"Wrong indentation level");

    [textLists enumerateObjectsUsingBlock:^(NSTextList *textList, NSUInteger index, BOOL *stop) {
        XCTAssertEqualObjects(textList.markerFormat, [markers objectAtIndex:index], @"Invalid marker format");

        XCTAssertEqual((textList.listOptions & NSTextListPrependEnclosingMarker) == NSTextListPrependEnclosingMarker, 
                       (int)[[prependSettings objectAtIndex:index] unsignedIntegerValue], 
                       @"Invalid prepend setting");

        XCTAssertEqual(textList.startingItemNumber, 
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
    XCTAssertEqualObjects([converted string],
                         @"\t1.\tA\u2028"
						  "B\n"
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
#endif

- (void)testComplexListsAreCompatibleToManualReferenceTestOnWordRTF
{
    NSAttributedString *testString = [self generateComplexList];
   
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [[RKDocument alloc] initWithAttributedString: testString];
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"list-word"];
}

- (void)testComplexListsAreCompatibleToManualReferenceTestOnSystemRTF
{
    NSAttributedString *testString = [self generateComplexList];
	
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.
    RKDocument *document = [[RKDocument alloc] initWithAttributedString: testString];
    NSData *converted = [document systemRTF];
    
    [self assertRTF: converted withTestDocument: @"list-system"];
}

@end
