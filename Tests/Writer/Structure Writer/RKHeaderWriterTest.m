//
//  RKHeaderWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriterTest.h"
#import "RKBodyWriter.h"
#import "RKHeaderWriter.h"
#import "RKHeaderWriter+TestExtensions.h"
#import "RKConversion.h"
#import "RKParagraphStyle.h"

@implementation RKHeaderWriterTest

- (NSDictionary *)generateCharacterStyle
{
    id font = [self.class targetSpecificFontWithName:@"Helvetica-BoldOblique" size:16];
    NSNumber *strikethroughStyle = [NSNumber numberWithUnsignedInteger:RKUnderlineStyleSingle];
    NSNumber *strokeWidth = [NSNumber numberWithUnsignedInteger:12];
    NSNumber *superscriptMode = [NSNumber numberWithUnsignedInteger:1];
    NSNumber *underlineStyle = [NSNumber numberWithUnsignedInt:RKUnderlineStyleDouble];
    id backgroundColor = [self.class targetSpecificColorWithRed:1.0 green:0.0 blue:0.0];
    id foregroundColor = [self.class targetSpecificColorWithRed:0.0 green:1.0 blue:0.0];    
    id underlineColor = [self.class targetSpecificColorWithRed:1.0 green:0.0 blue:1.0];
    id strikethroughColor = [self.class targetSpecificColorWithRed:0.0 green:1.0 blue:1.0];    
    id strokeColor = [self.class targetSpecificColorWithRed:0.1 green:0.2 blue:1.0];

#if !TARGET_OS_IPHONE
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [NSColor rtfColorWithRed:1.0 green:1.0 blue:0.0];
#else
    RKShadow *shadow = [RKShadow new];
    shadow.shadowColor = [self.class cgRGBColorWithRed:1.0 green:1.0 blue:0.0];
#endif    
    shadow.shadowBlurRadius = 2.0f;

    return [NSDictionary dictionaryWithObjectsAndKeys: 
            font,                  RKFontAttributeName,
            strikethroughStyle,    RKStrikethroughStyleAttributeName,
            strokeWidth,           RKStrokeWidthAttributeName,
            superscriptMode,       RKSuperscriptAttributeName,
            underlineStyle,        RKUnderlineStyleAttributeName,
            backgroundColor,       RKBackgroundColorAttributeName,
            foregroundColor,       RKForegroundColorAttributeName,
            underlineColor,        RKUnderlineColorAttributeName,
            strikethroughColor,    RKStrikethroughColorAttributeName,
            strokeColor,           RKStrokeColorAttributeName,
            shadow,                RKShadowAttributeName,
            nil 
            ];
}

- (NSDictionary *)generateParagraphStyle
{
    RKParagraphStyle *paragraphStyle = [RKParagraphStyle new];    
    
    paragraphStyle.alignment = RKCenterTextAlignment;
    paragraphStyle.firstLineHeadIndent = .0f;
    paragraphStyle.headIndent = .0f;
    paragraphStyle.tailIndent = .0f;
    
    paragraphStyle.lineHeightMultiple = .0f;
    paragraphStyle.lineSpacing = .0f;
    paragraphStyle.maximumLineHeight = .0f;
    paragraphStyle.minimumLineHeight = .0f;
    
    paragraphStyle.paragraphSpacingBefore = .0f;
    paragraphStyle.paragraphSpacing = .0f;
    
    paragraphStyle.tabStops = [NSArray new];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary: [self generateCharacterStyle]];
    
    [dictionary setObject:[paragraphStyle targetSpecificRepresentation] forKey:RKParagraphStyleAttributeName];
    
    return dictionary;
}

- (NSDate *)customDateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day hour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second
{
    NSDateComponents *customComponents = [NSDateComponents new];
    
    [customComponents setYear:year];
    [customComponents setMonth:month];
    [customComponents setDay:day];
    [customComponents setHour:hour];
    [customComponents setMinute:minute];
    [customComponents setSecond:second];
    
    return [[NSCalendar currentCalendar] dateFromComponents:customComponents];
}

- (void)testGeneratingFontTable
{
    RKResourcePool *resources = [RKResourcePool new];
    
    // Register some fonts
    [resources indexOfFont: (__bridge CTFontRef)[self.class targetSpecificFontWithName:@"GillSans" size:8]];
    [resources indexOfFont: (__bridge CTFontRef)[self.class targetSpecificFontWithName:@"Helvetica-Oblique" size:8]];
    [resources indexOfFont: (__bridge CTFontRef)[self.class targetSpecificFontWithName:@"GillSans-Light" size:8]];
    [resources indexOfFont: (__bridge CTFontRef)[self.class targetSpecificFontWithName:@"Courier" size:8]];    
    
    // Generate the header
    XCTAssertEqualObjects([RKHeaderWriter fontTableFromResourceManager:resources], 
                         @"{\\fonttbl"
                          "\\f0\\fnil\\fcharset0 GillSans;"
                          "\\f1\\fnil\\fcharset0 Helvetica;"
                          "\\f2\\fnil\\fcharset0 GillSans-Light;"
                          "\\f3\\fnil\\fcharset0 Courier;"
                          "}",
                         @"Invalid font table generated"
                         );
}

- (void)testGeneratingColorTable
{
    RKResourcePool *resources = [RKResourcePool new];
    
    // Register some fonts
    [resources indexOfColor: [self.class cgRGBColorWithRed:0 green:1 blue:0.5]];
    [resources indexOfColor: [self.class cgRGBColorWithRed:0.1 green:0.2 blue:0.3]];
    [resources indexOfColor: [self.class cgRGBColorWithRed:0.3 green:0.5 blue:0.1]];
    
    // Generate the header
    XCTAssertEqualObjects([RKHeaderWriter colorTableFromResourceManager:resources], 
                         @"{\\colortbl;"
                         "\\red255\\green255\\blue255;"
                         "\\red0\\green255\\blue127;"
                         "\\red25\\green51\\blue76;"
                         "\\red76\\green127\\blue25;"                         
                         "}",
                         @"Invalid color table generated"
                         );
}

- (void)testGeneratingDocumentInfo
{
    RKDocument *document = [RKDocument new];
    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Title {} \\ ",    RKTitleDocumentAttribute,
                                 @"Company",         RKCompanyDocumentAttribute,
                                 @"Copyright",       RKCopyrightDocumentAttribute,
                                 @"Subject",         RKSubjectDocumentAttribute,
                                 @"Author",          RKAuthorDocumentAttribute,
                                 [NSArray arrayWithObjects: @"Keyword 1", @"Keyword 2", nil],       RKKeywordsDocumentAttribute,
                                 @"Comment",         RKCommentDocumentAttribute,
                                 @"Editor",          RKEditorDocumentAttribute,
                                 [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6],  RKCreationTimeDocumentAttribute,
                                 [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1],  RKModificationTimeDocumentAttribute,
                                 @"Manager",         RKManagerDocumentAttribute,
                                 @"Category",        RKCategoryDocumentAttribute,
                                 nil
                                ];

    [document setMetadata: metaData];
    
    XCTAssertEqualObjects([RKHeaderWriter documentMetaDataFromDocument:document],
                          @"{\\info"
                                "{\\title Title \\{\\} \\\\ }"
                                "{\\*\\company Company}"
                                "{\\*\\copyright Copyright}"
                                "{\\subject Subject}"
                                "{\\author Author}"
                                "{\\keywords Keyword 1, Keyword 2}"
                                "{\\doccomm Comment}"
                                "{\\*\\editor Editor}"
                                "{\\creatim \\yr2001 \\mo2 \\dy3 \\hr4 \\min5 \\sec6}"
                                "{\\revtim \\yr2006 \\mo5 \\dy4 \\hr3 \\min2 \\sec1}"
                                "{\\manager Manager}"
                                "{\\category Category}"
                            "}",
                          @"Invalid document meta data"
                         );
}

- (void)testGeneratingDocumentFormattingData
{
    RKDocument *document = [RKDocument new];
    RKPageInsets insets = {.top = 100.0, .inner = 200.0, .outer = 300.0, .bottom = 400.0};

    // Test setting: Hyphenation, Footnotes on same page, Endnotes on section end, Overriding default size / margins, portrait format, left-binding, non-double sided
    [document setHyphenationEnabled:YES];
    [document setFootnotePlacement:RKFootnotePlacementSamePage];
    [document setEndnotePlacement:RKEndnotePlacementSectionEnd];
    [document setPageSize:CGSizeMake(100.0, 200.0)];
    [document setPageInsets:insets];
    [document setPageOrientation:RKPageOrientationPortrait];
    
    [document setFootnoteEnumerationStyle:RKFootnoteEnumerationRomanLowerCase];
    [document setEndnoteEnumerationStyle:RKFootnoteEnumerationAlphabeticLowerCase];
    
    [document setFootnoteEnumerationPolicy:RKFootnoteEnumerationPerSection];
    [document setEndnoteEnumerationPolicy: RKFootnoteContinuousEnumeration];

	[document setTwoSided: NO];
	[document setPageBinding: RKPageBindingLeft];
	
    XCTAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet2"
                          "\\ftnbj\\aftnbj\\aendnotes"
                          "\\ftnrestart\\aftnrstcont"
                          "\\paperw2000"
                          "\\paperh4000"
                          "\\margt2000"
                          "\\margl4000"
                          "\\margr6000"
                          "\\margb8000"
                          "\\hyphauto1"
                          "\\uc0 ",
                          @"Document formatting options not correctly translated"
                         );

	// Test setting: right-binding, non-double sided
	[document setTwoSided: NO];
	[document setPageBinding: RKPageBindingRight];
    XCTAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet2"
						 "\\ftnbj\\aftnbj\\aendnotes"
						 "\\ftnrestart\\aftnrstcont"
						 "\\rtlgutter"
						 "\\paperw2000"
						 "\\paperh4000"
						 "\\margt2000"
						 "\\margl6000"
						 "\\margr4000"
						 "\\margb8000"
						 "\\hyphauto1"
						 "\\uc0 ",
						 @"Document formatting options not correctly translated"
                         );
	
	// Test setting: left-binding, double sided
	[document setTwoSided: YES];
	[document setPageBinding: RKPageBindingLeft];
    XCTAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet2"
						 "\\ftnbj\\aftnbj\\aendnotes"
						 "\\ftnrestart\\aftnrstcont"
						 "\\facingp\\margmirror"
						 "\\paperw2000"
						 "\\paperh4000"
						 "\\margt2000"
						 "\\margl4000"
						 "\\margr6000"
						 "\\margb8000"
						 "\\hyphauto1"
						 "\\uc0 ",
						 @"Document formatting options not correctly translated"
                         );

	// Test setting: right-binding, double sided
	[document setTwoSided: YES];
	[document setPageBinding: RKPageBindingRight];
    XCTAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet2"
						 "\\ftnbj\\aftnbj\\aendnotes"
						 "\\ftnrestart\\aftnrstcont"
						 "\\rtlgutter\\facingp\\margmirror"
						 "\\paperw2000"
						 "\\paperh4000"
						 "\\margt2000"
						 "\\margl6000"
						 "\\margr4000"
						 "\\margb8000"
						 "\\hyphauto1"
						 "\\uc0 ",
						 @"Document formatting options not correctly translated"
                         );
	
    // Test setting: No Hyphenation, Document endnotes, landscape format, left binding, no-double-sided
	[document setTwoSided: NO];
	[document setPageBinding: RKPageBindingLeft];
	
    [document setHyphenationEnabled:NO];
    [document setFootnotePlacement:RKFootnotePlacementDocumentEnd];
    [document setEndnotePlacement:RKEndnotePlacementDocumentEnd];
    [document setPageOrientation:RKPageOrientationLandscape];
    
    XCTAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet1\\enddoc"
						 "\\ftnbj\\aftnbj\\aenddoc"
						 "\\ftnrestart\\aftnrstcont"
                         "\\landscape"
                         "\\paperw2000"
                         "\\paperh4000"
                         "\\margt2000"
                         "\\margl4000"
                         "\\margr6000"
                         "\\margb8000"
                         "\\uc0 ",
                         @"Document formatting options not correctly translated"
                         );    
    
    // Test setting: No Hyphenation, Section endnotes, landscape format    
    [document setHyphenationEnabled:NO];
    [document setFootnotePlacement:RKFootnotePlacementSectionEnd];
    [document setPageOrientation:RKPageOrientationLandscape];
    
    XCTAssertEqualObjects([RKHeaderWriter documentFormatFromDocument:document],
                         @"\\fet1\\endnotes"
						 "\\ftnbj\\aftnbj\\aenddoc"
						 "\\ftnrestart\\aftnrstcont"
                         "\\landscape"
                         "\\paperw2000"
                         "\\paperh4000"
                         "\\margt2000"
                         "\\margl4000"
                         "\\margr6000"
                         "\\margb8000"
                         "\\uc0 ",
                         @"Document formatting options not correctly translated"
                         );  
}

- (void)testGenerateListTable
{
    NSArray *overrides = [NSArray arrayWithObjects:
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 3],                         
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],
                          [NSNumber numberWithUnsignedInteger: 1],                         
                          [NSNumber numberWithUnsignedInteger: 1],
                          nil
                         ];
    RKListStyle *firstList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d.", @"%*%a.", @"%r.", nil] styles:nil];
    RKListStyle *secondList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"---------%d", @"-", nil] styles:nil startNumbers:overrides];

    // Register lists to a resource pool
    RKResourcePool *resources = [RKResourcePool new];
                                  
    [resources.listCounter indexOfListStyle: firstList];
    [resources.listCounter indexOfListStyle: secondList];
    
    // Generate header
    NSString *listTable = [RKHeaderWriter listTableFromResourceManager:resources];
    
    NSString *expectedListTable = 
        @"{\\*\\listtable "
            "{\\list"
                "\\listtemplateid1"
                "\\listhybrid"
                "{\\listlevel"
                    // levelcf0 (decimal)
                    "\\levelstartat1\\levelnfc0\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker \\{decimal\\}.}"
                    "{\\leveltext\\leveltemplateid10 \\'04\t\\'00.\t;}"
                    "{\\levelnumbers \\'02;}"
					"\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 "
                    "\\levelfollow0\\levellegal0\\levelnorestart0"
                "}"
                "{\\listlevel"
                    // levelcf4 (lower case letter)
                    "\\levelstartat1\\levelnfc4\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker \\{lower-alpha\\}.}"
                    "\\levelprepend"
                    "{\\leveltext\\leveltemplateid11 \\'06\t\\'00.\\'01.\t;}"
                    "{\\levelnumbers \\'02\\'04;}"
					"\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 "
                    "\\levelfollow0\\levellegal0\\levelnorestart0"
                "}"                         
                "{\\listlevel"
                    // Different starting number; levelcf2 (lower case roman)
                    "\\levelstartat1\\levelnfc2\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker \\{lower-roman\\}.}" 
                    "{\\leveltext\\leveltemplateid12 \\'04\t\\'02.\t;}"
                    "{\\levelnumbers \\'02;}"
					"\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 "
                    "\\levelfollow0\\levellegal0\\levelnorestart0"
                "}"                         
                "\\listid1"
                "{\\listname list1}"
            "}"
            "{\\list"
                "\\listtemplateid2"
                "\\listhybrid"
                "{\\listlevel"
                    // levelcf0 (decimal)
                    "\\levelstartat1\\levelnfc0\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker ---------\\{decimal\\}}"
                    "{\\leveltext\\leveltemplateid20 \\'0c\t---------\\'00\t;}"
                    "{\\levelnumbers \\'0b;}"
					"\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 "
                    "\\levelfollow0\\levellegal0\\levelnorestart0"
                "}"
                "{\\listlevel"
                    // levelcf23 (bullet)
                    "\\levelstartat3\\levelnfc23\\leveljc0\\levelold0\\levelprev0\\levelprevspace0\\levelindent0\\levelspace0"
                    "{\\*\\levelmarker -}"
                    "{\\leveltext\\leveltemplateid21 \\'03\t-\t;}"
                    "{\\levelnumbers ;}"
					"\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 "	
                    "\\levelfollow0\\levellegal0\\levelnorestart0"
                "}"                         
                "\\listid2"
                "{\\listname list2}"
            "}"
        "}\n";
    
    XCTAssertEqualObjects(listTable, expectedListTable, @"Invalid list table generated");
}

- (void)testGenerateListOverrideTable
{
    RKListStyle *firstList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d0.", @"%a1.", @"%r2.", nil] styles:nil];
    RKListStyle *secondList = [RKListStyle listStyleWithLevelFormats:[NSArray arrayWithObjects:@"%d0.%r1.%a2.%R3.%A4.", @"-", nil] styles:nil];
    
    // Register lists to a resource pool
    RKResourcePool *resources = [RKResourcePool new];
    
    [resources.listCounter indexOfListStyle: firstList];
    [resources.listCounter indexOfListStyle: secondList];
    
    // Generate header
    NSString *listTable = [RKHeaderWriter listOverrideTableFromResourceManager:resources];

    NSString *expectedListTable = 
        @"{\\*\\listoverridetable"
           "{\\listoverride\\listid1\\listoverridecount0\\ls1}"
           "{\\listoverride\\listid2\\listoverridecount0\\ls2}"  
         "}\n";
    
    XCTAssertEqualObjects(listTable, expectedListTable, @"Invalid llist override table generated");
}

- (void)testGeneratingStylesheetTable
{
    RKDocument *document = [RKDocument new];
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument:document];    
    
    document.paragraphStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];

    document.characterStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle ÄÖ",
                                nil
                                ];
    
    NSString *expectedStyleSheet = 
        @"{\\stylesheet "
            "{\\s1 "
            "\\qc\\pardeftab0 "
            "\\cb2 "
            "\\cf3 "
            "\\strikec4 "
            "\\strokec5 "
            "\\ulc6 "
            "\\f0 \\fs32\\fsmilli16000 \\b \\i "
            "\\shad\\shadx0\\shady0\\shadr40\\shadc7 "
            "\\strike\\strikestyle1 "
            "\\outl\\strokewidth240 "
            "\\super "
            "\\uldb\\ulstyle9 "
            "\\sqformat\\sbasedon0 "
            "PStyle;"
            "}"
          "{\\cs2"
            "\\additive "
            "\\cb2 "
            "\\cf3 "
            "\\strikec4 "
            "\\strokec5 "
            "\\ulc6 "
            "\\f0 \\fs32\\fsmilli16000 \\b \\i "
            "\\shad\\shadx0\\shady0\\shadr40\\shadc7 "
            "\\strike\\strikestyle1 "
            "\\outl\\strokewidth240 "
            "\\super "
            "\\uldb\\ulstyle9 "
            "\\sqformat\\sbasedon0 "
            "CStyle \\u196 \\u214 ;"
            "}"    
        "}";
    
    NSString *stylesheets = [RKHeaderWriter styleSheetsFromResourceManager: resources];
    
    XCTAssertEqualObjects(stylesheets, expectedStyleSheet, @"Invalid style sheet table generated");
    
    return;   
}

+ (NSAttributedString *)dummyStringWithNotice:(NSString *)dummyString
{
	NSString *fillString = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
	
	return [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%@\n%@\n\fNext page\n%@\n\fNext page\n%@\n", dummyString, fillString, fillString, fillString]];
}

- (void)testSingleSidedLeftBindingManualTest
{
	RKSection *section = [[RKSection alloc] initWithContent: [self.class dummyStringWithNotice: @"Left Binding. Not double Sided."]];
	
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:section, nil]];
	document.pageBinding = RKPageBindingLeft;
	document.pageInsets = RKPageInsetsMake(10, 200, 100, 10);
	document.twoSided = NO;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"single-sided-left"];
}

- (void)testSingleSidedRightBindingManualTest
{
	RKSection *section = [[RKSection alloc] initWithContent: [self.class dummyStringWithNotice: @"Right Binding. Not double Sided."]];
	
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:section, nil]];
	document.pageBinding = RKPageBindingRight;
	document.pageInsets = RKPageInsetsMake(10, 200, 100, 10);
	document.twoSided = NO;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"single-sided-right"];
}

- (void)testTwoSidedLeftBindingManualTest
{
	RKSection *section = [[RKSection alloc] initWithContent: [self.class dummyStringWithNotice: @"Left Binding. Double Sided."]];
	
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:section, nil]];
	document.pageBinding = RKPageBindingLeft;
	document.pageInsets = RKPageInsetsMake(10, 200, 100, 10);
	document.twoSided = YES;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"double-sided-left"];
}

- (void)testTwoSidedRightBindingManualTest
{
	RKSection *section = [[RKSection alloc] initWithContent: [self.class dummyStringWithNotice: @"Right Binding. Double Sided."]];
	
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:section, nil]];
	document.pageBinding = RKPageBindingRight;
	document.pageInsets = RKPageInsetsMake(10, 200, 100, 10);
	document.twoSided = YES;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"double-sided-right"];
}


#if !TARGET_OS_IPHONE

- (void)testRereadingPageSettingsWithCocoa
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@"abc"]];
    
    document.pageSize = NSMakeSize(300, 400);
    document.pageInsets = RKPageInsetsMake(10, 20, 30, 40);
    document.hyphenationEnabled = YES;
    
    NSDictionary *rereadDocumentProperties;
    
    NSData *rtf = [document wordRTF];
    NSAttributedString *rereadString = [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:&rereadDocumentProperties];
    
    XCTAssertEqualObjects([rereadString string], @"abc", @"Invalid content");
    
    ULAssertEqualSize([[rereadDocumentProperties objectForKey:NSPaperSizeDocumentAttribute] sizeValue], document.pageSize, @"Invalid paper size");
    XCTAssertEqual([[rereadDocumentProperties objectForKey:NSLeftMarginDocumentAttribute] floatValue], (float)document.pageInsets.inner, @"Invalid margin");
    XCTAssertEqual([[rereadDocumentProperties objectForKey:NSRightMarginDocumentAttribute] floatValue], (float)document.pageInsets.outer, @"Invalid margin");
    XCTAssertEqual([[rereadDocumentProperties objectForKey:NSTopMarginDocumentAttribute] floatValue], (float)document.pageInsets.top, @"Invalid margin");
    XCTAssertEqual([[rereadDocumentProperties objectForKey:NSBottomMarginDocumentAttribute] floatValue], (float)document.pageInsets.bottom, @"Invalid margin");    
    XCTAssertEqual([[rereadDocumentProperties objectForKey:NSHyphenationFactorDocumentAttribute] floatValue], 0.9f, @"Invalid hyphenation setting");    
}

- (void)testRereadingMetaDataSettingsWithCocoa
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@"abc"]];
    NSDictionary *metaData = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Title",          NSTitleDocumentAttribute,
                              @"Company",        NSCompanyDocumentAttribute,
                              @"Copyright",      NSCopyrightDocumentAttribute,
                              @"Subject",        NSSubjectDocumentAttribute,
                              @"Author",         NSAuthorDocumentAttribute,
                              [NSArray arrayWithObjects: @"Keyword 1", @"Keyword 2", nil],       NSKeywordsDocumentAttribute,
                              @"Comment",        NSCommentDocumentAttribute,
                              [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6],  NSCreationTimeDocumentAttribute,
                              [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1],  NSModificationTimeDocumentAttribute,
                              @"Manager",        NSManagerDocumentAttribute,
                              @"Category",       NSCategoryDocumentAttribute,
                              nil
                              ];
    
    [document setMetadata: metaData];
    
    NSDictionary *rereadDocumentProperties;
    
    NSData *rtf = [document wordRTF];
    NSAttributedString *rereadString = [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:&rereadDocumentProperties];
    
    XCTAssertEqualObjects([rereadString string], @"abc", @"Invalid content");
    
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSTitleDocumentAttribute], @"Title", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSCompanyDocumentAttribute], @"Company", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSCopyrightDocumentAttribute], @"Copyright", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSSubjectDocumentAttribute], @"Subject", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSAuthorDocumentAttribute], @"Author", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSKeywordsDocumentAttribute], ([NSArray arrayWithObjects: @"Keyword 1", @"Keyword 2", nil]), @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSCommentDocumentAttribute], @"Comment", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSManagerDocumentAttribute], @"Manager", @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSCreationTimeDocumentAttribute], 
                         [self customDateWithYear:2001 month:2 day:3 hour:4 minute:5 second:6], @"Invalid meta data");
    XCTAssertEqualObjects([rereadDocumentProperties objectForKey:NSModificationTimeDocumentAttribute], 
                         [self customDateWithYear:2006 month:5 day:4 hour:3 minute:2 second:1], @"Invalid meta data");
}

#endif

@end
