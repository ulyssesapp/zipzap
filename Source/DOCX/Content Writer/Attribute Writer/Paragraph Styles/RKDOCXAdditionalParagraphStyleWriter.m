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
	if (!paragraphStyle)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Keep With following (§17.3.1.15)
	if (paragraphStyle.keepWithFollowingParagraph)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleKeepNextElementName]];
	
	// Skip Orphan Control (§17.3.1.44)
	if (paragraphStyle.skipOrphanControl)
		[properties addObject: [NSXMLElement elementWithName:RKDOCXAdditionalParagraphStyleOrphanControlElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXAttributeWriterValueAttributeName stringValue:RKDOCXAdditionalParagraphStyleOrphanControlOffAttributeValue]]]];
	
	// Hyphenation (§17.3.1.34)
	if (context.document.hyphenationEnabled && (!paragraphStyle.hyphenationEnabled || paragraphStyle.hyphenationEnabled == NO))
		[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleSuppressHyphenationElementName]];
	
	return properties;
}

@end
