//
//  RKDOCXAttributedStringWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"

#import "RKDOCXRunAttributeWriter.h"

NSString *RKDOCXAttributeWriterParagraphElementName	= @"w:p";


@implementation RKDOCXAttributedStringWriter

+ (NSArray *)processAttributedString:(NSAttributedString *)attributedString
{
	NSMutableArray *paragraphs = [NSMutableArray new];
	
	[attributedString.string enumerateSubstringsInRange:NSMakeRange(0, attributedString.length) options:NSStringEnumerationByParagraphs usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
		[paragraphs addObject: [self paragraphWithProperties:nil runElements:[self runElementsFromAttributedString:attributedString inRange:substringRange]]];
	}];
	
	return paragraphs;
}

+ (NSXMLElement *)paragraphWithProperties:(NSXMLElement *)propertiesElement runElements:(NSArray *)runElements
{
	NSParameterAssert(runElements.count);
	
	NSXMLElement *paragraph = [NSXMLElement elementWithName: RKDOCXAttributeWriterParagraphElementName];
	
	if (propertiesElement)
		[paragraph addChild: propertiesElement];
	
	for (NSXMLElement *runElement in runElements) {
		[paragraph addChild: runElement];
	}
	
	return paragraph;
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
