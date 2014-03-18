//
//  RKDocumentTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKDocumentTest.h"

@implementation RKDocumentTest

- (void)testSimpleDocumentWithSection
{
    NSArray *someArray = [NSArray new];
    RKDocument *document = [RKDocument documentWithSections:someArray];

    XCTAssertEqualObjects(document.sections, someArray, @"Initialization failure");
}

- (void)testSimpleDocumentWithAttributedString
{
    NSAttributedString *someString = [[NSAttributedString alloc] initWithString:@"Some String"];
    RKDocument *document = [RKDocument documentWithAttributedString:someString];
    RKSection *section = [document.sections objectAtIndex: 0];

    XCTAssertEqual([document.sections count], (NSUInteger)1, @"Invalid section count after initialization with a single string");

    XCTAssertEqualObjects(section.content, someString, @"Invalid string used for section initialization");

    // Test assertion on invalid input
    XCTAssertThrows([RKDocument documentWithAttributedString:nil], @"Expecting exception");
}

@end
