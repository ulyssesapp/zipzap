//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"
#import "RKFont.h"

@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

- (void)testRunElementWithFontSizeAttribute
{
	CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 42, NULL);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Size Test (42)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"fontsize"];
}

- (void)testRunElementWithFontNameAttribute
{
	CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"Papyrus", 12, NULL);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Name Test (Papyrus)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"fontname"];
}

- (void)testRunElementWithBoldItalicFontNameAttribute
{
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Bold Italic Font Name Test (Arial)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"bold-italic-fontname"];
}

- (void)testRunElementWithFontColorAttribute
{
	NSDictionary *attributes = @{RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Color Test (#0080FF)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"color"];
}

- (void)testTwoRunElementsWithFontColorAttributes
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Light-blue text and pink text."];
	[attributedString addAttribute:RKForegroundColorAttributeName value:[RKColor colorWithRed:0 green:0.5 blue:1 alpha:0] range:NSMakeRange(0, 15)];
	[attributedString addAttribute:RKForegroundColorAttributeName value:[RKColor colorWithRed:1 green:0 blue:0.5 alpha:0] range:NSMakeRange(20, attributedString.length - 20)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"twocolors"];
}

- (void)testRunElementWithBackgroundColorAttribute
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Highlight Color Test: Red Yellow Green" attributes:@{}];
	[attributedString addAttribute:RKBackgroundColorAttributeName value:[RKColor rk_colorWithHexRepresentation: @"ff2020"] range:NSMakeRange(22, 3)];
	[attributedString addAttribute:RKBackgroundColorAttributeName value:[RKColor rk_colorWithHexRepresentation: @"cfcf00"] range:NSMakeRange(26, 6)];
	[attributedString addAttribute:RKBackgroundColorAttributeName value:[RKColor rk_colorWithHexRepresentation: @"10ef10"] range:NSMakeRange(33, 5)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"highlight-color"];
}

- (void)testRunElementWithOutlineAttribute
{
	NSDictionary *attributes = @{RKStrokeWidthAttributeName: @1};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Outline Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"outline"];
}

- (void)testRunElementWithShadowAttribute
{
	NSDictionary *attributes = @{RKShadowAttributeName: [NSShadow new]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Shadow Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"shadow"];
}

- (void)testRunElementWithSpacingAttribute
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Character Spacing Test\n" attributes:@{RKKernAttributeName: @1}];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"Negative Character Spacing Test" attributes:@{RKKernAttributeName: @(-1)}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"characterspacing"];
}

- (void)testRunElementWithSingleStrikethroughAttribute
{
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Single Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"strike"];
}

- (void)testRunElementWithUnsupportedStrikethroughAttribute
{
	// All underline styles should fall back to RKUnderlineStyleSingle
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleThick)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Single Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"strike"];
}

- (void)testRunElementWithUnderlineAttribute
{
	NSDictionary *attributes = @{RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle), RKUnderlineColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Underline Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"underline"];
}

- (void)testRunElementWithSubscriptAttribute
{
	NSDictionary *attributes = @{RKSuperscriptAttributeName: @(-1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Subscript Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"subscript"];
}

- (void)testRunElementWithSuperscriptAttribute
{
	NSDictionary *attributes = @{RKSuperscriptAttributeName: @1};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Superscript Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"superscript"];
}

- (void)testRunElementWithLigatures
{
	CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"Zapfino", 12, NULL);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	
	NSMutableDictionary *noLigatures = [attributes mutableCopy];
	noLigatures[RKLigatureAttributeName] = @0;
	NSMutableDictionary * defaultLigatures = [attributes mutableCopy];
	defaultLigatures[RKLigatureAttributeName] = @1;
	NSMutableDictionary *allLigatures = [attributes mutableCopy];
	allLigatures[RKLigatureAttributeName] = @2;
	NSDictionary *noMentionOfLigatures = [attributes mutableCopy];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This text is written in Zapfino and is using no ligatures.\n" attributes:noLigatures];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"This text is written in Zapfino and is using default ligatures.\n" attributes:defaultLigatures]];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"This text is written in Zapfino and is using all supported ligatures.\n" attributes:allLigatures]];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"The attributes of this text do not mention ligatures, so the text should be using default ligatures. It is written in Zapfino, by the way." attributes:noMentionOfLigatures]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"ligatures"];
}

- (void)testPageNumberPlaceholder
{
	NSDictionary *attributes = @{RKPlaceholderAttributeName: @(RKPlaceholderPageNumber)};
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Placeholder Test "];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:attributes]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"pagenumber"];
}

@end
