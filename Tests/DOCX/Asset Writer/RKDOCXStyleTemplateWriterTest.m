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
	
	NSString *styleName = @"Character Style";
	NSDictionary *styleAttributes = @{RKCharacterStyleNameAttributeName: styleName,
									  RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0],
									  RKFontAttributeName: (__bridge RKFont *)styleFont,
									  RKBackgroundColorAttributeName: [RKColor colorWithRed:0 green:1 blue:0 alpha:0]};
	NSDictionary *attributes = [styleAttributes copy];
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should have a character style named \"Character Style\". The style enables italic and bold font traits and colors the font blue. The background is colored green." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"characterstylewithidenticattributes"];
}

- (void)testCharacterStyleTemplateWithOverridingStringAttributes
{
	// Character Style
	CTFontRef styleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSString *styleName = @"Style";
	NSDictionary *styleAttributes = @{RKCharacterStyleNameAttributeName: styleName,
									  RKFontAttributeName: (__bridge RKFont *)styleFont,
									  RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0],
									  RKSuperscriptAttributeName: @1};
	
	// String Attributes
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 24, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait);
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName,
								 RKFontAttributeName: (__bridge RKFont *)font,
								 RKForegroundColorAttributeName: [RKColor colorWithRed:1 green:0 blue:0.5 alpha:0],
								 RKSuperscriptAttributeName: @(-1)};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text is displayed in a pink Helvetica font with 24pt size, neither bold nor italic. There shouldn’t be any text effects visible." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"characterstyletemplateoverride"];
}

- (void)testCharacterStyleTemplateWithExplicitDeactivatingStringAttributes
{
	// Character Style
	NSString *styleName = @"Style";
	NSDictionary *styleAttributes = @{RKCharacterStyleNameAttributeName: styleName,
									  RKStrokeWidthAttributeName: @1,
									  RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKSuperscriptAttributeName: @1};
	
	// String Attributes
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName,
								 RKStrokeWidthAttributeName: @0,
								 RKStrikethroughStyleAttributeName: @(RKUnderlineStyleNone),
								 RKUnderlineStyleAttributeName: @(RKUnderlineStyleNone),
								 RKSuperscriptAttributeName: @(0)};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text shouldn’t have any visible text effects, because they’re explicitely deactivated." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"characterstylewithexplicitdeactiviation"];
}

- (void)testCharacterStyleTemplateWithImplicitDeactivatingStringAttributes
{
	// Character Style
	CTFontRef styleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSString *styleName = @"Style";
	NSDictionary *styleAttributes = @{RKCharacterStyleNameAttributeName: styleName,
									  RKFontAttributeName: (__bridge RKFont *)styleFont,
									  RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0],
									  RKStrokeWidthAttributeName: @1,
									  RKShadowAttributeName: [NSShadow new],
									  RKStrikethroughStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKUnderlineStyleAttributeName: @(RKUnderlineStyleSingle),
									  RKSuperscriptAttributeName: @1};
	
	// String Attributes
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: styleName};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text shouldn’t have any visible text effects, because they’re implicitely deactivated." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"characterstylewithimplicitdeactiviation"];
}

- (void)testLocalizedCharacterStyleName
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Emphasis should read \"Herausstellen\" and Strong should read \"Betont\" in the German localization of Word."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.characterStyles = @{@"Emphasis": @{RKCharacterStyleNameAttributeName: @"Emphasis", RKForegroundColorAttributeName: [RKColor colorWithRed:1 green:0 blue:0.5 alpha:0]},
								 @"Strong": @{RKCharacterStyleNameAttributeName: @"Strong", RKForegroundColorAttributeName: [RKColor colorWithRed:0.5 green:0 blue:1 alpha:0]}};
	
	[self assertDOCX:document withTestDocument:@"localizedcharacterstyle"];
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
	document.paragraphStyles = @{styleName: @{RKParagraphStyleNameAttributeName: styleName, RKParagraphStyleAttributeName: paragraphStyle}};
	
	[self assertDOCX:document withTestDocument:@"paragraphstylewithdeactivatedbasewritingdirection"];
}

- (void)testParagraphStyleTemplateWithIdenticStringAttributes
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 13;
	paragraphStyle.tailIndent = -04;
	paragraphStyle.firstLineHeadIndent = 19;
	paragraphStyle.paragraphSpacingBefore = 20;
	paragraphStyle.paragraphSpacing = 15;
	paragraphStyle.alignment = RKTextAlignmentJustified;
	paragraphStyle.defaultTabInterval = 42;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:42 options:@{}],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentCenter location:123 options:@{}],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:321 options:@{}]];
	
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.headerLevel = 1;
	additionalParagraphStyle.baselineDistance = 29;
	additionalParagraphStyle.keepWithFollowingParagraph = YES;
	additionalParagraphStyle.skipOrphanControl = YES;
	additionalParagraphStyle.hyphenationEnabled = NO;
	
	NSString *styleName = @"Paragraph Style";
	NSDictionary *styleAttributes = @{RKParagraphStyleNameAttributeName: styleName,
									  RKParagraphStyleAttributeName: paragraphStyle,
									  RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	NSDictionary *attributes = [styleAttributes copy];
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should have a paragraph style named \"Paragraph Style\". Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"paragraphstylewithidenticattributes"];
}

- (void)testParagraphStyleTemplateWithOverridingStringAttributes
{
	// Character Style
	NSMutableParagraphStyle *templateParagraphStyle = [NSMutableParagraphStyle new];
	templateParagraphStyle.headIndent = 1;
	templateParagraphStyle.tailIndent = -1;
	templateParagraphStyle.firstLineHeadIndent = 1;
	templateParagraphStyle.paragraphSpacingBefore = 1;
	templateParagraphStyle.paragraphSpacing = 1;
	templateParagraphStyle.alignment = RKTextAlignmentRight;
	templateParagraphStyle.defaultTabInterval = 1;
	templateParagraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:1 options:@{}],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:2 options:@{}],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:3 options:@{}]];
	
	RKAdditionalParagraphStyle *templateAdditionalParagraphStyle = [RKAdditionalParagraphStyle new];
	templateAdditionalParagraphStyle.headerLevel = 1;
	templateAdditionalParagraphStyle.baselineDistance = 1;
	templateAdditionalParagraphStyle.keepWithFollowingParagraph = YES;
	templateAdditionalParagraphStyle.skipOrphanControl = YES;
	templateAdditionalParagraphStyle.hyphenationEnabled = YES;
	
	NSString *styleName = @"Style";
	NSDictionary *styleAttributes = @{RKParagraphStyleNameAttributeName: styleName,
									  RKParagraphStyleAttributeName: templateParagraphStyle,
									  RKAdditionalParagraphStyleAttributeName: templateAdditionalParagraphStyle};
	
	// String Attributes
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 10;
	paragraphStyle.tailIndent = -10;
	paragraphStyle.firstLineHeadIndent = 10;
	paragraphStyle.paragraphSpacingBefore = 10;
	paragraphStyle.paragraphSpacing = 10;
	paragraphStyle.alignment = RKTextAlignmentCenter;
	paragraphStyle.defaultTabInterval = 10;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:10 options:@{}],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:20 options:@{}],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:30 options:@{}]];
	
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.headerLevel = 6;
	additionalParagraphStyle.baselineDistance = 10;
	additionalParagraphStyle.keepWithFollowingParagraph = NO;
	additionalParagraphStyle.skipOrphanControl = NO;
	additionalParagraphStyle.hyphenationEnabled = NO;
	
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: styleName,
								 RKParagraphStyleAttributeName: paragraphStyle,
								 RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This paragraph overrides all template style settings. Point values of the paragraph style are set to a 10 times value of the paragraph template. Alignment is set to center. Boolean settings have been inverted. Please see the test method implementation for further details." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	document.paragraphStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"paragraphstyletemplateoverride"];
}

- (void)testParagraphStyleTemplateWithImplicitDeactivatingStringAttributes
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 1;
	paragraphStyle.tailIndent = -1;
	paragraphStyle.firstLineHeadIndent = 2;
	paragraphStyle.paragraphSpacingBefore = 1;
	paragraphStyle.paragraphSpacing = 1;
	paragraphStyle.alignment = RKTextAlignmentRight;
	paragraphStyle.defaultTabInterval = 1;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:1 options:@{}],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:2 options:@{}],
										[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:3 options:@{}]];
	
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.headerLevel = 1;
	additionalParagraphStyle.baselineDistance = 1;
	additionalParagraphStyle.keepWithFollowingParagraph = YES;
	additionalParagraphStyle.skipOrphanControl = YES;
	additionalParagraphStyle.hyphenationEnabled = NO;
	
	NSString *styleName = @"Style";
	NSDictionary *styleAttributes = @{RKParagraphStyleNameAttributeName: styleName,
									  RKParagraphStyleAttributeName: paragraphStyle,
									  RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: styleName};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"The string attributes of this paragraph should be set to default values. Please see the test method implementation for further details." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	document.paragraphStyles = @{styleName: styleAttributes};
	
	[self assertDOCX:document withTestDocument:@"paragraphstylewithimplicitdeactiviation"];
}

- (void)testLocalizedParagraphStyleName
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Heading 1 should read \"Überschrift 1\" and Heading 2 should read \"Überschrift 2\" in the German localization of Word."];
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = RKTextAlignmentCenter;
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{@"heading 1": @{RKParagraphStyleNameAttributeName: @"heading 1", RKParagraphStyleAttributeName: paragraphStyle},
								 @"heading 2": @{RKParagraphStyleNameAttributeName: @"heading 2", RKForegroundColorAttributeName: [RKColor colorWithRed:0.5 green:0 blue:1 alpha:0]}};
	
	[self assertDOCX:document withTestDocument:@"localizedparagraphstyle"];
}


#pragma mark - Default style

- (void)testDefaultStyle
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 13;
	paragraphStyle.tailIndent = -04;
	paragraphStyle.firstLineHeadIndent = 19;
	paragraphStyle.paragraphSpacingBefore = 20;
	paragraphStyle.paragraphSpacing = 15;
	paragraphStyle.alignment = RKTextAlignmentJustified;
	paragraphStyle.defaultTabInterval = 42;
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:42 options:@{}],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentCenter location:123 options:@{}],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:321 options:@{}]];
	
	NSDictionary *attributes = @{RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait),
								 RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This document uses a default style in its styles.xml file." attributes:attributes];
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.defaultStyle = [attributes copy];
	
	[self assertDOCX:document withTestDocument:@"defaultstyle"];
}


#pragma mark - Mixed styles

- (void)testOverriddenCharacterAttributesInParagraphStyle
{
	// Paragraph Style
	CTFontRef paragraphStyleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSString *paragraphStyleName = @"heading 1";
	NSDictionary *paragraphStyleAttributes = @{RKParagraphStyleNameAttributeName: paragraphStyleName,
											   RKFontAttributeName: (__bridge RKFont *)paragraphStyleFont,
											   RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	
	// Character Style
	CTFontRef characterStyleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSString *characterStyleName = @"Strong";
	NSDictionary *characterStyleAttributes = @{RKCharacterStyleNameAttributeName: characterStyleName,
											   RKFontAttributeName: (__bridge RKFont *)characterStyleFont,
											   RKFontMixAttributeName: @(RKFontMixIgnoreFontName | RKFontMixIgnoreBoldTrait)};
	
	// String
	NSDictionary *attributes = @{RKParagraphStyleNameAttributeName: paragraphStyleName,
								 RKCharacterStyleNameAttributeName: characterStyleName,
								 RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait),
								 RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0.5 blue:1 alpha:0]};
	
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text is displayed in blue Arial font with 12pt size, bold and italic, although the character style is set to Helvetica." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.paragraphStyles = @{paragraphStyleName: paragraphStyleAttributes};
	document.characterStyles = @{characterStyleName: characterStyleAttributes};
	
	[self assertDOCX:document withTestDocument:@"mixedstyletemplateoverride"];
}

- (void)testOverriddenStringAttributesInCharacterStyle
{
	// Character Style
	CTFontRef characterStyleFont = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Times New Roman", 24, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontItalicTrait | kCTFontBoldTrait);
	NSString *characterStyleName = @"Strong";
	NSDictionary *characterStyleAttributes = @{RKCharacterStyleNameAttributeName: characterStyleName, RKFontAttributeName: (__bridge RKFont *)characterStyleFont};
	
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
	
	[self assertDOCX:document withTestDocument:@"mixedstringstyleoverride"];
}

- (void)testStyleTemplateVisibility
{
	NSDictionary *styles = @{@"always": @{RKStyleTemplateVisibilityAttributeName: @(RKStyleTemplateVisibilityAlways)},
							 @"when-used": @{RKStyleTemplateVisibilityAttributeName: @(RKStyleTemplateVisibilityWhenUsed)},
							 @"never": @{RKStyleTemplateVisibilityAttributeName: @(RKStyleTemplateVisibilityNever)}};
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: [[NSAttributedString alloc] initWithString: @"The small styles selection in the menu bar should only show two \"always\" styles. The styles \"when-used\" and \"never\" are only visible in the file itself."]];
	document.characterStyles = [styles copy];
	document.paragraphStyles = [styles copy];
	
	[self assertDOCX:document withTestDocument:@"templatevisibility"];
}

- (void)testNonexistentStyles
{
	NSDictionary *attributes = @{RKCharacterStyleNameAttributeName: @"Character Style", RKParagraphStyleNameAttributeName: @"Paragraph Style"};
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: [[NSAttributedString alloc] initWithString:@"This text should not have any styles associated with it, because there are no styles written to the styles.xml file." attributes:attributes]];
	
	[self assertDOCX:document withTestDocument:@"nonexistentstyles"];
}

@end
