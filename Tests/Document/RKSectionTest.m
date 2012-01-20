//
//  RKSectionTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 20.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKSectionTest.h"
#import "RKSection.h"

@implementation RKSectionTest

// All code under test must be linked into the Unit Test bundle
- (void)testEmptySection
{
    RKSection *section = [RKSection new];
    
    STAssertEquals(section.numberOfColumns, (NSUInteger)1, @"Number of columns not initialized to 1 by default");
    STAssertEquals(section.numberOfFirstPage, (NSUInteger)1, @"Number of first page is not initialized to 1 by default");
    STAssertEquals(section.pageNumberingStyle, RKPageNumberingDecimal, @"Page numbering style is not set to decimals by default");

    STAssertEquals(section.sameHeaderForAllPages, YES, @"Headers for first / left / right page are not identical by default");
    STAssertEquals(section.sameFooterForAllPages, YES, @"Headers for first / left / right page are not identical by default");
}

- (void)testSectionWithContent
{
    NSAttributedString *someString = [[NSAttributedString alloc] initWithString:@"Some String"];
    RKSection *section = [RKSection sectionWithContent:someString];
    
    STAssertEquals(section.content, someString, @"Content not properly initialized");
    
    STAssertEquals(section.numberOfColumns, (NSUInteger)1, @"Number of columns not initialized to 1 by default");
    STAssertEquals(section.numberOfFirstPage, (NSUInteger)1, @"Number of first page is not initialized to 1 by default");
    STAssertEquals(section.pageNumberingStyle, RKPageNumberingDecimal, @"Page numbering style is not set to decimals by default");
    
    STAssertEquals(section.sameHeaderForAllPages, YES, @"Headers for first / left / right page are not identical by default");
    STAssertEquals(section.sameFooterForAllPages, YES, @"Headers for first / left / right page are not identical by default");
}

- (void)testHeaderForAllPages
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];

    [section setHeader:someHeader forPages:RKPageMaskAllPages];
    
    STAssertEquals(section.sameHeaderForAllPages, YES, @"Header not recognized for all pages");

    STAssertEquals([section headerForPage:RKPageMaskFirstPage], someHeader, @"Header not set for first page");
    STAssertEquals([section headerForPage:RKPageMaskLeftPage], someHeader, @"Header not set for left page");
    STAssertEquals([section headerForPage:RKPageMaskRightPage], someHeader, @"Header not set for right page");
}

- (void)testHeaderForFirstPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskFirstPage];
    
    STAssertEquals(section.sameHeaderForAllPages, NO, @"Header wrongly recognized for all pages");
    
    STAssertTrue([section headerForPage:RKPageMaskLeftPage] != someHeader, @"Header wrongly set for left page");
    STAssertTrue([section headerForPage:RKPageMaskRightPage] != someHeader, @"Header wrongly set for right page");
    
    STAssertEquals([section headerForPage:RKPageMaskFirstPage], someHeader, @"Header not set for first page");
}

- (void)testHeaderForLeftPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskLeftPage];
    
    STAssertEquals(section.sameHeaderForAllPages, NO, @"Header wrongly recognized for all pages");
    
    STAssertTrue([section headerForPage:RKPageMaskFirstPage] != someHeader, @"Header wrongly set for first page");
    STAssertTrue([section headerForPage:RKPageMaskRightPage] != someHeader, @"Header wrongly set for right page");

    STAssertEquals([section headerForPage:RKPageMaskLeftPage], someHeader, @"Header not set for left page");
}

- (void)testHeaderForRightPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskRightPage];
    
    STAssertEquals(section.sameHeaderForAllPages, NO, @"Header wrongly recognized for all pages");
    
    STAssertTrue([section headerForPage:RKPageMaskFirstPage] != someHeader, @"Header wrongly set for first page");
    STAssertTrue([section headerForPage:RKPageMaskLeftPage] != someHeader, @"Header wrongly set for left page");
    
    STAssertEquals([section headerForPage:RKPageMaskRightPage], someHeader, @"Header not set for right page");
}

@end
