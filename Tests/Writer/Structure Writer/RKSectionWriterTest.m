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

- (void)testGeneratingSectionSettings
{
    RKSection *section = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@""]];

    // Settings used in all tests
    section.numberOfColumns = 2;
    section.indexOfFirstPage = 3;
    
    // Decimal page numbering
    section.pageNumberingStyle = RKPageNumberingDecimal;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\titlepg\\cols2\\pgnstarts3\\pgndec", @"Invalid translation");

    // Roman lower case
    section.pageNumberingStyle = RKPageNumberingRomanLowerCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\titlepg\\cols2\\pgnstarts3\\pgnlcrm", @"Invalid translation");

    // Roman upper case
    section.pageNumberingStyle = RKPageNumberingRomanUpperCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\titlepg\\cols2\\pgnstarts3\\pgnucrm", @"Invalid translation");

    // Letter upper case
    section.pageNumberingStyle = RKPageNumberingAlphabeticUpperCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\titlepg\\cols2\\pgnstarts3\\pgnultr", @"Invalid translation");

    // Letter lower case
    section.pageNumberingStyle = RKPageNumberingAlphabeticLowerCase;
    STAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section], @"\\titlepg\\cols2\\pgnstarts3\\pgnlltr", @"Invalid translation");
}

- (void)testGeneratingHeadersForSomePages
{
    RKSection *section = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"abc"]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionLeft];
    
    STAssertEqualObjects([RKSectionWriter headersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\headerl \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid header generated"
                         );

    [section setHeader:nil forPages:RKPageSelectionLeft];
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionRight];
    
    STAssertEqualObjects([RKSectionWriter headersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\headerr \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid header generated"
                         );

    [section setHeader:nil forPages:RKPageSelectionRight];
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionFirst];
    
    STAssertEqualObjects([RKSectionWriter headersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\headerf \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid header generated"
                         );    
}

- (void)testGeneratingFootersForSomePages
{
    RKSection *section = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"abc"]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionLeft];
    
    STAssertEqualObjects([RKSectionWriter footersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\footerl \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid footer generated"
                         );
    
    [section setFooter:nil forPages:RKPageSelectionLeft];
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionRight];
    
    STAssertEqualObjects([RKSectionWriter footersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\footerr \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid footer generated"
                         );
    
    [section setFooter:nil forPages:RKPageSelectionRight];
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionFirst];
    
    STAssertEqualObjects([RKSectionWriter footersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\footerf \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid footer generated"
                         );    
}

- (void)testSectionsAreCompatibleToManualReferenceTest
{
    // Two Sections with different contents
    RKSection *sectionA = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"First Section"]];
    RKSection *sectionB = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"Second Section"]];
   
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:sectionA, sectionB, nil]];
    NSData *converted = [document RTF];
    
    [self assertRTF: converted withTestDocument: @"section"];
}

- (void)testMulticolumnSectionsAreCompatibleToManualReferenceTest
{
    // Two Sections with different contents
    RKSection *sectionA = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"First Section"]];
    RKSection *sectionB = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"Second Section"]];
    
    sectionA.numberOfColumns = 2;
        
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:sectionA, sectionB, nil]];
    NSData *converted = [document RTF];
    
    [self assertRTF: converted withTestDocument: @"multicolumn"];
}

- (void)testHeadersAndFootersAreCompatibleToManualReferenceTest
{
    // Two Sections with different contents
    RKSection *sectionAll = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"First Page\fLeft Page\fRight Page\fLeft Page 2"]];
    RKSection *sectionSwitch = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"First Page\fLeft Page\fRight Page\fLeft Page 2"]];
    
    [sectionAll setHeader:[[NSAttributedString alloc] initWithString:@"Header for all pages"] forPages:RKPageSelectorAll];
    [sectionAll setFooter:[[NSAttributedString alloc] initWithString:@"Footer for all pages"] forPages:RKPageSelectorAll];

    [sectionSwitch setHeader:[[NSAttributedString alloc] initWithString:@"Header for first pages"] forPages:RKPageSelectionFirst];
    [sectionSwitch setFooter:[[NSAttributedString alloc] initWithString:@"Footer for first pages"] forPages:RKPageSelectionFirst];
    
    [sectionSwitch setHeader:[[NSAttributedString alloc] initWithString:@"Header for left pages"] forPages:RKPageSelectionLeft];
    [sectionSwitch setFooter:[[NSAttributedString alloc] initWithString:@"Footer for left pages"] forPages:RKPageSelectionLeft];

    [sectionSwitch setHeader:[[NSAttributedString alloc] initWithString:@"Header for right pages"] forPages:RKPageSelectionRight];
    [sectionSwitch setFooter:[[NSAttributedString alloc] initWithString:@"Footer for right pages"] forPages:RKPageSelectionRight];
    
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:sectionAll, sectionSwitch, nil]];
    NSData *converted = [document RTF];
    
    [self assertRTF: converted withTestDocument: @"headersAndFooters"];
}

@end
