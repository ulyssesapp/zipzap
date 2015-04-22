//
//  RKDOCXParagraphAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphWriter.h"

#import "RKDOCXAdditionalParagraphStyleWriter.h"
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
	
	[attributedString enumerateAttributesInRange:paragraphRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		[runElements addObjectsFromArray: [RKDOCXRunWriter runElementsForAttributedString:attributedString attributes:attrs range:range usingContext:context]];
	}];
	
	return runElements;
}

+ (NSXMLElement *)paragraphElementWithPageBreak
{
	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:@[[RKDOCXRunWriter runElementForAttributes:nil contentElement:[RKDOCXPlaceholderWriter runElementWithBreak: RKDOCXPageBreak] usingContext:nil]] attributes:nil];
}

@end
