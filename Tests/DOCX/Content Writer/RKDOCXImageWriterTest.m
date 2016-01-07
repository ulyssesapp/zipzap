//
//  RKDOCXImageWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 15.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXImageWriterTest : XCTestCase

@end

@implementation RKDOCXImageWriterTest

- (void)testPNGImageSupport
{
	NSURL *imageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"image" withExtension:@"png" subdirectory:@"Test Data/resources"];
	RKImageAttachment *imageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:imageURL options:0 error:NULL] title:nil description:nil margin:RKEdgeInsetsMake(0, 0, 0, 0)];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"\ufffc " attributes:@{RKImageAttachmentAttributeName: imageAttachment}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"png"];
}

- (void)testJPGImageSupport
{
	NSURL *imageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"image" withExtension:@"jpg" subdirectory:@"Test Data/resources"];
	RKImageAttachment *imageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:imageURL options:0 error:NULL] title:nil description:nil margin:RKEdgeInsetsMake(0, 0, 0, 0)];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"\ufffc " attributes:@{RKImageAttachmentAttributeName: imageAttachment}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"jpg"];
}

- (void)testLargeImageSupport
{
	NSURL *imageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"large-image" withExtension:@"png" subdirectory:@"Test Data/resources"];
	RKImageAttachment *imageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:imageURL options:0 error:NULL] title:nil description:nil margin:RKEdgeInsetsMake(42, 42, 42, 42)];
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"\ufffc " attributes:@{RKImageAttachmentAttributeName: imageAttachment}];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"largepng"];
}

- (void)testContentTypesWithUppercaseFileExtensions
{
	NSURL *uppercaseImageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"uppercase-image" withExtension:@"PNG" subdirectory:@"Test Data/resources"];
	NSURL *lowercaseImageURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"lowercase-image" withExtension:@"png" subdirectory:@"Test Data/resources"];
	RKImageAttachment *uppercaseImageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:uppercaseImageURL options:0 error:NULL] title:nil description:nil margin:RKEdgeInsetsMake(0, 0, 0, 0)];
	RKImageAttachment *lowercaseImageAttachment = [[RKImageAttachment alloc] initWithFile:[[NSFileWrapper alloc] initWithURL:lowercaseImageURL options:0 error:NULL] title:nil description:nil margin:RKEdgeInsetsMake(0, 0, 0, 0)];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"Uppercase file extension:\n"];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKImageAttachmentAttributeName: uppercaseImageAttachment}]];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString: @"\nLowercase file extension:\n"]];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKImageAttachmentAttributeName: lowercaseImageAttachment}]];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"contenttypenames"];
}

@end
