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
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"footnote"];
}

@end
