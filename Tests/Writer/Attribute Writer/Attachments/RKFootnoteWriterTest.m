//
//  RKFootnoteWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnoteWriter.h"
#import "RKFootnoteWriterTest.h"

@implementation RKFootnoteWriterTest

- (void)testGenerateFootnote
{
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: [RKDocument new]];
    NSMutableAttributedString *footnote = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    [footnote addAttribute:RKFontAttributeName value:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)@"GillSans", 16, NULL) range:NSMakeRange(0, 3)];
    
    NSString *string = [NSString stringWithFormat:@">%C<", RKAttachmentCharacter];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:string];
    
    [RKFootnoteWriter addTagsForAttribute:RKFootnoteAttributeName value:footnote effectiveRange:NSMakeRange(1,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resources];
    
    // Valid string tagging
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @">{\\chftn }{\\footnote \\tab{\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 \\super \\chftn }\\tab \\pard \\fi-400\\li400\\pardeftab0\\tx0\\tx400 \\cb1 \\cf0 \\strikec0 \\strokec0 \\f1 \\fs32\\fsmilli16000 aaa}<",
                         @"Invalid footnote generated"
                         );
    
    // Font was collected
    STAssertEquals(resources.fontFamilyNames.count, (NSUInteger)2, @"Invalid count of fonts");
    STAssertEqualObjects([resources.fontFamilyNames objectAtIndex:1], @"GillSans", @"Missing font");
}

- (void)testGenerateEndnote
{
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: [RKDocument new]];
    NSMutableAttributedString *footnote = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    [footnote addAttribute:RKFontAttributeName value:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)@"GillSans", 16, NULL) range:NSMakeRange(0, 3)];
    
    NSString *string = [NSString stringWithFormat:@">%C<", RKAttachmentCharacter];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:string];
    
    [RKFootnoteWriter addTagsForAttribute:RKEndnoteAttributeName value:footnote effectiveRange:NSMakeRange(1,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resources];
    
    // Valid string tagging
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @">{\\chftn }{\\footnote\\ftnalt \\tab{\\cb1 \\cf0 \\strikec0 \\strokec0 \\f0 \\fs24\\fsmilli12000 \\super \\chftn }\\tab \\pard \\fi-400\\li400\\pardeftab0\\tx0\\tx400 \\cb1 \\cf0 \\strikec0 \\strokec0 \\f1 \\fs32\\fsmilli16000 aaa}<",
                         @"Invalid footnote generated"
                          );
    
    // Font was collected
    STAssertEquals(resources.fontFamilyNames.count, (NSUInteger)2, @"Invalid count of fonts");
    STAssertEqualObjects([resources.fontFamilyNames objectAtIndex:1], @"GillSans", @"Missing font");
}

#if !TARGET_OS_IPHONE
- (void)testFootnotesAreIgnoredByCocoa
{
    NSMutableAttributedString *footnote = [[NSMutableAttributedString alloc] initWithString:@"aaa"];    
    
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc", RKAttachmentCharacter]];
    
    [original addAttribute:RKFootnoteAttributeName value:footnote range:NSMakeRange(1, 1)];
    
    NSAttributedString *converted = [self convertAndRereadRTF:original documentAttributes:nil];
    
    // Footnotes are just ignored
    [converted enumerateAttribute:RKFootnoteAttributeName inRange:NSMakeRange(0, [converted length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        STAssertTrue(value == nil, @"No images should occur when reading with cocoa");
    }];
    
    STAssertEqualObjects([converted string], @"abc", @"Invalid string content");    
}
#endif

- (void)testFootnotesAreCompatibleToManualReferenceTest
{
    // Footnote with some inline formatting
    NSMutableAttributedString *footnote = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    [footnote addAttribute:RKFontAttributeName value:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)@"Helvetica-Bold", 12, NULL) range:NSMakeRange(1,1)];
    
    // Text with an inline footnote
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc %@", RKAttachmentCharacter, [@"" stringByPaddingToLength:4000 withString:@"lorem " startingAtIndex:0]]];
    
    [original addAttribute:RKFootnoteAttributeName value:footnote range:NSMakeRange(1, 1)];
	[original addAttribute:RKSuperscriptAttributeName value:@1 range:NSMakeRange(1, 1)];

    // This testcase should verify that we can use "Test Data/footnote.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithAttributedString:original];
	document.footnoteAreaDividerPosition = NSRightTextAlignment;
	document.footnoteAreaDividerSpacingBefore = 60;
	document.footnoteAreaDividerSpacingAfter = 60;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"footnote"];
}

- (void)testEndnotesAreCompatibleToManualReferenceTest
{
    // Footnote with some inline formatting
    NSMutableAttributedString *endnote = [[NSMutableAttributedString alloc] initWithString:@"aaa"];    
    [endnote addAttribute:RKFontAttributeName value:(__bridge_transfer id)CTFontCreateWithName((__bridge CFStringRef)@"Helvetica-Bold", 12, NULL) range:NSMakeRange(1,1)];
    
    // Text with an inline footnote
    NSMutableAttributedString *original = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"a%Cbc %@", RKAttachmentCharacter, [@"" stringByPaddingToLength:4000 withString:@"lorem " startingAtIndex:0]]];
    
    [original addAttribute:RKEndnoteAttributeName value:endnote range:NSMakeRange(1, 1)];
	[original addAttribute:RKSuperscriptAttributeName value:@1 range:NSMakeRange(1, 1)];
    
    // This testcase should verify that we can use "Test Data/footnote.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithAttributedString:original];
	document.footnoteAreaDividerPosition = NSRightTextAlignment;
	document.footnoteAreaDividerSpacingBefore = 60;
	document.footnoteAreaDividerSpacingAfter = 60;
	
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"endnote"];
}

@end
