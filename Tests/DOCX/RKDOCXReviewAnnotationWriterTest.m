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

- (void)testParagraphsWithDeletedText
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should be marked as deleted." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeDeletion)}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"deleted"];
}

- (void)testParagraphsWithDeletedLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is a deleted link." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeDeletion)}];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://example.org/"] range:NSMakeRange(18, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"deletedlink"];
}

- (void)testParagraphsWithInsertedText
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"This text should be marked as inserted." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeInsertion)}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"inserted"];
}

- (void)testParagraphsWithInsertedLink
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is an inserted link." attributes:@{RKReviewAnnotationTypeAttributeName: @(RKReviewAnnotationTypeInsertion)}];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://example.org/"] range:NSMakeRange(20, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"insertedlink"];
}

@end
