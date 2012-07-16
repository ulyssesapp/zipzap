//
//  RKDocumentPersistenceTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocumentPersistenceTest.h"

#import "RKDocument+RKPersistence.h"

@implementation RKDocumentPersistenceTest

- (void)testSerializationOfDocument
{
    // Create test strings
    NSAttributedString *content = [[NSAttributedString alloc] initWithString: @"content"];
    NSAttributedString *headerAll = [[NSAttributedString alloc] initWithString: @"header All"];
    NSAttributedString *footerFirst = [[NSAttributedString alloc] initWithString: @"footer First"];
    NSAttributedString *footerLeft = [[NSAttributedString alloc] initWithString: @"footer Left"];
    NSAttributedString *footerRight = [[NSAttributedString alloc] initWithString: @"footer Right"];
    
    // Create test section
    RKSection *testSection = [RKSection new];
    testSection.content = content;
    [testSection setHeader:headerAll forPages:RKPageSelectorAll];
    [testSection setFooter:footerFirst forPages:RKPageSelectionFirst];
    [testSection setFooter:footerLeft forPages:RKPageSelectionLeft];
    [testSection setFooter:footerRight forPages:RKPageSelectionRight];

    testSection.numberOfColumns = 2;
    testSection.pageNumberingStyle = RKPageNumberingAlphabeticUpperCase;
    testSection.indexOfFirstPage = 3;
    testSection.columnSpacing = 0.5;

    // Create test document
    RKDocument *testDocument = [[RKDocument alloc] initWithSections: [NSArray arrayWithObject: testSection]];
    
    testDocument.metadata = [NSDictionary dictionaryWithObject:@"abc" forKey:NSTitleDocumentAttribute];
    testDocument.hyphenationEnabled = YES;
    testDocument.pageSize = NSMakeSize(100, 200);
    testDocument.footerSpacing = 5;
    testDocument.headerSpacing = 6;
    testDocument.pageInsets = RKPageInsetsMake(1, 2, 3, 4);
    testDocument.footnotePlacement = RKFootnotePlacementSectionEnd;
    testDocument.endnotePlacement = RKEndnotePlacementSectionEnd;
    
    testDocument.footnoteEnumerationPolicy = RKFootnoteEnumerationPerPage;
    testDocument.endnoteEnumerationPolicy = RKFootnoteEnumerationPerSection;
    
    testDocument.footnoteEnumerationStyle = RKFootnoteEnumerationAlphabeticLowerCase;
    testDocument.endnoteEnumerationStyle = RKFootnoteEnumerationAlphabeticUpperCase;
    
    NSDictionary *paragraphStyle = [NSDictionary dictionaryWithObject:[NSParagraphStyle defaultParagraphStyle] forKey:NSParagraphStyleAttributeName];
    testDocument.paragraphStyles = [NSDictionary dictionaryWithObject:paragraphStyle forKey:@"My Paragraph"];

    NSDictionary *characterStyle = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Helvetica-Bold" size:22] forKey:NSFontAttributeName];
    testDocument.characterStyles = [NSDictionary dictionaryWithObject:characterStyle forKey:@"My Font"];
    
    // Serialize document
    NSDictionary *serializedDocument = testDocument.RTFKitPropertyListRepresentation;

    // De-serialize document
    NSError *error;
    RKDocument *deserializedDocument = [[RKDocument alloc] initWithRTFKitPropertyListRepresentation:serializedDocument error:&error];
    
    STAssertNil(error, @"An error occured");
    STAssertNotNil(deserializedDocument, @"Document should not be nil");
    
    STAssertEqualObjects(testDocument, deserializedDocument, @"Documents not equal");
}

@end
