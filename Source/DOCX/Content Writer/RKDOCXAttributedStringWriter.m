//
//  RKDOCXAttributedStringWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXParagraphWriter.h"

@implementation RKDOCXAttributedStringWriter

+ (NSArray *)processAttributedString:(NSAttributedString *)attributedString usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *paragraphs = [NSMutableArray new];
	
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		NSXMLElement *paragraph = [RKDOCXParagraphWriter paragraphElementFromAttributedString:attributedString inRange:substringRange usingContext:context];
		[paragraphs addObject: paragraph];
	}];
	
	return paragraphs;
}

@end
