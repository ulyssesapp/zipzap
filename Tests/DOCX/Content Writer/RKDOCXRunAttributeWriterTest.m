//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"
#import "XCTestCase+DOCX.h"


@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

- (void)testRunElementWithFontSizeAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:0 weight:0 size:42];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"fontsize"];
}

- (void)testRunElementWithFontNameAttribute
{
	NSFont *font = [NSFont fontWithName:@"Papyrus" size:12];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"fontname"];
}

- (void)testRunElementWithBoldItalicFontNameAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Arial" traits:(NSBoldFontMask | NSItalicFontMask) weight:0 size:12];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attributes];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"bold-italic-fontname"];
}

@end
