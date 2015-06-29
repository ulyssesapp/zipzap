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
	
	// Perform font substitution of certain characters, since Word doesn't support font substitution properly
	NSMutableAttributedString *fixedString = [[NSMutableAttributedString alloc] initWithAttributedString: attributedString];
	[fixedString fixAttributesInRange: NSMakeRange(0, fixedString.length)];
	
	// Perform translation
	[fixedString.string enumerateSubstringsInRange:NSMakeRange(0, fixedString.length) options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[fixedString.string rk_enumerateTokensWithDelimiters:pageBreakCharacterSet inRange:substringRange usingBlock:^(NSRange tokenRange, unichar delimiter) {
			// Add paragraph, if any
			if (tokenRange.length > 0)
				[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementFromAttributedString:fixedString inRange:tokenRange usingContext:context]];
			// Add paragraph, if empty
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
