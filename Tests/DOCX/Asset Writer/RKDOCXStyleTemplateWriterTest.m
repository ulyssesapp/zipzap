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

- (void)testStyleTemplateWithIdenticStringAttributes
{
	CTFontRef styleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	
	NSDictionary *styleAttributes = @{RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0], RKFontAttributeName: (__bridge RKFont *)styleFont};
	NSString *styleName = @"Character Style";
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: @{RKCharacterStyleNameAttributeName: styleName}];
	[attributes addEntriesFromDictionary: styleAttributes];
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should have a character style named \"Character Style\". The style enables italic and bold font traits and colors the font blue." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"characterstylewithidenticattributes"];
}

- (void)testStyleTemplateWithOverridingStringAttributes
{
	// Character Style
	CTFontRef styleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *styleAttributes = @{RKFontAttributeName: (__bridge RKFont *)styleFont,
									  RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0],
									  RKSuperscriptAttributeName: @1};
	NSString *styleName = @"Style";
	
	// String Attributes
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 24, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName,
								 RKFontAttributeName: (__bridge RKFont *)font,
								 RKForegroundColorAttributeName: [RKColor colorWithRed:1 green:0 blue:0.5 alpha:0],
								 RKSuperscriptAttributeName: @(-1)};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text is displayed in a pink Helvetica font with 24pt size, neither bold nor italic. There shouldn’t be any text effects visible." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"characterstyletemplateoverride"];
}

- (void)testStyleTemplateWithExplicitDeactivatingStringAttributes
{
	// Character Style
	NSDictionary *styleAttributes = @{RKStrokeWidthAttributeName: @1,
									  RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKSuperscriptAttributeName: @1};
	NSString *styleName = @"Style";
	
	// String Attributes
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName,
								 RKStrokeWidthAttributeName: @0,
								 RKStrikethroughStyleAttributeName: @(RKUnderlineStyleNone),
								 RKUnderlineStyleAttributeName: @(RKUnderlineStyleNone),
								 RKSuperscriptAttributeName: @(0)};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text shouldn’t have any visible text effects, because they’re explicitely deactivated." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"characterstylewithexplicitdeactiviation"];
}

- (void)testStyleTemplateWithImplicitDeactivatingStringAttributes
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
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text shouldn’t have any visible text effects, because they’re implicitely deactivated." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"characterstylewithimplicitdeactiviation"];
}

- (void)testLocalizedStyleName
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Emphasis should read \"Herausstellen\" and Strong should read \"Betont\" in the German localization of Word."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{@"Emphasis": @{RKForegroundColorAttributeName: [RKColor colorWithRed:1 green:0 blue:0.5 alpha:0]},
								 @"Strong": @{RKForegroundColorAttributeName: [RKColor colorWithRed:0.5 green:0 blue:1 alpha:0]}};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"localizedstyle"];
}

@end
