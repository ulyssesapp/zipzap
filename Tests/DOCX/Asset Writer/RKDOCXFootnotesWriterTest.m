//
//  RKDOCXFootnotesWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKFont.h"

@interface RKDOCXFootnotesWriterTest : XCTestCase

@end

@implementation RKDOCXFootnotesWriterTest

- (void)testAttributedStringWithFootnote
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote Test. If the footnote anchor is formatted as superscript and has a shadow, the test has been successful."];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString: @"This is the content of the footnote."], RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.footnoteAreaAnchorAttributes = @{RKShadowAttributeName: [NSShadow new], RKSuperscriptAttributeName: @1};
	
	[self assertDOCX:document withTestDocument:@"footnote"];
}

- (void)testAttributedStringWithEndnote
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Endnote Test"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKEndnoteAttributeName: [[NSAttributedString alloc] initWithString: @"This is the content of the endnote."], RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"endnote"];
}

- (void)testAttributedStringWithFootnoteAndEndnote
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote\ufffc and Endnote\ufffc Test"];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString: @"This is the footnote content."] range:NSMakeRange(8, 1)];
	[attributedString addAttribute:RKSuperscriptAttributeName value:@1 range:NSMakeRange(8, 1)];
	[attributedString addAttribute:RKEndnoteAttributeName value:[[NSAttributedString alloc] initWithString: @"This is the endnote content."] range:NSMakeRange(21, 1)];
	[attributedString addAttribute:RKSuperscriptAttributeName value:@1 range:NSMakeRange(21, 1)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnoteandendnote"];
}

- (void)testAttributedStringWithTwoFootnotes
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Test\ufffc with two footnotes\ufffc"];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString: @"This is the first footnote content."] range:NSMakeRange(4, 1)];
	[attributedString addAttribute:RKSuperscriptAttributeName value:@1 range:NSMakeRange(4, 1)];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString: @"This is the second footnote content."] range:NSMakeRange(24, 1)];
	[attributedString addAttribute:RKSuperscriptAttributeName value:@1 range:NSMakeRange(24, 1)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"twofootnotes"];
}

- (void)testFootnoteWithInsets
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote Test. The footnote anchor should have an inset of 12pt, the content should have an inset of 24pt."];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString: @"This is the footnote."], RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.footnoteAreaAnchorInset = 12;
	document.footnoteAreaContentInset = 24;
	
	[self assertDOCX:document withTestDocument:@"footnotewithinsets"];
}

- (void)testFootnoteWithoutInsets
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote Test. The footnote anchor and content should have no insets."];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString: @"This is the footnote."], RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnotewithoutinsets"];
}

- (void)testFootnoteWithLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote Test with a link."];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString:@"This is a link inside a footnote." attributes:@{RKLinkAttributeName: [NSURL URLWithString: @"http://example.org/"]}], RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnotewithlink"];
}

- (void)testFootnoteWithImage
{
	NSURL *imageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"image" withExtension:@"png" subdirectory:@"Test Data/resources"];
	RKImageAttachment *imageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:imageURL options:0 error:NULL] title:nil description:nil margin:RKEdgeInsetsMake(0, 0, 0, 0) size:CGSizeZero];
	NSMutableAttributedString *footnoteString = [[NSMutableAttributedString alloc] initWithString: @"This is an image inside a footnote: "];
	[footnoteString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKImageAttachmentAttributeName: imageAttachment, RKSuperscriptAttributeName: @1}]];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote Test"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: footnoteString, RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnotewithimage"];
}

- (void)testFootnoteWithDifferingFontSize
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Footnote Test where Footnotes use a different font size than the default."];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString:@"The indent before this footnote should be 12pt in size. 10pt (the default) would be incorrect." attributes:@{RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 12, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait)}], RKSuperscriptAttributeName: @1}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.defaultStyle = @{RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 10, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait)};
	document.footnoteAreaAnchorAttributes = @{RKFontAttributeName: (__bridge RKFont *)CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Helvetica", 12, NULL), 0.0, NULL, 0, kCTFontItalicTrait | kCTFontBoldTrait)};
	
	[self assertDOCX:document withTestDocument:@"footnotewithdifferingfontsize"];
}

@end
