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

+ (NSXMLElement *)linkElementForAttribute:(id)linkAttribute usingContext:(RKDOCXConversionContext *)context
{
	if (!linkAttribute)
		return nil;

	NSAssert([linkAttribute isKindOfClass: NSURL.class] || [linkAttribute isKindOfClass: NSString.class], @"linkAttribute has invalid class type '%@'.", NSStringFromClass([linkAttribute class]));
	
	NSString *target = [linkAttribute isKindOfClass: NSString.class] ? linkAttribute : [linkAttribute absoluteString];
	
	NSUInteger targetIdentifier;
	
	switch (context.currentRelationshipContext) {
		case RKDOCXRelationshipDocumentSource:
			targetIdentifier = [context indexForDocumentRelationshipWithTarget:target andType:RKDOCXLinkRelationshipType];
			break;
			
		case RKDOCXRelationshipEndnoteSource:
			targetIdentifier = [context indexForEndnoteRelationshipWithTarget:target andType:RKDOCXLinkRelationshipType];
			break;
			
		case RKDOCXRelationshipFootnoteSource:
			targetIdentifier = [context indexForFootnoteRelationshipWithTarget:target andType:RKDOCXLinkRelationshipType];
			break;
	}
	
	NSXMLElement *targetAttribute = [NSXMLElement attributeWithName:RKDOCXLinkTargetAttributeName stringValue:[NSString stringWithFormat: @"rId%lu", targetIdentifier]];
	
	return [NSXMLElement elementWithName:RKDOCXLinkHyperlinkElementName children:nil attributes:@[targetAttribute]];
}

@end
