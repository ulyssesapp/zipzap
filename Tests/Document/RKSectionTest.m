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
}

- (void)testSectionWithContent
{
    NSAttributedString *someString = [[NSAttributedString alloc] initWithString:@"Some String"];
    RKSection *section = [RKSection sectionWithContent:someString];
    
    STAssertEquals(section.content, someString, @"Content not properly initialized");
    
    STAssertEquals(section.numberOfColumns, (NSUInteger)1, @"Number of columns not initialized to 1 by default");
    STAssertEquals(section.numberOfFirstPage, (NSUInteger)1, @"Number of first page is not initialized to 1 by default");
    STAssertEquals(section.pageNumberingStyle, RKPageNumberingDecimal, @"Page numbering style is not set to decimals by default");
}

- (void)testHeaderForAllPages
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];

    [section setHeader:someHeader forPages:RKPageMaskAllPages];
    
    STAssertEquals([section headerForPage:RKPageMaskFirstPage], someHeader, @"Header not set for first page");
    STAssertEquals([section headerForPage:RKPageMaskLeftPage], someHeader, @"Header not set for left page");
    STAssertEquals([section headerForPage:RKPageMaskRightPage], someHeader, @"Header not set for right page");
}

- (void)testHeaderForFirstPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskFirstPage];
    
    STAssertTrue([section headerForPage:RKPageMaskLeftPage] != someHeader, @"Header wrongly set for left page");
    STAssertTrue([section headerForPage:RKPageMaskRightPage] != someHeader, @"Header wrongly set for right page");
    
    STAssertEquals([section headerForPage:RKPageMaskFirstPage], someHeader, @"Header not set for first page");
}

- (void)testHeaderForLeftPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskLeftPage];
    
    STAssertTrue([section headerForPage:RKPageMaskFirstPage] != someHeader, @"Header wrongly set for first page");
    STAssertTrue([section headerForPage:RKPageMaskRightPage] != someHeader, @"Header wrongly set for right page");

    STAssertEquals([section headerForPage:RKPageMaskLeftPage], someHeader, @"Header not set for left page");
}

- (void)testHeaderForRightPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskRightPage];
    
    STAssertTrue([section headerForPage:RKPageMaskFirstPage] != someHeader, @"Header wrongly set for first page");
    STAssertTrue([section headerForPage:RKPageMaskLeftPage] != someHeader, @"Header wrongly set for left page");
    
    STAssertEquals([section headerForPage:RKPageMaskRightPage], someHeader, @"Header not set for right page");
}

- (void)testFooterForAllPages
{
    RKSection *section = [RKSection new];
    NSAttributedString *someFooter = [[NSAttributedString alloc] initWithString:@"Some Footer"];
    
    [section setFooter:someFooter forPages:RKPageMaskAllPages];
    
    STAssertEquals([section footerForPage:RKPageMaskFirstPage], someFooter, @"Footer not set for first page");
    STAssertEquals([section footerForPage:RKPageMaskLeftPage], someFooter, @"Footer not set for left page");
    STAssertEquals([section footerForPage:RKPageMaskRightPage], someFooter, @"Footer not set for right page");
}

- (void)testFooterForFirstPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someFooter = [[NSAttributedString alloc] initWithString:@"Some Footer"];
    
    [section setFooter:someFooter forPages:RKPageMaskFirstPage];
    
    STAssertTrue([section footerForPage:RKPageMaskLeftPage] != someFooter, @"Footer wrongly set for left page");
    STAssertTrue([section footerForPage:RKPageMaskRightPage] != someFooter, @"Footer wrongly set for right page");
    
    STAssertEquals([section footerForPage:RKPageMaskFirstPage], someFooter, @"Footer not set for first page");
}

- (void)testFooterForLeftPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someFooter = [[NSAttributedString alloc] initWithString:@"Some Footer"];
    
    [section setFooter:someFooter forPages:RKPageMaskLeftPage];
    
    STAssertTrue([section footerForPage:RKPageMaskFirstPage] != someFooter, @"Footer wrongly set for first page");
    STAssertTrue([section footerForPage:RKPageMaskRightPage] != someFooter, @"Footer wrongly set for right page");
    
    STAssertEquals([section footerForPage:RKPageMaskLeftPage], someFooter, @"Footer not set for left page");
}

- (void)testFooterForRightPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someFooter = [[NSAttributedString alloc] initWithString:@"Some Footer"];
    
    [section setFooter:someFooter forPages:RKPageMaskRightPage];
    
    STAssertTrue([section footerForPage:RKPageMaskFirstPage] != someFooter, @"Footer wrongly set for first page");
    STAssertTrue([section footerForPage:RKPageMaskLeftPage] != someFooter, @"Footer wrongly set for left page");
    
    STAssertEquals([section footerForPage:RKPageMaskRightPage], someFooter, @"Footer not set for right page");
}

@end
