//
//  RKDOCXAdditionalParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 10.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAdditionalParagraphStyleWriter.h"

NSString *RKDOCXAdditionalParagraphStyleKeepNextElementName				= @"w:keepNext";
NSString *RKDOCXAdditionalParagraphStyleOrphanControlElementName		= @"w:widowControl";
NSString *RKDOCXAdditionalParagraphStyleOrphanControlOffAttributeValue	= @"off";
NSString *RKDOCXAdditionalParagraphStyleSuppressHyphenationElementName	= @"w:suppressAutoHyphens";

@implementation RKDOCXAdditionalParagraphStyleWriter

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	if (![self shouldTranslateAttributeWithName:RKAdditionalParagraphStyleAttributeName fromAttributes:attributes usingContext:context isCharacterStyle:NO])
		return nil;
	
	RKAdditionalParagraphStyle *paragraphStyle = attributes[RKAdditionalParagraphStyleAttributeName];
	RKAdditionalParagraphStyle *templateParagraphStyle = context.document.paragraphStyles[attributes[RKParagraphStyleNameAttributeName]][RKAdditionalParagraphStyleAttributeName];
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Keep With following (§17.3.1.15)
	if (paragraphStyle.keepWithFollowingParagraph != templateParagraphStyle.keepWithFollowingParagraph) {
		[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleKeepNextElementName]];
		if (!paragraphStyle.keepWithFollowingParagraph)
			[properties.lastObject addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
	}
	
	// Skip Orphan Control (§17.3.1.44)
	if (paragraphStyle.skipOrphanControl != templateParagraphStyle.skipOrphanControl) {
		[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleOrphanControlElementName]];
		if (paragraphStyle.skipOrphanControl)
			[properties.lastObject addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAdditionalParagraphStyleOrphanControlOffAttributeValue]];
	}
	
	// Hyphenation (§17.3.1.34)
	if (context.document.hyphenationEnabled)
		if ((templateParagraphStyle || !paragraphStyle.hyphenationEnabled) && (!templateParagraphStyle || paragraphStyle.hyphenationEnabled != templateParagraphStyle.hyphenationEnabled)) {
			
//		if (!paragraphStyle || (paragraphStyle.hyphenationEnabled != templateParagraphStyle.hyphenationEnabled && templateParagraphStyle)) {
			[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleSuppressHyphenationElementName]];
			if (paragraphStyle.hyphenationEnabled && paragraphStyle)
				[properties.lastObject addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
		}
	
	return properties;
}

@end
