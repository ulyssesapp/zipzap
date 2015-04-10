//
//  RKDOCXAdditionalParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 10.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAdditionalParagraphStyleWriter.h"

NSString *RKDOCXAdditionalParagraphStyleKeepNextPropertyName	= @"w:keepNext";
NSString *RKDOCXAdditionalParagraphStyleSuppressHyphenationName	= @"w:suppressAutoHyphens";


@implementation RKDOCXAdditionalParagraphStyleWriter

+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	RKAdditionalParagraphStyle *paragraphStyle = attributes[RKAdditionalParagraphStyleAttributeName];
	
	if (!paragraphStyle)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Keep With following
	if (paragraphStyle.keepWithFollowingParagraph)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleKeepNextPropertyName]];
	
	// Hyphenation (Needs to be the last setting!)
	if (!context.document.hyphenationEnabled)
		return properties;
	
	if (!paragraphStyle.hyphenationEnabled || paragraphStyle.hyphenationEnabled == NO)
		[properties addObject: [NSXMLElement elementWithName: RKDOCXAdditionalParagraphStyleSuppressHyphenationName]];
	
	return properties;
}

@end
