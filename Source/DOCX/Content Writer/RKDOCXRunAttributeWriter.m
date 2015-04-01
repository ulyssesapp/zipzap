//
//  RKDOCXRunAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"

#import "RKDOCXFontAttributeWriter.h"


// Element names
NSString *RKDOCXRunAttributeRunElementName				= @"w:r";
NSString *RKDOCXRunAttributeRunPropertiesElementName	= @"w:rPr";
NSString *RKDOCXRunAttributeTextElementName				= @"w:t";

@implementation RKDOCXRunAttributeWriter

+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range
{
	// Check for invalid range
	NSParameterAssert(NSMaxRange(range) <= attributedString.length);
	
//	NSMutableArray *properties = [NSMutableArray new];
//	
//	// Collect all matching attributes
//	[properties addObjectsFromArray: [RKDOCXFontAttributeWriter runPropertiesForAttributes: attributes]];
//	// ...
//	
//	NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName:RKDOCXRunAttributeRunPropertiesElementName children:properties attributes:nil];
//	
	return nil;
}

@end
