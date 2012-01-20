//
//  RKSectionTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 20.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKSectionTest.h"
#import "RKSection.h"
#import "RKSectionInternal.h"

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

- (void)testFrameTextForAllPages
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    [section setFrametext:someText forPages:RKPageMaskAllPages toTextMap:textmap];
    
    STAssertEquals([section frametextForPage:RKPageMaskFirstPage fromTextMap:textmap], someText, @"Header not set for first page");
    STAssertEquals([section frametextForPage:RKPageMaskLeftPage fromTextMap:textmap], someText, @"Header not set for left page");
    STAssertEquals([section frametextForPage:RKPageMaskRightPage fromTextMap:textmap], someText, @"Header not set for right page");
}

- (void)testFrameTextForFirstPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    [section setFrametext:someText forPages:RKPageMaskFirstPage toTextMap:textmap];
    
    STAssertEquals([section frametextForPage:RKPageMaskFirstPage fromTextMap:textmap], someText, @"Header not set for first page");
    STAssertTrue([section frametextForPage:RKPageMaskLeftPage fromTextMap:textmap] == nil, @"Header wrongly set for left page");
    STAssertTrue([section frametextForPage:RKPageMaskRightPage fromTextMap:textmap] == nil, @"Header wrongly set for right page");
}

- (void)testFrameTextForLeftPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    [section setFrametext:someText forPages:RKPageMaskLeftPage toTextMap:textmap];
    
    STAssertEquals([section frametextForPage:RKPageMaskLeftPage fromTextMap:textmap], someText, @"Header not set for left page");
    STAssertTrue([section frametextForPage:RKPageMaskFirstPage fromTextMap:textmap] == nil, @"Header wrongly set for first page");
    STAssertTrue([section frametextForPage:RKPageMaskRightPage fromTextMap:textmap] == nil, @"Header wrongly set for right page");
}

- (void)testFrameTextForRightPage
{
    RKSection *section = [RKSection new];
    NSAttributedString *someText = [[NSAttributedString alloc] initWithString:@"Some Text"];
    NSMapTable *textmap = [NSMapTable new];
    
    [section setFrametext:someText forPages:RKPageMaskRightPage toTextMap:textmap];
    
    STAssertEquals([section frametextForPage:RKPageMaskRightPage fromTextMap:textmap], someText, @"Header not set for right page");
    STAssertTrue([section frametextForPage:RKPageMaskFirstPage fromTextMap:textmap] == nil, @"Header wrongly set for first page");
    STAssertTrue([section frametextForPage:RKPageMaskLeftPage fromTextMap:textmap] == nil, @"Header wrongly set for legt page");
}

- (void)testSetHeader
{
    RKSection *section = [RKSection new];
    NSAttributedString *someHeader = [[NSAttributedString alloc] initWithString:@"Some Header"];
    
    [section setHeader:someHeader forPages:RKPageMaskAllPages];
    
    STAssertEquals([section headerForPage:RKPageMaskFirstPage], someHeader, @"Header not set");
    STAssertTrue([section footerForPage:RKPageMaskFirstPage] == nil, @"Footer must not be set");
}

- (void)testSetFooter
{
    RKSection *section = [RKSection new];
    NSAttributedString *someFooter = [[NSAttributedString alloc] initWithString:@"Some Footer"];
    
    [section setFooter:someFooter forPages:RKPageMaskAllPages];

    STAssertTrue([section headerForPage:RKPageMaskFirstPage] == nil, @"Header must not be set");
    STAssertEquals([section footerForPage:RKPageMaskFirstPage], someFooter, @"Footer not set");
}

@end
