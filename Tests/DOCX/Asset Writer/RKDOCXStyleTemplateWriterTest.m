//
//  RKDOCXStyleTemplateWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 04.05.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"
#import "RKFont.h"

@interface RKDOCXStyleTemplateWriterTest : XCTestCase

@end

@implementation RKDOCXStyleTemplateWriterTest


#pragma mark - Character style templates

- (void)testCharacterStyleTemplateWithIdenticStringAttributes
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

- (void)testCharacterStyleTemplateWithOverridingStringAttributes
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

- (void)testCharacterStyleTemplateWithExplicitDeactivatingStringAttributes
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

- (void)testCharacterStyleTemplateWithImplicitDeactivatingStringAttributes
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

- (void)testLocalizedCharacterStyleName
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Emphasis should read \"Herausstellen\" and Strong should read \"Betont\" in the German localization of Word."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{@"Emphasis": @{RKForegroundColorAttributeName: [RKColor colorWithRed:1 green:0 blue:0.5 alpha:0]},
								 @"Strong": @{RKForegroundColorAttributeName: [RKColor colorWithRed:0.5 green:0 blue:1 alpha:0]}};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"localizedcharacterstyle"];
}


#pragma mark - Paragraph style templates

- (void)testParagraphStyleTemplateWithDeactivatedBaseWritingDirectionAttribute
{
	NSString *styleName = @"Bidi Style";
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: styleName, RKParagraphStyleAttributeName: [paragraphStyle copy]};
	
	paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;

	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Base Writing Direction Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{styleName: @{RKParagraphStyleAttributeName: paragraphStyle}};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"paragraphstylewithdeactivatedbasewritingdirection"];
}

- (void)testParagraphStyleTemplateWithIdenticStringAttributes
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 13;
	paragraphStyle.tailIndent = 04;
	paragraphStyle.firstLineHeadIndent = 19;
	paragraphStyle.lineSpacing = 29;
	paragraphStyle.paragraphSpacingBefore = 20;
	paragraphStyle.paragraphSpacing = 15;
	paragraphStyle.alignment = RKTextAlignmentJustified;
	paragraphStyle.defaultTabInterval = 42;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:42 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentCenter location:123 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:321 options:0]];
	
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.keepWithFollowingParagraph = YES;
	additionalParagraphStyle.skipOrphanControl = YES;
	additionalParagraphStyle.hyphenationEnabled = NO;
	
	NSDictionary *styleAttributes = @{RKParagraphStyleAttributeName: paragraphStyle,
									  RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	NSString *styleName = @"Paragraph Style";
	NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: @{RKParagraphStyleNameAttributeName: styleName}];
	[attributes addEntriesFromDictionary: styleAttributes];
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should have a paragraph style named \"Paragraph Style\". Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"paragraphstylewithidenticattributes"];
}

- (void)testParagraphStyleTemplateWithOverridingStringAttributes
{
	// Character Style
	NSMutableParagraphStyle *templateParagraphStyle = [NSMutableParagraphStyle new];
	templateParagraphStyle.headIndent = 1;
	templateParagraphStyle.tailIndent = 1;
	templateParagraphStyle.firstLineHeadIndent = 1;
	templateParagraphStyle.lineSpacing = 1;
	templateParagraphStyle.paragraphSpacingBefore = 1;
	templateParagraphStyle.paragraphSpacing = 1;
	templateParagraphStyle.alignment = RKTextAlignmentRight;
	templateParagraphStyle.defaultTabInterval = 1;
	templateParagraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:1 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:2 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:3 options:0]];
	
	RKAdditionalParagraphStyle *templateAdditionalParagraphStyle = [RKAdditionalParagraphStyle new];
	templateAdditionalParagraphStyle.keepWithFollowingParagraph = YES;
	templateAdditionalParagraphStyle.skipOrphanControl = YES;
	templateAdditionalParagraphStyle.hyphenationEnabled = NO;
	
	NSDictionary *styleAttributes = @{RKParagraphStyleAttributeName: templateParagraphStyle,
									  RKAdditionalParagraphStyleAttributeName: templateAdditionalParagraphStyle};
	NSString *styleName = @"Style";
	
	// String Attributes
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 10;
	paragraphStyle.tailIndent = 10;
	paragraphStyle.firstLineHeadIndent = 10;
	paragraphStyle.lineSpacing = 10;
	paragraphStyle.paragraphSpacingBefore = 10;
	paragraphStyle.paragraphSpacing = 10;
	paragraphStyle.alignment = RKTextAlignmentCenter;
	paragraphStyle.defaultTabInterval = 10;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:10 options:0],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:20 options:0],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:30 options:0]];
	
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.keepWithFollowingParagraph = NO;
	additionalParagraphStyle.skipOrphanControl = NO;
	additionalParagraphStyle.hyphenationEnabled = YES;
	
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: styleName,
								 RKParagraphStyleAttributeName: paragraphStyle,
								 RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This paragraph overrides all template style settings. Point values of the paragraph style are set to a 10 times value of the paragraph template. Alignment is set to center. Boolean settings have been inverted. Please see the test method implementation for further details." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	document.paragraphStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"paragraphstyletemplateoverride"];
}

- (void)testParagraphStyleTemplateWithImplicitDeactivatingStringAttributes
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 1;
	paragraphStyle.tailIndent = 1;
	paragraphStyle.firstLineHeadIndent = 1;
	paragraphStyle.lineSpacing = 1;
	paragraphStyle.paragraphSpacingBefore = 1;
	paragraphStyle.paragraphSpacing = 1;
	paragraphStyle.alignment = RKTextAlignmentRight;
	paragraphStyle.defaultTabInterval = 1;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:1 options:0],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:2 options:0],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:3 options:0]];
	
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.keepWithFollowingParagraph = YES;
	additionalParagraphStyle.skipOrphanControl = YES;
	additionalParagraphStyle.hyphenationEnabled = YES;
	
	NSDictionary *styleAttributes = @{RKParagraphStyleAttributeName: paragraphStyle,
									  RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	NSString *styleName = @"Style";
	
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: styleName};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"The string attributes of this paragraph should be set to default values. Please see the test method implementation for further details." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	document.paragraphStyles = @{styleName: styleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"paragraphstylewithimplicitdeactiviation"];
}

- (void)testLocalizedParagraphStyleName
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Heading 1 should read \"Überschrift 1\" and Heading 2 should read \"Überschrift 2\" in the German localization of Word."];
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = RKTextAlignmentCenter;
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{@"heading 1": @{RKParagraphStyleAttributeName: paragraphStyle},
								 @"heading 2": @{RKForegroundColorAttributeName: [RKColor colorWithRed:0.5 green:0 blue:1 alpha:0]}};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"localizedparagraphstyle"];
}


#pragma mark - Mixed styles

- (void)testOverriddenCharacterAttributesInParagraphStyle
{
	// Paragraph Style
	CTFontRef paragraphStyleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *paragraphStyleAttributes = @{RKFontAttributeName: (__bridge RKFont *)paragraphStyleFont,
											   RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	NSString *paragraphStyleName = @"heading 1";
	
	// Character Style
	CTFontRef characterStyleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *characterStyleAttributes = @{RKFontAttributeName: (__bridge RKFont *)characterStyleFont,
											   RKFontMixAttributeName: @(RKFontMixIgnoreFontName | RKFontMixIgnoreBoldTrait)};
	NSString *characterStyleName = @"Strong";
	
	// String
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: paragraphStyleName,
								 RKCharacterStyleNameAttributeName: characterStyleName,
								 RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait),
								 RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text is displayed in blue Arial font with 12pt size, bold and italic, although the character style is set to Helvetica." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{paragraphStyleName: paragraphStyleAttributes};
	document.characterStyles = @{characterStyleName: characterStyleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"mixedstyletemplateoverride"];
}

- (void)testOverriddenStringAttributesInCharacterStyle
{
	// Character Style
	CTFontRef characterStyleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Times New Roman", 24, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *characterStyleAttributes = @{RKFontAttributeName: (__bridge RKFont *)characterStyleFont};
	NSString *characterStyleName = @"Strong";
	
	// String
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: characterStyleName,
								 RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 12, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait)};
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This text is displayed in normal Times New Roman font with 12pt size.\nThis text is displayed in normal Helvetica font with 24pt size.\nThis text is displayed as bold Helvetica font with 12pt size.\nThis text is displayed as italic Helvetica font with 12pt size.\nThis text overrides all style attributes.\nThis text only uses style formatting." attributes:attributes];
	[attributedString addAttribute:RKFontMixAttributeName value:@(RKFontMixIgnoreFontName) range:NSMakeRange(0, 69)];
	[attributedString addAttribute:RKFontMixAttributeName value:@(RKFontMixIgnoreFontSize) range:NSMakeRange(70, 64)];
	[attributedString addAttribute:RKFontMixAttributeName value:@(RKFontMixIgnoreBoldTrait) range:NSMakeRange(134, 61)];
	[attributedString addAttribute:RKFontMixAttributeName value:@(RKFontMixIgnoreItalicTrait) range:NSMakeRange(196, 63)];
	[attributedString addAttribute:RKFontMixAttributeName value:@0 range:NSMakeRange(260, 41)];
	[attributedString addAttribute:RKFontMixAttributeName value:@(RKFontMixIgnoreAll) range:NSMakeRange(302, 37)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{characterStyleName: characterStyleAttributes};
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"mixedstringstyleoverride"];
}

@end