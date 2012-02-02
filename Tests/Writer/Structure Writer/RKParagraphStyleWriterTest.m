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
    
    return paragraphStyle;
}

- (void)testTranslateDefaultParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    
    // Test with default settings
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
}

- (void)testTranslateAlignmentStyles
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    
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
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );     
    
    // Left alignment
    paragraphStyle.alignment = NSLeftTextAlignment;    
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard\\ql"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Center alignment
    paragraphStyle.alignment = NSCenterTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard\\qc"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         ); 
    
    // Right alignment
    paragraphStyle.alignment = NSRightTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard\\qr"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
    
    // Right alignment
    paragraphStyle.alignment = NSJustifiedTextAlignment;
    
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard\\qj"
                         // Space required to prevent problems with succeeding commands
                         " ",
                         @"Invalid translation"
                         );    
}

- (void)testTranslateNonDefaultParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [self defaultParagraphStyle];
    
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
    
    paragraphStyle.tabStops = [NSArray arrayWithObjects: 
                               [[NSTextTab alloc] initWithType:NSLeftTabStopType location:10.0f],
                               [[NSTextTab alloc] initWithType:NSCenterTabStopType location:20.0f],
                               [[NSTextTab alloc] initWithType:NSRightTabStopType location:30.0f],
                               [[NSTextTab alloc] initWithType:NSDecimalTabStopType location:40.0f],
                               nil
                               ];
    
    // Right alligned
    STAssertEqualObjects([RKParagraphStyleWriter openingTagFromParagraphStyle:paragraphStyle],
                         @"\\pard"
                         "\\rtlpar"
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

- (void)testParagraphTagging
{
    RKResourcePool *resources = [RKResourcePool new];
    
    NSMutableParagraphStyle *paragraphStyleA = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleB = [self defaultParagraphStyle];
    
    paragraphStyleA.alignment = NSCenterTextAlignment;
    paragraphStyleB.alignment = NSRightTextAlignment;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"aaabbb"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString: [attributedString string]];

    [attributedString addAttribute:NSAttachmentAttributeName value:paragraphStyleA range:NSMakeRange(0, 3)];
    [attributedString addAttribute:NSAttachmentAttributeName value:paragraphStyleB range:NSMakeRange(3, 3)];
    
    [RKParagraphStyleWriter addTagsForAttributedString:attributedString toTaggedString:taggedString withAttachmentPolicy:0 resources:resources];
    
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"\\pard\\qc "
                          "aaa"
                          "\\par\n"
                          "\\pard\\qr "
                          "bbb"
                          "\\par\n", 
                         @"Invalid flattening"
                        );
}

- (void)testTextLists
{
    NSTextList *head = [[NSTextList alloc] initWithMarkerFormat:@"({decimal})" options:0 ];
    NSTextList *levelA = [[NSTextList alloc] initWithMarkerFormat:@"-{lower-roman}-" options:NSTextListPrependEnclosingMarker ];
    NSTextList *levelAA = [[NSTextList alloc] initWithMarkerFormat:@"{upper-roman}." options:NSTextListPrependEnclosingMarker ];
    NSTextList *levelAB = [[NSTextList alloc] initWithMarkerFormat:@"::{upper-roman}::" options:NSTextListPrependEnclosingMarker ];
    
    RKResourcePool *resources = [RKResourcePool new];
    NSMutableParagraphStyle *paragraphStyleHead = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleLevelA = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleLevelAA = [self defaultParagraphStyle];
    NSMutableParagraphStyle *paragraphStyleLevelAB = [self defaultParagraphStyle];
    
    paragraphStyleHead.textLists = [NSArray arrayWithObjects:head, nil];
    paragraphStyleLevelA.textLists = [NSArray arrayWithObjects:head, levelA, nil];
    paragraphStyleLevelAA.textLists = [NSArray arrayWithObjects:head, levelA, levelAA, nil];
    paragraphStyleLevelAB.textLists = [NSArray arrayWithObjects:head, levelA, levelAB, nil];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"H\nA\nAA\nAB" ];
    
    NSRange headPos = NSMakeRange(0, 1);
    NSRange levelAPos = NSMakeRange(2, 1);
    NSRange levelAAPos = NSMakeRange(4, 2);
    NSRange levelABPos = NSMakeRange(7, 2);    
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleHead range:headPos];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleLevelA range:levelAPos];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleLevelAA range:levelAAPos];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleLevelAB range:levelABPos];
    
    // Head tag
    NSString *tags = [RKParagraphStyleWriter openingTagsForTextLists:paragraphStyleHead.textLists ofAttributedString:attributedString inRange:headPos resources:resources];
    
    STAssertEqualObjects(tags,
                         @"\\ls1\\ilvl0{\\listtext  (1)}",
                         @"Invalid text list style"
                         );
    
    // Level A tag
    tags = [RKParagraphStyleWriter openingTagsForTextLists:paragraphStyleLevelA.textLists ofAttributedString:attributedString inRange:levelAPos resources:resources];
    
    STAssertEqualObjects(tags,
                         @"\\ls1\\ilvl1{\\listtext  (1)-i-}",
                         @"Invalid text list style"
                         );

    // Level AA tag
    tags = [RKParagraphStyleWriter openingTagsForTextLists:paragraphStyleLevelAA.textLists ofAttributedString:attributedString inRange:levelAAPos resources:resources];
    
    STAssertEqualObjects(tags,
                         @"\\ls1\\ilvl0{\\listtext  (1)-i-I}",
                         @"Invalid text list style"
                         );
    
    // Level AB tag
    tags = [RKParagraphStyleWriter openingTagsForTextLists:paragraphStyleLevelAB.textLists ofAttributedString:attributedString inRange:levelABPos resources:resources];
    
    STAssertEqualObjects(tags,
                         @"\\ls1\\ilvl0{\\listtext  (1)-i::I::}",
                         @"Invalid text list style"
                         );
    
    // Verify stored list style (AB should be kept, AA should be ignored to simulate the behaviour of the text system)
    NSArray *listDescriptions = [resources levelDescriptionsOfList:0];
    
    STAssertEquals([listDescriptions objectAtIndex:0], head, @"Invalid list description");
    STAssertEquals([listDescriptions objectAtIndex:1], levelA, @"Invalid list description");
    STAssertEquals([listDescriptions objectAtIndex:1], levelAB, @"Invalid list description");

}
                                 
@end
