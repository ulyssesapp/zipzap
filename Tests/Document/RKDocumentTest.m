//
//  RKDocumentTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKDocument.h"
#import "RKDocumentTest.h"

@implementation RKDocumentTest

// All code under test must be linked into the Unit Test bundle
- (void)testSimpleDocumentWithSection
{
    NSArray *someArray = [NSArray new];
    RKDocument *document = [RKDocument simpleDocumentWithSections:someArray];
    
    STAssertEqualObjects(document.sections, someArray, @"Initialization failure");
}

@end
