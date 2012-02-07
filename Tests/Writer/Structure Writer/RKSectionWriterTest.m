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

- (void)testGeneratingHeadersForAllPages
{
    RKSection *section = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"abc"]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectorAll];
    
    STAssertEqualObjects([RKSectionWriter headersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\header \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid header generated"
                        );
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

- (void)testGeneratingFooterForAllPages
{
    RKSection *section = [RKSection sectionWithContent:[[NSAttributedString alloc] initWithString:@"abc"]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectorAll];

    STAssertEqualObjects([RKSectionWriter footersForSection:section withAttachmentPolicy:0 resources:resources],
                         @"{\\footer \\pard\\ql\\pardeftab0 \\cb1 \\f0 \\fs24 \\cf0 Text\\par\n}",
                         @"Invalid footer generated"
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

@end
