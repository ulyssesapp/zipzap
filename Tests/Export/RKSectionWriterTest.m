//
//  RKSectionWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSectionWriterTest.h"
#import "RKSectionWriter+TestExtensions.h"

@implementation RKSectionWriterTest

- (void)testGeneratingSectionHeaders
{
    RKSection *section = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@""]];

    // Settings used in all tests
    section.numberOfColumns = 2;
    section.indexOfFirstPage = 3;
    
    // Decimal page numbering
    section.pageNumberingStyle = RKPageNumberingDecimal;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\cols2\\pgnstarts3\\pgndec", @"Invalid translation");

    // Roman lower case
    section.pageNumberingStyle = RKPageNumberingRomanLowerCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\cols2\\pgnstarts3\\pgnlcrm", @"Invalid translation");

    // Roman upper case
    section.pageNumberingStyle = RKPageNumberingRomanUpperCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\cols2\\pgnstarts3\\pgnucrm", @"Invalid translation");

    // Letter upper case
    section.pageNumberingStyle = RKPageNumberingAlphabeticUpperCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\cols2\\pgnstarts3\\pgnultr", @"Invalid translation");

    // Letter lower case
    section.pageNumberingStyle = RKPageNumberingAlphabeticLowerCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\cols2\\pgnstarts3\\pgnlltr", @"Invalid translation");
}

@end
