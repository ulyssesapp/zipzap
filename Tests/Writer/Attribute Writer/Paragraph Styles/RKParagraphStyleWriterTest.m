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
#import "RKParagraphStyle.h"
#import "RKTextTab.h"

@implementation RKParagraphStyleWriterTest

- (RKParagraphStyle *)defaultParagraphStyle
{
    RKParagraphStyle *paragraphStyle = [RKParagraphStyle new];    
        
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKNaturalTextAlignment;
    
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
    paragraphStyle.baseWritingDirection = RKWritingDirectionLeftToRight;
    
    return paragraphStyle;
}

- (void)testTranslateDefaultParagraphStyle
{
    RKParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];

    [attributedString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyle targetSpecificRepresentation] range:NSMakeRange(0,1)];    
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:[paragraphStyle targetSpecificRepresentation] ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testTranslateAlignmentStyles
{
    RKParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
    
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKNaturalTextAlignment;
    
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
    
    id targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:targetSpecificParagraphStyle range:NSMakeRange(0,1)];
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Left alignment
    paragraphStyle.alignment = RKLeftTextAlignment;    
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\ql\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Center alignment
    paragraphStyle.alignment = RKCenterTextAlignment;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\qc\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Right alignment
    paragraphStyle.alignment = RKRightTextAlignment;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\qr\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
    
    // Right alignment
    paragraphStyle.alignment = RKJustifiedTextAlignment;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];    
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:nil],
                         @"\\qj\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
}

- (void)testCalculatingLineHeight
{
    RKParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKNaturalTextAlignment;
    
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
    
    id targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:targetSpecificParagraphStyle range:NSMakeRange(0,3)];
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:nil],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Line height multiple of default font
    paragraphStyle.lineHeightMultiple = 3.0f;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:nil],
                         @"\\sl720\\slmult1\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 

    // Line height multiple of largest font
    paragraphStyle.lineHeightMultiple = 3.0f;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];    
    
    [attributedString addAttribute:RKFontAttributeName value:[self.class targetSpecificFontWithName:@"Helvetica" size:20] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:RKFontAttributeName value:[self.class targetSpecificFontWithName:@"Helvetica" size:30] range:NSMakeRange(1, 1)];
    [attributedString addAttribute:RKFontAttributeName value:[self.class targetSpecificFontWithName:@"Helvetica" size:40] range:NSMakeRange(2, 1)];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:nil],
                         @"\\sl2400\\slmult1\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testCalculatingTailIndent
{
    RKParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    // Paragraph Style with defaults
    paragraphStyle.alignment = RKNaturalTextAlignment;
    
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
    
    id targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:targetSpecificParagraphStyle range:NSMakeRange(0,3)];
    
    // This test requires a resource manager with a paper format, we use 1100 as page width and 50 as legt/right margins here
    RKDocument *document = [RKDocument new];
    document.pageSize = CGSizeMake(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);

    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: document];
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Positive tail indent in left direction: must be inverted
    paragraphStyle.baseWritingDirection = kCTWritingDirectionLeftToRight;
    paragraphStyle.tailIndent = 3.0f;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\ri19940\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 

    // Negative tail indent in right direction: absolute value
    paragraphStyle.tailIndent = -3.0f;
    paragraphStyle.baseWritingDirection = kCTWritingDirectionLeftToRight;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\ri60\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Positive tail indent in left direction: must be inverted
    paragraphStyle.baseWritingDirection = kCTWritingDirectionRightToLeft;
    paragraphStyle.tailIndent = 3.0f;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\rtlpar\\ri19940\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Negative tail indent in right direction: absolute value
    paragraphStyle.tailIndent = -3.0f;
    paragraphStyle.baseWritingDirection = kCTWritingDirectionRightToLeft;
    targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 3) resources:resources],
                         @"\\rtlpar\\ri60\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );   
}

- (void)testTranslateNonDefaultParagraphStyle
{
    RKParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
        
    paragraphStyle.alignment = RKRightTextAlignment;
    
    paragraphStyle.firstLineHeadIndent = 1.0f;
    paragraphStyle.headIndent = 2.0f;
    paragraphStyle.tailIndent = -3.0f;
    
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineHeightMultiple = 5.0f;
    paragraphStyle.maximumLineHeight = 6.0f;
    paragraphStyle.minimumLineHeight = 7.0f;
    
    paragraphStyle.paragraphSpacingBefore = 8.0f;
    paragraphStyle.paragraphSpacing = 9.0f;
    
    paragraphStyle.baseWritingDirection = RKWritingDirectionRightToLeft;
    
    paragraphStyle.defaultTabInterval = 11.0f;
    
    paragraphStyle.tabStops = [NSArray arrayWithObjects: 
                               [[RKTextTab alloc] initWithTabStopType:RKLeftTabStopType location:10.0f],
                               [[RKTextTab alloc] initWithTabStopType:RKCenterTabStopType location:20.0f],
                               [[RKTextTab alloc] initWithTabStopType:RKRightTabStopType location:30.0f],
                               #if !TARGET_OS_IPHONE
                                [[RKTextTab alloc] initWithTabStopType:RKDecimalTabStopType location:40.0f],
                               #endif
                               nil
                               ];

    id targetSpecificParagraphStyle = [paragraphStyle targetSpecificRepresentation];
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:targetSpecificParagraphStyle range:NSMakeRange(0,1)];  
    
    // This test requires a resource manager with a paper format, we use 1100 as page width and 50 as legt/right margins here
    RKDocument *document = [RKDocument new];
    document.pageSize = CGSizeMake(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);
    
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: document];
    
    // Right alligned
    STAssertEqualObjects([RKParagraphStyleWriter styleTagFromParagraphStyle:targetSpecificParagraphStyle ofAttributedString:attributedString range:NSMakeRange(0, 1) resources:resources],
                         @"\\rtlpar"
                         "\\qr"
                         "\\fi-20"
                         "\\li40"
                         "\\ri60"
                         // RTF requires the ordering \\slN\\slmultN
                         "\\slleading80"
                         "\\sl1200\\slmult1"
                         "\\slmaximum120"
                         "\\slminimum140"
                         "\\sb160"
                         "\\sa180"
                         // Tabs
                         "\\pardeftab220"
                         "\\tx200"
                         "\\tqc\\tx400"
                         "\\tqr\\tx600"
                #if !TARGET_OS_IPHONE
                         "\\tqdec\\tx800"
                #endif
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testParagraphTagging
{
    RKParagraphStyle *paragraphStyleA = [self defaultParagraphStyle];
    RKParagraphStyle *paragraphStyleB = [self defaultParagraphStyle];
    
    paragraphStyleA.alignment = kCTCenterTextAlignment;
    paragraphStyleB.alignment = kCTRightTextAlignment;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaa\nbbb"];
    
    id targetSpecificStyleA = [paragraphStyleA targetSpecificRepresentation];
    id targetSpecificStyleB = [paragraphStyleB targetSpecificRepresentation];
    
    [attributedString addAttribute:RKParagraphStyleAttributeName value:targetSpecificStyleA range:NSMakeRange(0,1)];
    [attributedString addAttribute:RKParagraphStyleAttributeName value:targetSpecificStyleB range:NSMakeRange(1,1)];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString: @"aaa\nbbb"];
    
    [RKParagraphStyleWriter addTagsForAttribute:RKParagraphStyleAttributeName 
                                          value:targetSpecificStyleA 
                                 effectiveRange:NSMakeRange(0,3) 
                                       toString:taggedString 
                                 originalString:attributedString 
                               conversionPolicy:0 
                                      resources:nil
    ];

    [RKParagraphStyleWriter addTagsForAttribute:RKParagraphStyleAttributeName 
                                          value:targetSpecificStyleB 
                                 effectiveRange:NSMakeRange(4,3)
                                       toString:taggedString 
                                 originalString:attributedString 
                               conversionPolicy:0 
                                      resources:nil
     ];

    STAssertEqualObjects([taggedString flattenedRTFString], 
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
    RKParagraphStyle *paragraphStyleDefault = [self defaultParagraphStyle];
    RKParagraphStyle *paragraphStyleNonDefault = [self defaultParagraphStyle];
    
    // The only default-value we have to override is "alignment", since the natural alignment will be processed by Cocoa
    paragraphStyleDefault.alignment = NSLeftTextAlignment;
    
    paragraphStyleNonDefault.alignment = NSRightTextAlignment;

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
                               [[NSTextTab alloc] initWithType:NSDecimalTabStopType location:40.0f],
                               nil
                               ];
 
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:@"A\nB\n"];
    
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleNonDefault targetSpecificRepresentation] range:NSMakeRange(0, 2)];
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleDefault targetSpecificRepresentation] range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:testString onAttribute:RKParagraphStyleAttributeName inRange:NSMakeRange(0, 3)];
}

- (void)testCocoaIntegrationLTRParagraph
{
    RKParagraphStyle *paragraphStyleDefault = [self defaultParagraphStyle];
    RKParagraphStyle *paragraphStyleNonDefault = [self defaultParagraphStyle];
    
    // The only default-value we have to override is "alignment", since the natural alignment will be processed by Cocoa
    paragraphStyleDefault.alignment = NSLeftTextAlignment;
    
    paragraphStyleNonDefault.alignment = NSRightTextAlignment;
    
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
                                         [[NSTextTab alloc] initWithType:NSDecimalTabStopType location:40.0f],
                                         nil
                                         ];
    
    NSMutableAttributedString *testString = [[NSMutableAttributedString alloc] initWithString:@"A\nB\n"];
    
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleNonDefault targetSpecificRepresentation] range:NSMakeRange(0, 2)];
    [testString addAttribute:RKParagraphStyleAttributeName value:[paragraphStyleDefault targetSpecificRepresentation] range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:testString onAttribute:RKParagraphStyleAttributeName inRange:NSMakeRange(0, 3)];
}
#endif

@end
