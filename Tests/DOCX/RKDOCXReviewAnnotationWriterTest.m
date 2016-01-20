//
//  RKDOCXReviewAnnotationWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.01.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKDOCXParagraphWriter.h"

@interface RKDOCXReviewAnnotationWriterTest : XCTestCase

@end

@implementation RKDOCXReviewAnnotationWriterTest

- (void)testParagraphWithDeletedText
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should be marked as deleted." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeDeletion)}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"deleted"];
}

- (void)testParagraphWithDeletedLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is a deleted link." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeDeletion)}];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString: @"http://example.org/"] range:NSMakeRange(18, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"deletedlink"];
}

- (void)testParagraphWithInsertedText
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should be marked as inserted." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeInsertion)}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"inserted"];
}

- (void)testParagraphWithInsertedLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is an inserted link." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeInsertion)}];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString: @"http://example.org/"] range:NSMakeRange(20, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"insertedlink"];
}

- (void)testParagraphWithComment
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text has been commented on." attributes:@{RKReviewCommentAttributeName: [[NSAttributedString alloc] initWithString: @"This is the comment."]}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"comment"];
}

- (void)testParagraphWithLinkInCommentedLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"The comment of this link contains a link." attributes:@{RKReviewCommentAttributeName: [[NSAttributedString alloc] initWithString:@"Link" attributes:@{RKLinkAttributeName: [NSURL URLWithString: @"http://example.com/"]}]}];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString: @"http://example.org/"] range:NSMakeRange(20, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"commentlink"];
}

- (void)testParagraphWithCommentedInsertion
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text has been inserted and commented on." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeInsertion), RKReviewCommentAttributeName: [[NSAttributedString alloc] initWithString: @"This is the comment."]}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"commentedinsertion"];
}

@end
