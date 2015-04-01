//
//  RKDOCXAttributedStringWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXRunAttributeWriter.h"


@implementation RKDOCXAttributedStringWriter

+ (NSArray *)processAttributedString:(NSAttributedString *)attributedString
{
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		// [self runElementsFromAttributedString:attributedString inRange:substringRange];
	}];
	
	return nil;
}

+ (NSXMLElement *)paragraphWithProperties:(NSXMLElement *)properties runElements:(NSArray *)runElements
{
	return nil;
}

+ (NSArray *)runElementsFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange
{
	NSMutableArray *runElements = [NSMutableArray new];
	
	[attributedString enumerateAttributesInRange:paragraphRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		NSXMLElement *runElement = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attrs range:range];
		[runElements addObject: runElement];
	}];
	
	return runElements;
}

@end
