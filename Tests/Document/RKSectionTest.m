//
//  RKSectionTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 20.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKSectionTest.h"
#import "RKSection+TestExtensions.h"
#import "RKSection.h"

@implementation RKSectionTest

- (void)testEmptySection
{
    RKSection *section = [RKSection new];
    
    STAssertEquals(section.numberOfColumns, (NSUInteger)1, @"Number of columns not initialized to 1 by default");
    STAssertEquals(section.indexOfFirstPage, (NSUInteger)1, @"Number of first page is not initialized to 1 by default");
    STAssertEquals(section.pageNumberingStyle, RKPageNumberingDecimal, @"Page numbering style is not set to decimals by default");
}

- (void)testSectionWithContent
{
    NSAttributedString *someString = [[NSAttributedString alloc] initWithString:@"Some String"];
    RKSection *section = [RKSection sectionWithContent:someString];
    
    STAssertEquals(section.content, someString, @"Content not properly initialized");
    
    STAssertEquals(section.numberOfColumns, (NSUInteger)1, @"Number of columns not initialized to 1 by default");
    STAssertEquals(section.indexOfFirstPage, (NSUInteger)1, @"Number of first page is not initialized to 1 by default");
    STAssertEquals(section.pageNumberingStyle, RKPageNumberingDecimal, @"Page numbering style is not set to decimals by default");

    // Testing assertion
    STAssertThrows([RKSection sectionWithContent:nil], @"No assertion on empty content string");
}

- (void)testFrameTextForAllPages
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    // Tests the internal functionality used to set headers and footers when setting all pages    
    [section setObject:someText forPages:RKPageSelectorAll toMap:textmap];

    STAssertEquals([section objectForPage:RKPageSelectionFirst fromMap:textmap], someText, @"Header not set for first page");
    STAssertEquals([section objectForPage:RKPageSelectionLeft fromMap:textmap], someText, @"Header not set for left page");
    STAssertEquals([section objectForPage:RKPageSelectionRight fromMap:textmap], someText, @"Header not set for right page");
}

- (void)testFrameTextForFirstPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];

    // Tests the internal functionality used to set headers and footers when setting the first page only
    [section setObject:someText forPages:RKPageSelectionFirst toMap:textmap];
    
    STAssertEquals([section objectForPage:RKPageSelectionFirst fromMap:textmap], someText, @"Header not set for first page");
    STAssertTrue([section objectForPage:RKPageSelectionLeft fromMap:textmap] == nil, @"Header wrongly set for left page");
    STAssertTrue([section objectForPage:RKPageSelectionRight fromMap:textmap] == nil, @"Header wrongly set for right page");
}

- (void)testFrameTextForLeftPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    // Tests the internal functionality used to set headers and footers when setting the left page only
    [section setObject:someText forPages:RKPageSelectionLeft toMap:textmap];
    
    STAssertEquals([section objectForPage:RKPageSelectionLeft fromMap:textmap], someText, @"Header not set for left page");
    STAssertTrue([section objectForPage:RKPageSelectionFirst fromMap:textmap] == nil, @"Header wrongly set for first page");
    STAssertTrue([section objectForPage:RKPageSelectionRight fromMap:textmap] == nil, @"Header wrongly set for right page");
}

- (void)testFrameTextForRightPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    // Tests the internal functionality used to set headers and footers  when setting the right page only
    [section setObject:someText forPages:RKPageSelectionRight toMap:textmap];
    
    STAssertEquals([section objectForPage:RKPageSelectionRight fromMap:textmap], someText, @"Header not set for right page");
    STAssertTrue([section objectForPage:RKPageSelectionFirst fromMap:textmap] == nil, @"Header wrongly set for first page");
    STAssertTrue([section objectForPage:RKPageSelectionLeft fromMap:textmap] == nil, @"Header wrongly set for legt page");
}

- (void)testFrameTextNoContentGiven
{
    RKSection *section = [RKSection new];
    NSMapTable *textmap = [NSMapTable mapTableWithStrongToStrongObjects];
    
    // Tests the internal functionality used to set headers and footers for empty setting
    STAssertTrue([section objectForPage:RKPageSelectionFirst fromMap:textmap] == nil, @"Header set for first page");
    STAssertTrue([section objectForPage:RKPageSelectionLeft fromMap:textmap] == nil, @"Header set for left page");
    STAssertTrue([section objectForPage:RKPageSelectionRight fromMap:textmap] == nil, @"Header set for right page");
}

- (void)testFrameTextInvalidSelection
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable mapTableWithStrongToStrongObjects];

    // Tests the internal functionality used to set headers and footers for invalid page selection
    [section setObject:someText forPages:RKPageSelectorAll toMap:textmap];
    
    STAssertThrows([section objectForPage:(RKPageSelectionFirst|RKPageSelectionLeft) fromMap:textmap], @"Expecting assertion failure");
}

- (void)testSetHeader
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];

    // Tests the externally visible interface of RKSection to set headers
    [section setHeader:someHeader forPages:RKPageSelectorAll];
    
    STAssertEquals([section headerForPage:RKPageSelectionFirst], someHeader, @"Header not set");
    STAssertTrue([section footerForPage:RKPageSelectionFirst] == nil, @"Footer must not be set");
}

- (void)testSetFooter
{
    RKSection *section = [RKSection new];
    NSAttributedString *someFooter = [[NSAttributedString alloc] initWithString:@"Some Footer"];

    // Tests the externally visible interface of RKSection to set footers
    [section setFooter:someFooter forPages:RKPageSelectorAll];

    STAssertTrue([section headerForPage:RKPageSelectionFirst] == nil, @"Header must not be set");
    STAssertEquals([section footerForPage:RKPageSelectionFirst], someFooter, @"Footer not set");
}

@end
