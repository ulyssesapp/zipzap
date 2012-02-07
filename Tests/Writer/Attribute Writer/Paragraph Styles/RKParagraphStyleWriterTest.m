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
    paragraphStyle.alignment = NSNaturalTextAlignment;
    
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
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];    
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard\\pardeftab0"
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
    paragraphStyle.alignment = NSNaturalTextAlignment;
    
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
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Left alignment
    paragraphStyle.alignment = NSLeftTextAlignment;    
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard\\ql\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Center alignment
    paragraphStyle.alignment = NSCenterTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard\\qc\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Right alignment
    paragraphStyle.alignment = NSRightTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard\\qr\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
    
    // Right alignment
    paragraphStyle.alignment = NSJustifiedTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard\\qj\\pardeftab0"
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
    paragraphStyle.alignment = NSNaturalTextAlignment;
    
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
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,3)];
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 3)],
                         @"\\pard\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Line height multiple of default font
    paragraphStyle.lineHeightMultiple = 3.0f;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 3)],
                         @"\\pard\\sl720\\slmult1\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 

    // Line height multiple of largest font
    paragraphStyle.lineHeightMultiple = 3.0f;
    
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:20] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:30] range:NSMakeRange(1, 1)];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica" size:40] range:NSMakeRange(2, 1)];
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 3)],
                         @"\\pard\\sl2400\\slmult1\\pardeftab0"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testTranslateNonDefaultParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"a"];
    
    paragraphStyle.alignment = NSRightTextAlignment;
    
    paragraphStyle.firstLineHeadIndent = 1.0f;
    paragraphStyle.headIndent = 2.0f;
    paragraphStyle.tailIndent = 3.0f;
    
    paragraphStyle.lineSpacing = 4.0f;
    paragraphStyle.lineHeightMultiple = 5.0f;
    paragraphStyle.maximumLineHeight = 6.0f;
    paragraphStyle.minimumLineHeight = 7.0f;
    
    paragraphStyle.paragraphSpacingBefore = 8.0f;
    paragraphStyle.paragraphSpacing = 9.0f;
    
    paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    paragraphStyle.defaultTabInterval = 11.0f;
    
    paragraphStyle.tabStops = [NSArray arrayWithObjects: 
                               [[NSTextTab alloc] initWithType:NSLeftTabStopType location:10.0f],
                               [[NSTextTab alloc] initWithType:NSCenterTabStopType location:20.0f],
                               [[NSTextTab alloc] initWithType:NSRightTabStopType location:30.0f],
                               [[NSTextTab alloc] initWithType:NSDecimalTabStopType location:40.0f],
                               nil
                               ];

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,1)];  
    
    // Right alligned
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle ofAttributedString:attributedString inRange:NSMakeRange(0, 1)],
                         @"\\pard"
                         "\\rtlpar"
                         "\\qr"
                         "\\fi-20\\cufi-20"
                         "\\li40\\culi40"
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
                         "\\tqdec\\tx800"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testParagraphTagging
{
    RKResourcePool *resources = [RKResourcePool new];
    
    NSMutableParagraphStyle *paragraphStyleA = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleB = [self defaultParagraphStyle];
    
    paragraphStyleA.alignment = NSCenterTextAlignment;
    paragraphStyleB.alignment = NSRightTextAlignment;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"ab"];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleA range:NSMakeRange(0,1)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleB range:NSMakeRange(1,1)];
    
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString: @"aaabbb"];
    
    [RKParagraphStyleWriter addTagsForAttribute:paragraphStyleA toTaggedString:taggedString inRange:NSMakeRange(0,3) ofAttributedString:attributedString withAttachmentPolicy:0 resources:resources];
    [RKParagraphStyleWriter addTagsForAttribute:paragraphStyleB toTaggedString:taggedString inRange:NSMakeRange(3,3) ofAttributedString:attributedString withAttachmentPolicy:0 resources:resources];

    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"\\pard\\qc\\pardeftab0 "
                          "aaa"
                          "\\par\n"
                          "\\pard\\qr\\pardeftab0 "
                          "bbb"
                          "\\par\n", 
                         @"Invalid flattening"
                        );
}

- (void)testCocoaIntegration
{
    NSMutableParagraphStyle *paragraphStyleDefault = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleNonDefault = [self defaultParagraphStyle];
    
    // The only default-value we have to override is "alignment", since the natural alignment will be processed by Cocoa
    paragraphStyleDefault.alignment = NSLeftTextAlignment;
    
    paragraphStyleNonDefault.alignment = NSRightTextAlignment;

    paragraphStyleNonDefault.firstLineHeadIndent = 1.0f;
    paragraphStyleNonDefault.headIndent = 2.0f;    
    
    // This is inconsistently interpreted by Cocoa
    //paragraphStyleNonDefault.tailIndent = -1.0f;
   
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
    
    [testString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleNonDefault range:NSMakeRange(0, 2)];
    [testString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleDefault range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:testString onAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, 3)];
}

@end
