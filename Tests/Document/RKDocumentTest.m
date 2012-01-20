//
//  RKDocumentTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKDocument.h"
#import "RKSection.h"
#import "RKDocumentTest.h"

@implementation RKDocumentTest

// Create a document with a given array of sections
- (void)testSimpleDocumentWithSection
{
    NSArray *someArray = [NSArray new];
    RKDocument *document = [RKDocument simpleDocumentWithSections:someArray];
    
    STAssertEqualObjects(document.sections, someArray, @"Initialization failure");
}

// Create a document with a given attributed string
- (void)testSimpleDocumentWithAttributedString
{
    NSAttributedString *someString = [[NSAttributedString alloc] initWithString:@"Some String"];
    RKDocument *document = [RKDocument simpleDocumentWithAttributedString:someString];
    RKSection *section = [document.sections objectAtIndex: 0];
    
    STAssertEquals([document.sections count], (NSUInteger)1, @"Invalid section count after initialization with a single string");

    STAssertEqualObjects(section.content, someString, @"Invalid string used for section initialization");
}

@end
