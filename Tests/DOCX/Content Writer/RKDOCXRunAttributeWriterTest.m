//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"


@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

- (void)testRunElementWithoutAttributes
{
	NSString *testString = @"Hello World";
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: testString];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [RKDOCXRunAttributeWriterTest expectedXMLWithoutRunAttributes];
	
	XCTAssertTrue([generated isEqual: expected], @"Generated XML for run attribute does not match expected XML.");
}

+ (NSXMLElement *)expectedXMLWithoutRunAttributes
{
	NSXMLElement *runElement = [NSXMLElement elementWithName:@"w:r"];
	NSXMLElement *textElement = [NSXMLElement elementWithName:@"w:t"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	return runElement;
}

@end
