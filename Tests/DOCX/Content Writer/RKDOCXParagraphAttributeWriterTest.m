//
//  RKDOCXParagraphAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphAttributeWriter.h"
#import "XCTestCase+DOCX.h"


@interface RKDOCXParagraphAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXParagraphAttributeWriterTest

- (void)testParagraphElementWithBaseWritingDirectionAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Base Writing Direction Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"basewritingdirection"];
}

- (void)testParagraphElementWithHeadAndTailIndentationAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.headIndent = 19;
	paragraphStyle.tailIndent = 29;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Head and Tail Indentation Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"headandtailindent"];
}

- (void)testParagraphElementWithFirstLineHeadIndentationAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.firstLineHeadIndent = 13;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"First Line Head Indentation Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"firstlineheadindent"];
}

- (void)testParagraphElementWithLeftAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = RKTextAlignmentLeft;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Left Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"leftalignment"];
}

- (void)testParagraphElementWithCenterAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = RKTextAlignmentCenter;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Center Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"centeralignment"];
}

- (void)testParagraphElementWithRightAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = RKTextAlignmentRight;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Right Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"rightalignment"];
}

- (void)testParagraphElementWithJustifiedAlignmentAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = RKTextAlignmentJustified;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Justified Alignment Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"justifiedalignment"];
}

- (void)testParagraphElementWithSpacingAttribute
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineSpacing = 15;
	paragraphStyle.paragraphSpacingBefore = 48;
	paragraphStyle.paragraphSpacing = 48;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Spacing Test (Line Spacing: 15pt, Paragraph Spacing Before/After: 48pt): Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"spacing"];
}

- (void)testParagraphElementWithCustomTabStops
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.tabStops = @[[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:42 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentCenter location:123 options:0],
								[[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentRight location:321 options:0]];
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Custom Tab Stop Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"tabstops"];
}

- (void)testParagraphElementWithDefaultTabInterval
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.defaultTabInterval = 8;
	NSDictionary *attributes = @{RKParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Custom Tab Stop Test: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est.\tLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.\tAt vero eos et accusam et justo duo dolores et ea rebum.\tStet clita kasd gubergren, no sea takimata sanctus est." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"defaulttabinterval"];
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
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"keepwithfollowing"];
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
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString: @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est.\n" attributes:attributes]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"orphancontrol"];
}

- (void)testParagraphElementWithHyphenationAttribute
{
	RKAdditionalParagraphStyle *paragraphStyle = [RKAdditionalParagraphStyle new];
	paragraphStyle.hyphenationEnabled = YES;
	NSDictionary *attributes = @{RKAdditionalParagraphStyleAttributeName: paragraphStyle};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hyphenation Test: You never know true beauty until you see Earth from space, or true terror until you hear someone knocking on the space station door from outside. You look through the porthole and see an astronaut, but all your crew is inside and accounted for. You use the comm to ask who it is and he says he’s Ramirez returning from a repair mission, but Ramirez is sitting right next to you in the command module and he’s just as confused as you are. When you tell the guy this over the radio he starts banging on the door louder and harder, begging you to let him in, saying he’s the real Ramirez. Meanwhile, the Ramirez inside with you is pleading to keep the airlock shut. It really puts life on Earth into perspective." attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"hyphenation"];
}

@end
