//
//  RKDOCXAttributedStringWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXParagraphWriter.h"

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
	
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs|NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		NSUInteger scanLocation = substringRange.location;
		
		do {
			NSRange nextPageBreakRange = [attributedString.string rangeOfCharacterFromSet:pageBreakCharacterSet options:0 range:NSMakeRange(scanLocation, NSMaxRange(substringRange) - scanLocation)];
			
			if (nextPageBreakRange.location == NSNotFound) {
				[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementFromAttributedString:attributedString inRange:NSMakeRange(scanLocation, NSMaxRange(substringRange) - scanLocation) usingContext:context]];
				break;
			}
			
			if (nextPageBreakRange.location > scanLocation)
				[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementFromAttributedString:attributedString inRange:NSMakeRange(scanLocation, nextPageBreakRange.location - scanLocation) usingContext:context]];
			
			[paragraphs addObject: [RKDOCXParagraphWriter paragraphElementWithPageBreak]];
			
			scanLocation = nextPageBreakRange.location + 1;
		} while (scanLocation < NSMaxRange(substringRange));
	}];
	
	return paragraphs;
}

@end
