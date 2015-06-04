//
//  RKDOCXFootnotesWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXFootnotesWriterTest : XCTestCase

@end

@implementation RKDOCXFootnotesWriterTest

- (void)testAttributedStringWithFootnote
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Footnote Test"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString:@"This is the content of the footnote."]}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnote"];
}

- (void)testAttributedStringWithEndnote
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Endnote Test"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKEndnoteAttributeName: [[NSAttributedString alloc] initWithString:@"This is the content of the endnote."]}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"endnote"];
}

- (void)testAttributedStringWithFootnoteAndEndnote
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Footnote\ufffc and Endnote\ufffc Test"];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString:@"This is the footnote content."] range:NSMakeRange(8, 1)];
	[attributedString addAttribute:RKEndnoteAttributeName value:[[NSAttributedString alloc] initWithString:@"This is the endnote content."] range:NSMakeRange(21, 1)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnoteandendnote"];
}

- (void)testAttributedStringWithTwoFootnotes
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Test\ufffc with two footnotes\ufffc"];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString:@"This is the first footnote content."] range:NSMakeRange(4, 1)];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString:@"This is the second footnote content."] range:NSMakeRange(24, 1)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"twofootnotes"];
}

- (void)testFootnoteWithLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Footnote Test"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: [[NSAttributedString alloc] initWithString:@"This is a link inside a footnote." attributes:@{RKLinkAttributeName: [NSURL URLWithString: @"http://example.org/"]}]}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnotewithlink"];
}

- (void)testFootnoteWithImage
{
	NSURL *imageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"image" withExtension:@"png" subdirectory:@"Test Data/resources"];
	RKImageAttachment *imageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:imageURL options:0 error:NULL] margin:RKEdgeInsetsMake(0, 0, 0, 0)];
	NSMutableAttributedString *footnoteString = [[NSMutableAttributedString alloc] initWithString:@"This is an image inside a footnote: "];
	[footnoteString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKImageAttachmentAttributeName: imageAttachment}]];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Footnote Test"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKFootnoteAttributeName: footnoteString}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"footnotewithimage"];
}

@end
