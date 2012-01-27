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

- (void)testTranslateDefaultParagraphStyle
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
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testTranslateAlignmentStyles
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
    
    
    // Natural alignment
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Left alignment
    paragraphStyle.alignment = NSLeftTextAlignment;    
    
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard\\ql"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Center alignment
    paragraphStyle.alignment = NSCenterTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard\\qc"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Right alignment
    paragraphStyle.alignment = NSRightTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard\\qr"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
    
    // Right alignment
    paragraphStyle.alignment = NSJustifiedTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard\\qj"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
}

- (void)testTranslateNonDefaultParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
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
    
    paragraphStyle.tabStops = [NSArray arrayWithObjects: 
                               [[NSTextTab alloc] initWithType:NSLeftTabStopType location:10.0f],
                               [[NSTextTab alloc] initWithType:NSCenterTabStopType location:20.0f],
                               [[NSTextTab alloc] initWithType:NSRightTabStopType location:30.0f],
                               [[NSTextTab alloc] initWithType:NSDecimalTabStopType location:40.0f],
                               nil
                               ];
    
    // Right alligned
    STAssertEqualObjects([RKParagraphStyleWriter RTFfromParagraphStyle:paragraphStyle],
                         @"\\pard"
                         "\\qr"
                         "\\fl20"
                         "\\culi40"
                         "\\ri60"
                         // RTF requires the ordering \\slN\\slmultN
                         "\\sl80"
                         "\\slmult5"
                         "\\slmaximum120"
                         "\\slminimum140"
                         "\\sb160"
                         "\\sa180"
                         // Tabs
                         "\\tx200"
                         "\\tqc\\tx400"
                         "\\tqr\\tx600"
                         "\\tqdec\\tx800"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

@end
