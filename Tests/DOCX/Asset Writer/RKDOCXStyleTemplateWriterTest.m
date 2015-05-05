//
//  RKDOCXStyleTemplateWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 04.05.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"

#if TARGET_OS_IPHONE
	#define RKFont UIFont
#else
	#define RKFont NSFont
#endif

@interface RKDOCXStyleTemplateWriterTest : XCTestCase

@end

@implementation RKDOCXStyleTemplateWriterTest

- (void)testStyleTemplate
{
	CTFontRef styleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	
	NSDictionary *styleAttributes = @{RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0], RKFontAttributeName: (__bridge RKFont *)styleFont};
	NSString *styleName = @"Character Style";
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName, RKFontAttributeName: (__bridge RKFont *)font};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should have a character style named \"Character Style\". The style enables italic and bold font traits, however, the attributed string itself disables the italic font trait." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"characterstyle"];
}

- (void)testStyleTemplateWithLocalOverrides
{
	// Character Style
	CTFontRef styleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *styleAttributes = @{RKFontAttributeName: (__bridge RKFont *)styleFont,
									  RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0],
									  RKStrokeWidthAttributeName: @1,
									  RKShadowAttributeName: [NSShadow new],
									  RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKSuperscriptAttributeName: @1};
	NSString *styleName = @"Style";
	
	// String Attributes
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 24, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName,
								 RKFontAttributeName: (__bridge RKFont *)font,
								 RKForegroundColorAttributeName: [RKColor colorWithRed:1 green:0 blue:0.5 alpha:0]};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text is displayed in a pink Helvetica font with 24pt size, neither bold nor italic. There shouldn't be any text effects visible." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"styletemplateoverride"];
}

@end
