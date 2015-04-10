//
//  RKDOCXParagraphAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphAttributeWriter.h"

#import "RKDOCXParagraphStyleWriter.h"
#import "RKDOCXTabStopWriter.h"
#import "RKDOCXAdditionalParagraphStyleWriter.h"

NSString *RKDOCXParagraphAttributeParagraphPropertiesElementName = @"w:pPr";


@implementation RKDOCXParagraphAttributeWriter

+ (NSXMLElement *)paragraphPropertiesElementWithPropertiesFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange
{
	NSMutableArray *properties = [NSMutableArray new];
	
	[attributedString enumerateAttributesInRange:paragraphRange options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		[properties addObjectsFromArray: [RKDOCXParagraphStyleWriter paragraphPropertiesForAttributes: attrs]];
		[properties addObjectsFromArray: [RKDOCXTabStopWriter paragraphPropertiesForAttributes: attrs]];
		[properties addObjectsFromArray: [RKDOCXAdditionalParagraphStyleWriter paragraphPropertiesForAttributes: attrs]];
	}];
	
	if (properties.count > 0)
		return [NSXMLElement elementWithName:RKDOCXParagraphAttributeParagraphPropertiesElementName children:properties attributes:nil];
	
	return nil;
}

@end
