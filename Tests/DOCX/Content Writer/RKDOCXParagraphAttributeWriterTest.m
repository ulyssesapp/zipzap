//
//  RKDOCXParagraphAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXParagraphAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXParagraphAttributeWriterTest

- (void)testParagraphElementWithDefaultParagraphStyle
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Default Paragraph Style Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:@{RKParagraphStyleAttributeName: [NSParagraphStyle defaultParagraphStyle]}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"default"];
}

- (void)testParagraphElementWithBaseWritingDirectionAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Base Writing Direction Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"basewritingdirection"];
}

- (void)testParagraphElementWithHeadAndTailIndentationAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.headIndent = 19;
	paragraphStyle.tailIndent = -29;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Head and Tail Indentation Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"headandtailindent"];
}

- (void)testParagraphElementWithFirstLineHeadIndentationAttribute
{
	NSMutableParagraphStyle *indentParagraphStyle = [NSMutableParagraphStyle new];
	indentParagraphStyle.firstLineHeadIndent = 13;
	NSDictionary *indentAttributes = @{RKParagraphStyleAttributeName: indentParagraphStyle};
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"First Line Head Indent Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est.\n" attributes:indentAttributes];
	
	NSMutableParagraphStyle *outdentParagraphStyle = [indentParagraphStyle mutableCopy];
	outdentParagraphStyle.headIndent = 26;
	NSDictionary *outdentAttributes = @{RKParagraphStyleAttributeName: outdentParagraphStyle};
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"First Line Head Outdent Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:outdentAttributes]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"firstlineheadindent"];
}

- (void)testParagraphElementWithLeftAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = RKTextAlignmentLeft;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Left Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"leftalignment"];
}

- (void)testParagraphElementWithCenterAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = RKTextAlignmentCenter;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Center Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"centeralignment"];
}

- (void)testParagraphElementWithRightAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = RKTextAlignmentRight;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Right Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"rightalignment"];
}

- (void)testParagraphElementWithJustifiedAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.alignment = RKTextAlignmentJustified;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Justified Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"justifiedalignment"];
}

- (void)testParagraphElementWithSpacingAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	RKAdditionalParagraphStyle *additionalParagraphStyle = [RKAdditionalParagraphStyle new];
	additionalParagraphStyle.baselineDistance = 15;
	paragraphStyle.paragraphSpacingBefore = 48;
	paragraphStyle.paragraphSpacing = 48;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle, RKAdditionalParagraphStyleAttributeName: additionalParagraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Spacing Test (Line Spacing: 15pt, Paragraph Spacing Before/After: 48pt): Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"spacing"];
}

- (void)testParagraphElementWithCustomTabStops
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:42 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentCenter location:123 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:321 options:0]];
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Custom Tab Stop Test:\t\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"tabstops"];
}

- (void)testParagraphElementWithDefaultTabInterval
{
	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.defaultTabInterval = 8;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Default Tab Interval Test:\t\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"defaulttabinterval"];
}

- (void)testParagraphElementWithKeepNextAttribute
{
	RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
	paragraphStyle.keepWithFollowingParagraph = YES;
	NSDictionary *attributes = @{RKAdditionalParagraphStyleAttributeName: paragraphStyle};
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Keep-With-Following Test:"];
	for (NSInteger index = 0; index < 9; index++) {
		[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString: @" Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."]];
	}
	NSString *paragraph = @"\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est.";
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:paragraph attributes:attributes]];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:paragraph]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"keepwithfollowing"];
}

- (void)testParagraphElementWithOrphanControlAttribute
{
	RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
	paragraphStyle.skipOrphanControl = YES;
	NSDictionary *attributes = @{RKAdditionalParagraphStyleAttributeName: paragraphStyle};
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Orphan Control Test: "];
	for (NSInteger index = 0; index < 9; index++) {
		[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString: @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est.\n"]];
	}
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString: @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est." attributes:attributes]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"orphancontrol"];
}

- (void)testParagraphElementWithParagraphDisablingHyphenation
{
	// Start with non-hyphenated paragraph
	RKAdditionalParagraphStyle *nonHyphenatedStyle = [RKAdditionalParagraphStyle new];
	nonHyphenatedStyle.hyphenationEnabled = NO;
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"The following paragraph should NOT be hyphenated: Bundesdonaudampfschifffahrtskapitänsmützenhalterung.\n\n" attributes:@{RKAdditionalParagraphStyleAttributeName: nonHyphenatedStyle}];

	// Add hyphenated paragraph
	RKAdditionalParagraphStyle *hyphenatedStyle = [RKAdditionalParagraphStyle new];
	hyphenatedStyle.hyphenationEnabled = YES;
	
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"The following paragraph should be hyphenated: Bundesdonaudampfschifffahrtskapitänsmützenhalterung." attributes:@{RKAdditionalParagraphStyleAttributeName: hyphenatedStyle}]];
	
	// Allow hyphenation in document
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	
	[self assertDOCX:document withTestDocument:@"hyphenation-disabled-on-paragraph"];
}

- (void)testParagraphElementWithDocumentDisablingHyphenation
{
	// Start with non-hyphenated paragraph
	RKAdditionalParagraphStyle *nonHyphenatedStyle = [RKAdditionalParagraphStyle new];
	nonHyphenatedStyle.hyphenationEnabled = NO;
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"The following paragraph should NOT be hyphenated: Bundesdonaudampfschifffahrtskapitänsmützenhalterung.\n\n" attributes:@{RKAdditionalParagraphStyleAttributeName: nonHyphenatedStyle}];
	
	// Add hyphenated paragraph
	RKAdditionalParagraphStyle *hyphenatedStyle = [RKAdditionalParagraphStyle new];
	hyphenatedStyle.hyphenationEnabled = YES;
	
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"The following paragraph should be also NOT hyphenated: Bundesdonaudampfschifffahrtskapitänsmützenhalterung." attributes:@{RKAdditionalParagraphStyleAttributeName: hyphenatedStyle}]];
	
	// Disable hyphenation completely in document settings
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = NO;
	
	[self assertDOCX:document withTestDocument:@"hyphenation-disabled-on-document"];
}

- (void)testParagraphElementWithPageBreaks
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Page Break Test:\f\fLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\fAt vero eos et accusam et justo duo dolores et ea rebum.\fStet clita kasd gubergren, no sea takimata sanctus est."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"pagebreaks"];
}

- (void)testParagraphElementWithLineBreaks
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"Line Break Test:%C%CTwo line breaks above this line.%COne line break above this line.", RKLineSeparatorCharacter, RKLineSeparatorCharacter, RKLineSeparatorCharacter]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"linebreaks"];
}

- (void)testEmptyParagraphs
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"There are three empty paragraphs below this one.\n\n\n\nAgain, there should be three empty paragraphs above this one."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"emptyparagraphs"];
}

@end
