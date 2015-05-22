//
//  RKDOCXAttributedStringWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXParagraphWriter.h"

#import "NSString+ParsingConvenience.h"

NSString *RKDOCXPageBreakCharacterName	= @"\f";

@implementation RKDOCXAttributedStringWriter

+ (NSArray *)processAttributedString:(NSAttributedString *)attributedString usingContext:(RKDOCXConversionContext *)context
{
	static NSCharacterSet *pageBreakCharacterSet;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		pageBreakCharacterSet = [NSCharacterSet characterSetWithCharactersInString:RKDOCXPageBreakCharacterName];
	});
	
	NSMutableArray *paragraphs = [NSMutableArray new];
	
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs/*|NSStringEnumerationSubstringNotRequired*/ usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[attributedString.string rk_enumerateTokensWithDelimiters:pageBreakCharacterSet inRange:substringRange usingBlock:^(NSRange tokenRange, unichar delimiter) {
			// Add paragraph, if any
			if (tokenRange.length > 0)
				[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementFromAttributedString:attributedString inRange:tokenRange usingContext:context]];
			else if (delimiter != '\f')
				[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementWithProperties:nil runElements:nil]];
			
			// Add page break, if any
			if (delimiter == '\f')
				[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementWithPageBreak]];
		}];
	}];
	
	return paragraphs;
}

@end
