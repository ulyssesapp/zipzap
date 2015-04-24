//
//  RKDOCXLinkWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"

@interface RKDOCXLinkWriterTest : XCTestCase

@end

@implementation RKDOCXLinkWriterTest

- (void)testLinkAttribute
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @"This is a link."];
	[attributedString addAttribute:RKLinkAttributeName value:[NSURL URLWithString:@"http://example.org/"] range:NSMakeRange(10, 4)];
	[attributedString addAttribute:RKForegroundColorAttributeName value:[RKColor colorWithRed:0 green:0 blue:1 alpha:0] range:NSMakeRange(5, 7)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"link"];
}

@end
