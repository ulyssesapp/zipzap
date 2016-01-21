//
//  RKDOCXLinkWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXLinkWriter.h"

#import "RKDOCXRelationshipsWriter.h"

// Elements
NSString *RKDOCXDeletedInstructionTextElementName	= @"w:delInstrText";
NSString *RKDOCXFieldCharElementName				= @"w:fldChar";
NSString *RKDOCXInstructionTextElementName			= @"w:instrText";
NSString *RKDOCXLinkHyperlinkElementName			= @"w:hyperlink";

// Attributes
NSString *RKDOCXFieldCharTypeAttributeName			= @"w:fldCharType";
NSString *RKDOCXLinkTargetAttributeName				= @"r:id";

// Attribute Values
NSString *RKDOCXFieldCharTypeBeginAttributeValue	= @"begin";
NSString *RKDOCXFieldCharTypeEndAttributeValue		= @"end";
NSString *RKDOCXFieldCharTypeSeparateAttributeValue	= @"separate";

// Keys
NSString *RKDOCXFieldLinkFirstPartKey				= @"RKDOCXFieldLinkFirstPart";
NSString *RKDOCXFieldLinkLastPartKey				= @"RKDOCXFieldLinkLastPart";

@implementation RKDOCXLinkWriter

+ (NSArray *)runElementsForLinkAttribute:(id)linkAttribute runType:(RKDOCXRunType)runType runElements:(NSArray *)runElements usingContext:(RKDOCXConversionContext *)context
{
	if (!linkAttribute)
		return runElements;
	
	NSAssert([linkAttribute isKindOfClass: NSURL.class] || [linkAttribute isKindOfClass: NSString.class], @"linkAttribute has invalid class type '%@'.", NSStringFromClass([linkAttribute class]));
	
	NSString *target = [linkAttribute isKindOfClass: NSString.class] ? linkAttribute : [linkAttribute absoluteString];
	
	NSMutableArray *linkRunElements = [NSMutableArray new];
	
	if (runType == RKDOCXRunStandardType) {
		NSUInteger targetIdentifier = [context indexForRelationshipWithTarget:target andType:RKDOCXLinkRelationshipType];
		
		NSXMLElement *targetAttribute = [NSXMLElement attributeWithName:RKDOCXLinkTargetAttributeName stringValue:[NSString stringWithFormat: @"rId%lu", targetIdentifier]];
		
		[linkRunElements addObject: [NSXMLElement elementWithName:RKDOCXLinkHyperlinkElementName children:runElements attributes:@[targetAttribute]]];
	}
	else if (runType == RKDOCXRunDeletedType || runType == RKDOCXRunInsertedType) {
		
		// Add first link parts
		[linkRunElements addObjectsFromArray: @[
												[RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXFieldCharElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFieldCharTypeAttributeName stringValue:RKDOCXFieldCharTypeBeginAttributeValue]]] usingContext:context],
												[RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:(runType == RKDOCXRunDeletedType ? RKDOCXDeletedInstructionTextElementName : RKDOCXInstructionTextElementName) stringValue:[NSString stringWithFormat: @"HYPERLINK \"%@\"", target]] usingContext:context],
												[RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXFieldCharElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFieldCharTypeAttributeName stringValue:RKDOCXFieldCharTypeSeparateAttributeValue]]] usingContext:context]
												]];
		
		// Add main run parts
		[linkRunElements addObjectsFromArray: runElements];
		
		// Add last link part
		[linkRunElements addObject: [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXFieldCharElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFieldCharTypeAttributeName stringValue:RKDOCXFieldCharTypeEndAttributeValue]]] usingContext:context]];
	}
	
	return linkRunElements.count ? linkRunElements : runElements;
}

@end
