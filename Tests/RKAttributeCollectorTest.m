//
//  RKAttributeCollectorTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeCollectorTest.h"
#import "RKAttributeCollector.h"
#import "RKDocument.h"

@implementation RKAttributeCollectorTest

- (void)testEmptyCollection
{
    RKDocument *document = [RKDocument documentWithAttributedString: [[NSAttributedString alloc] initWithString:@""]];
    NSDictionary *collectedHeaders = [RKAttributeCollector collectHeaderDefinitionsFromDocument:document];

    STAssertEquals([collectedHeaders count], 0, @"Header definitions collected for empty input");
}

- (void)testNoSections
{
    RKDocument *document = [[RKDocument alloc] init];
    NSDictionary *collectedHeaders = [RKAttributeCollector collectHeaderDefinitionsFromDocument:document];
    
    STAssertEquals([collectedHeaders count], 0, @"Header definitions collected for empty input");
}

- (void)testPureTextCollection
{
    RKDocument *document = [RKDocument documentWithAttributedString: [[NSAttributedString alloc] initWithString:@"abcd"]];
    NSDictionary *collectedHeaders = [RKAttributeCollector collectHeaderDefinitionsFromDocument:document];
    
    STAssertEquals([collectedHeaders count], 0, @"Header definitions collected for pure text input");
}




@end
