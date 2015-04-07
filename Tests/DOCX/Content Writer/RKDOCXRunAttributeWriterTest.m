//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"
#import "XCTestCase+DOCX.h"


@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

- (void)testRunElementWithFontSizeAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:0 weight:0 size:42];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Size Test (42)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"fontsize"];
}

- (void)testRunElementWithFontNameAttribute
{
	NSFont *font = [NSFont fontWithName:@"Papyrus" size:12];
	NSDictionary *attributes = @{RKFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Name Test (Papyrus)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"fontname"];
}

- (void)testRunElementWithBoldItalicFontNameAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Arial" traits:(NSBoldFontMask | NSItalicFontMask) weight:0 size:12];
	NSDictionary *attributes = @{RKFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Bold Italic Font Name Test (Arial)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"bold-italic-fontname"];
}

- (void)testRunElementWithFontColor
{
	NSDictionary *attributes = @{RKForegroundColorAttributeName: [NSColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Font Color Test (#0080FF)" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"color"];
}

- (void)testRunElementWithOutline
{
	NSDictionary *attributes = @{RKStrokeWidthAttributeName: @(1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Outline Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"outline"];
}

- (void)testRunElementWithShadow
{
	NSDictionary *attributes = @{RKShadowAttributeName: [NSShadow new]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Shadow Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"shadow"];
}

- (void)testRunElementWithSingleStrikethrough
{
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Single Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"strike"];
}

- (void)testRunElementWithDoubleStrikethrough
{
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleDouble)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Double Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"dstrike"];
}

- (void)testRunElementWithUnsupportedStrikethrough
{
	// RKUnderlineStyleThick should fall back to RKUnderlineStyleSingle
	NSDictionary *attributes = @{RKStrikethroughStyleAttributeName: @(RKUnderlineStyleThick)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Single Strikethrough Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"strike"];
}

- (void)testRunElementWithUnderline
{
	NSDictionary *attributes = @{RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle), RKUnderlineColorAttributeName: [NSColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Underline Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"underline"];
}

- (void)testRunElementWithSubscript
{
	NSDictionary *attributes = @{RKSuperscriptAttributeName: @(-1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Subscript Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"subscript"];
}

- (void)testRunElementWithSuperscript
{
	NSDictionary *attributes = @{RKSuperscriptAttributeName: @(1)};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Superscript Test" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"superscript"];
}

@end
