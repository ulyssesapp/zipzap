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
	NSAttributedString *attributedString = [NSAttributedString attributedStringWithReviewMode:RKReviewAnnotationTypeDeletion string:@"This text should be marked as deleted."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"deleted"];
}

- (void)testParagraphsWithDeletedLink
{
	NSMutableAttributedString *attributedString = [[NSAttributedString attributedStringWithReviewMode:RKReviewAnnotationTypeDeletion string:@"This is a deleted link."] mutableCopy];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://example.org/"] range:NSMakeRange(18, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"deletedlink"];
}

- (void)testParagraphsWithInsertedText
{
	NSAttributedString *attributedString = [NSAttributedString attributedStringWithReviewMode:RKReviewAnnotationTypeInsertion string:@"This text should be marked as inserted."];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"inserted"];
}

- (void)testParagraphsWithInsertedLink
{
	NSMutableAttributedString *attributedString = [[NSAttributedString attributedStringWithReviewMode:RKReviewAnnotationTypeInsertion string:@"This is an inserted link."] mutableCopy];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://example.org/"] range:NSMakeRange(20, 4)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"insertedlink"];
}

@end
