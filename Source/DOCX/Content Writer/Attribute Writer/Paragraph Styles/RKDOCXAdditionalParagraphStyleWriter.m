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
	RKAdditionalParagraphStyle *paragraphStyle = attributes[RKAdditionalParagraphStyleAttributeName];
	RKAdditionalParagraphStyle *templateParagraphStyle = context.document.paragraphStyles[attributes[RKParagraphStyleNameAttributeName]][RKAdditionalParagraphStyleAttributeName];
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Keep With following (§17.3.1.15)
	if (paragraphStyle.keepWithFollowingParagraph != templateParagraphStyle.keepWithFollowingParagraph) {
		NSXMLElement *keepNextElement = [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleKeepNextElementName];
		if (!paragraphStyle.keepWithFollowingParagraph)
			[keepNextElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
		
		[properties addObject: keepNextElement];
	}
	
	// Skip Orphan Control (§17.3.1.44)
	if (paragraphStyle.skipOrphanControl != templateParagraphStyle.skipOrphanControl) {
		NSXMLElement *widowControlElement = [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleOrphanControlElementName];
		if (paragraphStyle.skipOrphanControl)
			[widowControlElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAdditionalParagraphStyleOrphanControlOffAttributeValue]];
		
		[properties addObject: widowControlElement];
	}
	
	// Hyphenation (§17.3.1.34)
	if (context.document.hyphenationEnabled)
		if ((templateParagraphStyle || !paragraphStyle.hyphenationEnabled) && (!templateParagraphStyle || paragraphStyle.hyphenationEnabled != templateParagraphStyle.hyphenationEnabled)) {
			NSXMLElement *suppressAutoHyphensElement = [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleSuppressHyphenationElementName];
			if (paragraphStyle.hyphenationEnabled && paragraphStyle)
				[suppressAutoHyphensElement addAttribute: [NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAttributeWriterOffAttributeValue]];
			
			[properties addObject: suppressAutoHyphensElement];
		}
	
	return properties;
}

@end
