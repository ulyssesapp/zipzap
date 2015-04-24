//
//  RKDOCXParagraphAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphWriter.h"

#import "RKDOCXAdditionalParagraphStyleWriter.h"
#import "RKDOCXLinkWriter.h"
#import "RKDOCXParagraphStyleWriter.h"
#import "RKDOCXPlaceholderWriter.h"
#import "RKDOCXRunWriter.h"

NSString *RKDOCXParagraphElementName			= @"w:p";
NSString *RKDOCXParagraphPropertiesElementName	= @"w:pPr";

@implementation RKDOCXParagraphWriter

+ (NSXMLElement *)paragraphElementFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *paragraphElement = [NSXMLElement elementWithName: RKDOCXParagraphElementName];
	
	NSXMLElement *propertiesElement = [self paragraphPropertiesElementWithPropertiesFromAttributedString:attributedString inRange:paragraphRange usingContext:context];
	if (propertiesElement)
		[paragraphElement addChild: propertiesElement];
	
	NSArray *runElements = [self runElementsFromAttributedString:attributedString inRange:paragraphRange usingContext:context];
	NSParameterAssert(runElements.count);
	for (NSXMLElement *runElement in runElements) {
		[paragraphElement addChild: runElement];
	}
	
	return paragraphElement;
}

+ (NSXMLElement *)paragraphPropertiesElementWithPropertiesFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *properties = [NSMutableArray new];
	
	[attributedString enumerateAttributesInRange:paragraphRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		[properties addObjectsFromArray: [RKDOCXParagraphStyleWriter propertyElementsForAttributes:attrs usingContext:context]];
		[properties addObjectsFromArray: [RKDOCXAdditionalParagraphStyleWriter propertyElementsForAttributes:attrs usingContext:context]];
	}];
	
	if (properties.count > 0)
		return [NSXMLElement elementWithName:RKDOCXParagraphPropertiesElementName children:properties attributes:nil];
	
	return nil;
}

+ (NSArray *)runElementsFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *runElements = [NSMutableArray new];
	
	[attributedString enumerateAttribute:RKLinkAttributeName inRange:paragraphRange options:0 usingBlock:^(id value, NSRange linkRange, BOOL *stop) {
		NSXMLElement *linkElement = [RKDOCXLinkWriter linkElementForAttribute:value usingContext:context];
		NSMutableArray *linkChildren = [NSMutableArray new];
		
		// If there is a link attribute, add the runs as children to the parent link element.
		[attributedString enumerateAttributesInRange:linkRange options:0 usingBlock:^(NSDictionary *attrs, NSRange runRange, BOOL *stop) {
			NSArray *innerRunElements = [RKDOCXRunWriter runElementsForAttributedString:attributedString attributes:attrs range:runRange usingContext:context];
			
			if (linkElement)
				[linkChildren addObjectsFromArray: innerRunElements];
			else
				[runElements addObjectsFromArray: innerRunElements];
		}];
		if (linkElement) {
			linkElement.children = linkChildren;
			[runElements addObject: linkElement];
		}
	}];
	
	return runElements;
}

+ (NSXMLElement *)paragraphElementWithPageBreak
{
	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:@[[RKDOCXPlaceholderWriter runElementWithSymbolicCharacter: RKDOCXPageBreakCharacter]] attributes:nil];
}

@end
