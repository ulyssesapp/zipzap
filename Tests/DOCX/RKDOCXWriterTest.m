//
//  RKDOCXWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 25.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXWriterTest : XCTestCase

@end

@implementation RKDOCXWriterTest

- (void)testGeneratingEmptyDocument
{
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: [[NSAttributedString alloc] initWithString: @""]];
	
	[self assertDOCX:document withTestDocument:@"empty"];
}

- (void)testGeneratingUnformattedDocument
{
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: [[NSAttributedString alloc] initWithString: @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est."]];
	
	[self assertDOCX:document withTestDocument:@"simple"];
}

@end
