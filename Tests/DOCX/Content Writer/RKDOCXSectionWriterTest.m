//
//  RKDOCXSectionWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXSectionWriterTest : XCTestCase

@end

@implementation RKDOCXSectionWriterTest

- (void)testSectionPropertiesElementWithTwoColumns
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This text is displayed in two columns. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est."]];
	section.numberOfColumns = 2;
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"twocolumns"];
}

- (void)testSectionPropertiesElementWithPageNumberType
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This section starts with page number 42. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est."]];
	section.indexOfFirstPage = 42;
	section.pageNumberingStyle = RKPageNumberingRomanUpperCase;
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"pagenumbertype"];
}

- (void)testSectionPropertiesElementWithPageSize
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This page has the form of a square. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est."]];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	document.pageSize = CGSizeMake(500, 500);
	document.pageOrientation = RKPageOrientationLandscape;
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"pagesize"];
}

@end
