//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"

#if TARGET_OS_IPHONE
	#define RKFont UIFont
#else
	#define RKFont NSFont
#endif

@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

- (void)testRunElementWithFontSizeAttribute
{
	CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 42, NULL);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Size Test (42)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"fontsize"];
}

- (void)testRunElementWithFontNameAttribute
{
	CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"Papyrus", 12, NULL);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Name Test (Papyrus)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"fontname"];
}

- (void)testRunElementWithBoldItalicFontNameAttribute
{
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Bold Italic Font Name Test (Arial)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"bold-italic-fontname"];
}

- (void)testRunElementWithFontColorAttribute
{
	NSDictionary *attributes = @{RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Color Test (#0080FF)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"color"];
}

- (void)testTwoRunElementsWithFontColorAttributes
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Light-blue text and pink text."];
	[attributedString addAttribute:RKForegroundColorAttributeName value:[RKColor colorWithRed:0 green:0.5 blue:1 alpha:0] range:NSMakeRange(0, 15)];
	[attributedString addAttribute:RKForegroundColorAttributeName value:[RKColor colorWithRed:1 green:0 blue:0.5 alpha:0] range:NSMakeRange(20, attributedString.length - 20)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"twocolors"];
}

- (void)testRunElementWithOutlineAttribute
{
	NSDictionary *attributes = @{RKStrokeWidthAttributeName: @(1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Outline Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"outline"];
}

- (void)testRunElementWithShadowAttribute
{
	NSDictionary *attributes = @{RKShadowAttributeName: [NSShadow new]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Shadow Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"shadow"];
}

- (void)testRunElementWithSingleStrikethroughAttribute
{
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Single Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"strike"];
}

- (void)testRunElementWithUnsupportedStrikethroughAttribute
{
	// All underline styles should fall back to RKUnderlineStyleSingle
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleThick)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Single Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"strike"];
}

- (void)testRunElementWithUnderlineAttribute
{
	NSDictionary *attributes = @{RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle), RKUnderlineColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Underline Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"underline"];
}

- (void)testRunElementWithSubscriptAttribute
{
	NSDictionary *attributes = @{RKSuperscriptAttributeName: @(-1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Subscript Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"subscript"];
}

- (void)testRunElementWithSuperscriptAttribute
{
	NSDictionary *attributes = @{RKSuperscriptAttributeName: @(1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Superscript Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"superscript"];
}

@end
