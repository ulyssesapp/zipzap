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
		[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementWithProperties:[RKDOCXParagraphWriter paragraphPropertiesElementWithPropertiesFromAttributedString:attributedString inRange:substringRange usingContext:context] runElements:[RKDOCXParagraphWriter runElementsFromAttributedString:attributedString inRange:substringRange usingContext:context]]];
	}];
	
	return paragraphs;
}

@end
