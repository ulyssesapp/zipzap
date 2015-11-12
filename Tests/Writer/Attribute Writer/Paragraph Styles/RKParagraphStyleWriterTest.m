//
//  RKParagraphStyleWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKParagraphStyleWriterTest.h"
#import "RKParagraphStyleWriter.h"
#import "RKParagraphStyleWriter+TestExtensions.h"

@implementation RKParagraphStyleWriterTest

- (NSMutableParagraphStyle *)defaultParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKTextAlignmentNatural;
    
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
    
    paragraphStyle.defaultTabInterval = .0f;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    return paragraphStyle;
}

- (void)testTranslateDefaultParagraphStyle
{
    NSParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];
    
    // Test with default settings
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testTranslateAlignmentStyles
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
    
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKTextAlignmentNatural;
    
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
	
    [attributedString addAttribute:RKParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];
    
    // Test with default settings
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Left alignment
    paragraphStyle.alignment = RKTextAlignmentLeft;
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\ql\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Center alignment
    paragraphStyle.alignment = RKTextAlignmentCenter;
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\qc\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Right alignment
    paragraphStyle.alignment = RKTextAlignmentRight;
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\qr\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
    
    // Right alignment
    paragraphStyle.alignment = RKTextAlignmentJustified;
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\qj\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
}

- (void)testCalculatingLineHeight
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKTextAlignmentNatural;
    
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
	
    [attributedString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyle copy] range:NSMakeRange(0,3)];
    
    // Test with default settings
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:nil],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Line height multiple of default font
	paragraphStyle.lineHeightMultiple = 3.0f;
	
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:nil],
                         @"\\sl720\\slmult1\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 

    // Line height multiple of largest font
    paragraphStyle.lineHeightMultiple = 3.0f;
	
    [attributedString addAttribute:RKFontAttributeName value:[self.class targetSpecificFontWithName:@"Helvetica" size:20] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:RKFontAttributeName value:[self.class targetSpecificFontWithName:@"Helvetica" size:30] range:NSMakeRange(1, 1)];
    [attributedString addAttribute:RKFontAttributeName value:[self.class targetSpecificFontWithName:@"Helvetica" size:40] range:NSMakeRange(2, 1)];
    
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:nil],
                         @"\\sl2400\\slmult1\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testCalculatingTailIndent
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKTextAlignmentNatural;
    
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
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyle copy] range:NSMakeRange(0,3)];
    
    // This test requires a resource manager with a paper format, we use 1100 as page width and 50 as legt/right margins here
    RKDocument *document = [RKDocument new];
    document.pageSize = CGSizeMake(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);

    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: document];
    
    // Test with default settings
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Positive tail indent in left direction: must be inverted
    paragraphStyle.baseWritingDirection = kCTWritingDirectionLeftToRight;
    paragraphStyle.tailIndent = 3.0f;
	
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\ri19940\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 

    // Negative tail indent in right direction: absolute value
    paragraphStyle.tailIndent = -3.0f;
    paragraphStyle.baseWritingDirection = kCTWritingDirectionLeftToRight;
	
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\ri60\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Positive tail indent in left direction: must be inverted
    paragraphStyle.baseWritingDirection = kCTWritingDirectionRightToLeft;
    paragraphStyle.tailIndent = 3.0f;
	
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\rtlpar\\ri19940\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Negative tail indent in right direction: absolute value
    paragraphStyle.tailIndent = -3.0f;
    paragraphStyle.baseWritingDirection = kCTWritingDirectionRightToLeft;
	
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle mutableCopy] ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\rtlpar\\ri60\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );   
}

- (void)testTranslateNonDefaultParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
        
    paragraphStyle.alignment = RKTextAlignmentRight;
    
    paragraphStyle.firstLineHeadIndent = 1.0f;
    paragraphStyle.headIndent = 2.0f;
    paragraphStyle.tailIndent = -3.0f;
    
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineHeightMultiple = 5.0f;
    paragraphStyle.maximumLineHeight = 6.0f;
    paragraphStyle.minimumLineHeight = 7.0f;
    
    paragraphStyle.paragraphSpacingBefore = 8.0f;
    paragraphStyle.paragraphSpacing = 9.0f;
    
    paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    paragraphStyle.defaultTabInterval = 11.0f;
    
    paragraphStyle.tabStops = [NSArray arrayWithObjects: 
                               [[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:10.0f options:@{}],
                               [[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentCenter location:20.0f options:@{}],
                               [[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:30.0f options:@{}],
                               nil
                               ];
	
    [attributedString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyle copy] range:NSMakeRange(0,1)];
    
    // This test requires a resource manager with a paper format, we use 1100 as page width and 50 as legt/right margins here
    RKDocument *document = [RKDocument new];
    document.pageSize = CGSizeMake(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);
    
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: document];
    
    // Right aligned
    XCTAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle copy] ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:resources],
                         @"\\rtlpar"
                         "\\qr"
                         "\\fi-20"
                         "\\li40"
                         "\\ri60"
                         "\\sb160"
                         "\\sa180"
                         // RTF requires the ordering \\slN\\slmult1
                         "\\slleading80"
                         "\\sl1200\\slmult1"
                         "\\slmaximum120"
                         "\\slminimum140"
                         // Tabs
                         "\\pardeftab220"
                         "\\tx200"
                         "\\tqc\\tx400"
                         "\\tqr\\tx600"

						  // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testParagraphTagging
{
    NSMutableParagraphStyle *paragraphStyleA = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleB = [self defaultParagraphStyle];
    
    paragraphStyleA.alignment = RKTextAlignmentCenter;
    paragraphStyleB.alignment = RKTextAlignmentRight;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaa\nbbb"];
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:paragraphStyleA range:NSMakeRange(0,1)];
    [attributedString addAttribute:RKParagraphStyleAttributeName value:paragraphStyleB range:NSMakeRange(1,1)];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString: @"aaa\nbbb"];
    
    [RKParagraphStyleWriter addTagsForAttribute:RKParagraphStyleAttributeName 
                                          value:paragraphStyleA
                                 effectiveRange:NSMakeRange(0,3) 
                                       toString:taggedString 
                                 originalString:attributedString 
                               conversionPolicy:0 
                                      resources:nil
    ];

    [RKParagraphStyleWriter addTagsForAttribute:RKParagraphStyleAttributeName 
                                          value:paragraphStyleB
                                 effectiveRange:NSMakeRange(4,3)
                                       toString:taggedString 
                                 originalString:attributedString 
                               conversionPolicy:0 
                                      resources:nil
     ];

    XCTAssertEqualObjects([taggedString flattenedRTFString], 
                         @"\\pard \\qc\\pardeftab0 "
                          "aaa"
                          "\\par\n"
                          "\\pard \\qr\\pardeftab0 "
                          "bbb",
                         @"Invalid flattening"
                        );
}

#if !TARGET_OS_IPHONE

- (void)testCocoaIntegrationRTLParagraph
{
    NSMutableParagraphStyle *paragraphStyleDefault = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleNonDefault = [self defaultParagraphStyle];
    
    // The only default-value we have to override is "alignment", since the natural alignment will be processed by Cocoa
    paragraphStyleDefault.alignment = RKTextAlignmentLeft;
    
    paragraphStyleNonDefault.alignment = RKTextAlignmentRight;

    paragraphStyleNonDefault.firstLineHeadIndent = 2.0f;
    paragraphStyleNonDefault.headIndent = 3.0f;    

    paragraphStyleNonDefault.tailIndent = 4.0f;
   
    paragraphStyleNonDefault.lineSpacing = 4.0f;
    paragraphStyleNonDefault.lineHeightMultiple = 2.0f;
    paragraphStyleNonDefault.maximumLineHeight = 6.0f;
    paragraphStyleNonDefault.minimumLineHeight = 7.0f;
    
    paragraphStyleNonDefault.paragraphSpacingBefore = 8.0f;
    paragraphStyleNonDefault.paragraphSpacing = 9.0f;
    
    paragraphStyleNonDefault.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    paragraphStyleNonDefault.defaultTabInterval = 11.0f;
    
    paragraphStyleNonDefault.tabStops = [NSArray arrayWithObjects: 
                               [[NSTextTab alloc] initWithType:NSLeftTabStopType location:10.0f],
                               [[NSTextTab alloc] initWithType:NSCenterTabStopType location:20.0f],
                               [[NSTextTab alloc] initWithType:NSRightTabStopType location:30.0f],
                               nil
                               ];
 
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:@"A\nB\n"];
    
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleNonDefault copy] range:NSMakeRange(0, 2)];
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleDefault copy] range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:testString onAttribute:RKParagraphStyleAttributeName inRange:NSMakeRange(0, 3)];
}

- (void)testCocoaIntegrationLTRParagraph
{
    NSMutableParagraphStyle *paragraphStyleDefault = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleNonDefault = [self defaultParagraphStyle];
    
    // The only default-value we have to override is "alignment", since the natural alignment will be processed by Cocoa
    paragraphStyleDefault.alignment = RKTextAlignmentLeft;
    
    paragraphStyleNonDefault.alignment = RKTextAlignmentRight;
    
    paragraphStyleNonDefault.firstLineHeadIndent = 2.0f;
    paragraphStyleNonDefault.headIndent = 3.0f;    
    
    paragraphStyleNonDefault.tailIndent = 4.0f;
    
    paragraphStyleNonDefault.lineSpacing = 4.0f;
    paragraphStyleNonDefault.lineHeightMultiple = 2.0f;
    paragraphStyleNonDefault.maximumLineHeight = 6.0f;
    paragraphStyleNonDefault.minimumLineHeight = 7.0f;
    
    paragraphStyleNonDefault.paragraphSpacingBefore = 8.0f;
    paragraphStyleNonDefault.paragraphSpacing = 9.0f;
    
    paragraphStyleNonDefault.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    paragraphStyleNonDefault.defaultTabInterval = 11.0f;
    
    paragraphStyleNonDefault.tabStops = [NSArray arrayWithObjects: 
                                         [[NSTextTab alloc] initWithType:NSLeftTabStopType location:10.0f],
                                         [[NSTextTab alloc] initWithType:NSCenterTabStopType location:20.0f],
                                         [[NSTextTab alloc] initWithType:NSRightTabStopType location:30.0f],
                                         nil
                                         ];
    
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:@"A\nB\n"];
    
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleNonDefault copy] range:NSMakeRange(0, 2)];
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleDefault copy] range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:testString onAttribute:RKParagraphStyleAttributeName inRange:NSMakeRange(0, 3)];
}
#endif

@end
