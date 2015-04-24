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

- (void)testSectionPropertiesElementWithPageMargins
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This page has custom page margins. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est."]];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	document.headerSpacingBefore = 72;
	document.footerSpacingAfter = 72;
	document.pageInsets = RKPageInsetsMake(36, 36, 36, 36);
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"pagemargins"];
}

- (void)testSectionWithSameHeader
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has one header for all pages.\f\f"]];
	NSAttributedString *header = [[NSAttributedString alloc] initWithString: @"This is the only header."];
	[section setHeader:header forPages:RKPageSelectorAll];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"sameheader"];
}

- (void)testSectionWithSameFooter
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has one footer for all pages.\f\f"]];
	NSAttributedString *footer = [[NSAttributedString alloc] initWithString: @"This is the only footer."];
	[section setFooter:footer forPages:RKPageSelectorAll];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"samefooter"];
}

- (void)testSectionWithDifferentHeaders
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has three different headers.\f\f"]];
	NSAttributedString *firstHeader = [[NSAttributedString alloc] initWithString: @"This is the first header."];
	NSAttributedString *leftHeader = [[NSAttributedString alloc] initWithString: @"This is the left header."];
	NSAttributedString *rightHeader = [[NSAttributedString alloc] initWithString: @"This is the right header."];
	[section setHeader:firstHeader forPages:RKPageSelectionFirst];
	[section setHeader:leftHeader forPages:RKPageSelectionLeft];
	[section setHeader:rightHeader forPages:RKPageSelectionRight];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"differentheaders"];
}

- (void)testSectionWithDifferentFooters
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has three different footers.\f\f"]];
	NSAttributedString *firstFooter = [[NSAttributedString alloc] initWithString: @"This is the first footer."];
	NSAttributedString *leftFooter = [[NSAttributedString alloc] initWithString: @"This is the left footer."];
	NSAttributedString *rightFooter = [[NSAttributedString alloc] initWithString: @"This is the right footer."];
	[section setFooter:firstFooter forPages:RKPageSelectionFirst];
	[section setFooter:leftFooter forPages:RKPageSelectionLeft];
	[section setFooter:rightFooter forPages:RKPageSelectionRight];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"differentfooters"];
}

- (void)testSectionWithFirstPageHeader
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has only one header for the first page.\f\f"]];
	NSAttributedString *header = [[NSAttributedString alloc] initWithString: @"This is the only header."];
	[section setHeader:header forPages:RKPageSelectionFirst];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"firstpageheader"];
}

- (void)testSectionWithFirstPageFooter
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has only one footer for the first page.\f\f"]];
	NSAttributedString *footer = [[NSAttributedString alloc] initWithString: @"This is the only footer."];
	[section setFooter:footer forPages:RKPageSelectionFirst];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"firstpagefooter"];
}

- (void)testSectionWithOddPageHeader
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has one header for odd pages.\f\f"]];
	NSAttributedString *header = [[NSAttributedString alloc] initWithString: @"This is the odd header."];
	[section setHeader:header forPages:RKPageSelectionLeft];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"oddpageheader"];
}

- (void)testSectionWithOddPageFooter
{
	RKSection *section = [[RKSection alloc] initWithContent: [[NSAttributedString alloc] initWithString: @"This document has one footer for odd pages.\f\f"]];
	NSAttributedString *footer = [[NSAttributedString alloc] initWithString: @"This is the odd footer."];
	[section setFooter:footer forPages:RKPageSelectionLeft];
	RKDocument *document = [[RKDocument alloc] initWithSections: @[section]];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"oddpagefooter"];
}

@end
