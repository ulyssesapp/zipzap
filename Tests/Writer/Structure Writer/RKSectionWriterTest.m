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
	RKDocument *document = [RKDocument new];
	document.footnoteEnumerationStyle = RKFootnoteEnumerationAlphabeticLowerCase;
	document.footnoteEnumerationPolicy = RKFootnoteEnumerationPerSection;
	document.endnoteEnumerationStyle = RKFootnoteEnumerationRomanUpperCase;
	document.endnotePlacement = RKEndnotePlacementSectionEnd;
	
    RKSection *section = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@""]];

    // Settings used in all tests
    section.numberOfColumns = 2;
    section.indexOfFirstPage = 3;
    
    // Decimal page numbering
    section.pageNumberingStyle = RKPageNumberingDecimal;
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnNextPage], @"\\titlepg\\sbkpage\\cols2\\colsx720\\pgnstarts3\\pgnrestart\\pgndec\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");

    // Roman lower case
    section.pageNumberingStyle = RKPageNumberingRomanLowerCase;
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnNextPage], @"\\titlepg\\sbkpage\\cols2\\colsx720\\pgnstarts3\\pgnrestart\\pgnlcrm\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");

    // Roman upper case
    section.pageNumberingStyle = RKPageNumberingRomanUpperCase;
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnNextPage], @"\\titlepg\\sbkpage\\cols2\\colsx720\\pgnstarts3\\pgnrestart\\pgnucrm\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");

    // Letter upper case
    section.pageNumberingStyle = RKPageNumberingAlphabeticUpperCase;
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnNextPage], @"\\titlepg\\sbkpage\\cols2\\colsx720\\pgnstarts3\\pgnrestart\\pgnucltr\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");

    // Letter lower case
    section.indexOfFirstPage = RKContinuousPageNumbering;    
    section.pageNumberingStyle = RKPageNumberingAlphabeticLowerCase;
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnNextPage], @"\\titlepg\\sbkpage\\cols2\\colsx720\\pgnlcltr\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");


	// Diferent section starts
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnSamePage], @"\\titlepg\\sbknone\\cols2\\colsx720\\pgnlcltr\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnNextPage], @"\\titlepg\\sbkpage\\cols2\\colsx720\\pgnlcltr\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnEvenPage], @"\\titlepg\\sbkeven\\cols2\\colsx720\\pgnlcltr\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");
    XCTAssertEqualObjects([RKSectionWriter sectionAttributesForSection:section withConversionPolicy:0 usingDocument:document firstPagePosition:RKSectionStartsOnOddPage], @"\\titlepg\\sbkodd\\cols2\\colsx720\\pgnlcltr\\sftnbj\\saftnbj\\sftnnalc\\saftnnruc\\endnhere\\sftnrestart", @"Invalid translation");
}

- (void)testGeneratingHeadersForSomePages
{
    RKSection *section = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"abc"]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionLeft];
    
    XCTAssertEqualObjects([RKSectionWriter headersForSection:section withConversionPolicy:0 resources:resources],
                         @"{\\headerl \\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 Text\\par}\n",
                         @"Invalid header generated"
                         );

    [section setHeader:nil forPages:RKPageSelectionLeft];
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionRight];
    
    XCTAssertEqualObjects([RKSectionWriter headersForSection:section withConversionPolicy:0 resources:resources],
                         @"{\\headerr \\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 Text\\par}\n",
                         @"Invalid header generated"
                         );

    [section setHeader:nil forPages:RKPageSelectionRight];
    [section setHeader:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionFirst];
    
    XCTAssertEqualObjects([RKSectionWriter headersForSection:section withConversionPolicy:0 resources:resources],
                         @"{\\headerf \\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 Text\\par}\n",
                         @"Invalid header generated"
                         );    
}

- (void)testGeneratingFootersForSomePages
{
    RKSection *section = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"abc"]];
    RKResourcePool *resources = [RKResourcePool new];
    
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionLeft];
    
    XCTAssertEqualObjects([RKSectionWriter footersForSection:section withConversionPolicy:0 resources:resources],
                         @"{\\footerl \\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 Text\\par}\n",
                         @"Invalid footer generated"
                         );
    
    [section setFooter:nil forPages:RKPageSelectionLeft];
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionRight];
    
    XCTAssertEqualObjects([RKSectionWriter footersForSection:section withConversionPolicy:0 resources:resources],
                         @"{\\footerr \\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 Text\\par}\n",
                         @"Invalid footer generated"
                         );
    
    [section setFooter:nil forPages:RKPageSelectionRight];
    [section setFooter:[[NSAttributedString alloc] initWithString:@"Text"] forPages:RKPageSelectionFirst];
    
    XCTAssertEqualObjects([RKSectionWriter footersForSection:section withConversionPolicy:0 resources:resources],
                         @"{\\footerf \\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 Text\\par}\n",
                         @"Invalid footer generated"
                         );    
}

- (void)testSectionsAreCompatibleToManualReferenceTest
{
    // Two Sections with different contents
    RKSection *sectionA = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"First Section"]];
    RKSection *sectionB = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"Second Section"]];
   
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [[RKDocument alloc] initWithSections:[NSArray arrayWithObjects:sectionA, sectionB, nil]];
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"section"];
}

- (void)testMulticolumnSectionsAreCompatibleToManualReferenceTest
{
    // Two Sections with different contents
    RKSection *sectionA = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"First Section uses two columns.\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\nFirst Section\n"]];
    RKSection *sectionB = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"Second Section uses single column.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section.\nSecond Section."]];
    
    sectionA.numberOfColumns = 2;
        
    RKDocument *document = [[RKDocument alloc] initWithSections:[NSArray arrayWithObjects:sectionA, sectionB, nil]];
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"multicolumn"];
}

- (void)testHeadersAndFootersAreCompatibleToManualReferenceTest
{
    // Two Sections with different contents
    RKSection *sectionAll = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"First Page\fLeft Page\fRight Page\fLeft Page 2"]];
    RKSection *sectionSwitch = [[RKSection alloc] initWithContent:[[NSAttributedString alloc] initWithString:@"First Page\fLeft Page\fRight Page\fLeft Page 2"]];

    [sectionAll setHeader:[[NSAttributedString alloc] initWithString:@"Header for all pages"] forPages:RKPageSelectorAll];
    [sectionAll setFooter:[[NSAttributedString alloc] initWithString:@"Footer for all pages"] forPages:RKPageSelectorAll];
		
    [sectionSwitch setHeader:[[NSAttributedString alloc] initWithString:@"Header for first pages"] forPages:RKPageSelectionFirst];
    [sectionSwitch setFooter:[[NSAttributedString alloc] initWithString:@"Footer for first pages"] forPages:RKPageSelectionFirst];
    
    [sectionSwitch setHeader:[[NSAttributedString alloc] initWithString:@"Header for left pages"] forPages:RKPageSelectionLeft];
    [sectionSwitch setFooter:[[NSAttributedString alloc] initWithString:@"Footer for left pages"] forPages:RKPageSelectionLeft];

    [sectionSwitch setHeader:[[NSAttributedString alloc] initWithString:@"Header for right pages"] forPages:RKPageSelectionRight];
    [sectionSwitch setFooter:[[NSAttributedString alloc] initWithString:@"Footer for right pages"] forPages:RKPageSelectionRight];
    
    RKDocument *document = [[RKDocument alloc] initWithSections:[NSArray arrayWithObjects:sectionAll, sectionSwitch, nil]];
	document.pageBinding = RKPageBindingLeft;
	document.pageInsets = RKPageInsetsMake(100, 200, 100, 100);
	document.twoSided = YES;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"headersAndFooters"];
}

- (void)testPageNumberingIsCompatibleToManualReferenceTest
{
    // Sections with placeholder contents
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] 
                                           initWithString:[NSString stringWithFormat:
                                                           @"%C\f%C\f%C",
                                                           RKAttachmentCharacter,
                                                           RKAttachmentCharacter,
                                                           RKAttachmentCharacter
                                                           ]
                                           ];

    // Set placeholders
    [content addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderPageNumber] range:NSMakeRange(0, 1)];
    [content addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderPageNumber] range:NSMakeRange(2, 1)];
    [content addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderPageNumber] range:NSMakeRange(4, 1)];    
    
    // Two Sections with different contents
    RKSection *sectionDecimal = [[RKSection alloc] initWithContent:content];
    RKSection *sectionRomanLower = [[RKSection alloc] initWithContent:content];
    RKSection *sectionRomanUpper = [[RKSection alloc] initWithContent:content];
    RKSection *sectionAlphabeticLower = [[RKSection alloc] initWithContent:content];
    RKSection *sectionAlphabeticUpper = [[RKSection alloc] initWithContent:content];
    
    sectionDecimal.pageNumberingStyle = RKPageNumberingDecimal;
    sectionDecimal.indexOfFirstPage = 10;
    sectionRomanLower.pageNumberingStyle = RKPageNumberingRomanLowerCase;
    sectionRomanUpper.pageNumberingStyle = RKPageNumberingRomanUpperCase;
    sectionAlphabeticLower.pageNumberingStyle = RKPageNumberingAlphabeticLowerCase;
    sectionAlphabeticUpper.pageNumberingStyle = RKPageNumberingAlphabeticUpperCase;
    
    RKDocument *document = [[RKDocument alloc] initWithSections:[NSArray arrayWithObjects:sectionDecimal, sectionRomanLower, sectionRomanUpper, sectionAlphabeticLower, sectionAlphabeticUpper, nil]];
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"pagenumbering"];
}

@end
