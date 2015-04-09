//
//  RKDOCXParagraphStyleWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphStyleWriter.h"

NSString *RKDOCXParagraphStyleBaseWritingDirectionPropertyName = @"w:bidi";


@implementation RKDOCXParagraphStyleWriter

+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes
{
	NSParagraphStyle *paragraphStyleAttribute = attributes[RKParagraphStyleAttributeName];
	
	if (!paragraphStyleAttribute)
		return nil;
	
	NSMutableArray *properties = [NSMutableArray new];
	
	// Base Writing Direction
	if (paragraphStyleAttribute.baseWritingDirection == NSWritingDirectionRightToLeft) {
		NSXMLElement *baseWritingDirectionProperty = [NSXMLElement elementWithName: RKDOCXParagraphStyleBaseWritingDirectionPropertyName];
		[properties addObject: baseWritingDirectionProperty];
	}
	
	return properties;
}

@end
