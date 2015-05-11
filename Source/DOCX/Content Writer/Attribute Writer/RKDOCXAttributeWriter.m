//
//  RKDOCXAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 10.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributeWriter.h"

// Common attribute name
NSString *RKDOCXAttributeWriterOffAttributeValue	= @"0";
NSString *RKDOCXAttributeWriterValueAttributeName	= @"w:val";

@implementation RKDOCXAttributeWriter

- (id)init
{
	NSAssert(false, @"Abstract class.");
	
	return nil;
}

+ (BOOL)shouldTranslateAttributeWithName:(NSString *)attributeName fromAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isCharacterStyle:(BOOL)isCharacterStyle
{
	id attributeValue = attributes[attributeName];
	id styleValue = isCharacterStyle ? context.document.characterStyles[attributes[RKCharacterStyleNameAttributeName]][attributeName] : context.document.paragraphStyles[attributes[RKParagraphStyleNameAttributeName]][attributeName];
	
	// No translation is performed if string attributes and style attributes are the same. (I.e. have the same value or are both set to nil.)
	return !((attributeValue == styleValue) || [attributeValue isEqual: styleValue]);
}

@end
