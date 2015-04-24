//
//  RKDOCXLinkWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXLinkWriter.h"

#import "RKDOCXRelationshipsWriter.h"
#import "RKDOCXRunWriter.h"

NSString *RKDOCXLinkHyperlinkElementName	= @"w:hyperlink";
NSString *RKDOCXLinkTargetAttributeName		= @"r:id";

@implementation RKDOCXLinkWriter

+ (NSXMLElement *)linkElementForAttribute:(NSURL *)linkAttribute usingContext:(RKDOCXConversionContext *)context
{
	if (!linkAttribute)
		return nil;
	
	NSXMLElement *targetAttribute = [NSXMLElement attributeWithName:RKDOCXLinkTargetAttributeName stringValue:[NSString stringWithFormat: @"rId%lu", [context indexForRelationshipWithTarget:linkAttribute.absoluteString andType:RKDOCXLinkRelationshipType]]];
	
	return [NSXMLElement elementWithName:RKDOCXLinkHyperlinkElementName children:nil attributes:@[targetAttribute]];
}

@end
