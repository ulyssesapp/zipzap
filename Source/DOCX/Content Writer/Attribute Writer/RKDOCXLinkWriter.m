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
	NSXMLElement *linkElement;
	NSDictionary *fieldHyperlinkRuns;
	
	switch (runType) {
		case RKDOCXRunStandardType:
			linkElement = [self.class linkElementForAttribute:linkAttribute usingContext:context];
			
			if (!linkElement)
				return runElements;
			
			linkElement.children = runElements;
			return @[linkElement];
			
		case RKDOCXRunDeletedType:
		case RKDOCXRunInsertedType:
			fieldHyperlinkRuns = [self.class fieldHyperlinkRunElementsForLinkAttribute:linkAttribute runType:runType usingContext:context];
			
			if (!fieldHyperlinkRuns.count)
				return runElements;
			
			NSMutableArray *linkRuns = [NSMutableArray new];
			[linkRuns addObjectsFromArray: fieldHyperlinkRuns[RKDOCXFieldLinkFirstPartKey]];
			[linkRuns addObjectsFromArray: runElements];
			[linkRuns addObject: fieldHyperlinkRuns[RKDOCXFieldLinkLastPartKey]];
			
			return linkRuns;
	}
	
	return runElements;
}

+ (NSXMLElement *)linkElementForAttribute:(id)linkAttribute usingContext:(RKDOCXConversionContext *)context
{
	NSString *target = [self.class targetForLinkAttribute: linkAttribute];
	
	if (!target)
		return nil;
	
	NSUInteger targetIdentifier = [context indexForRelationshipWithTarget:target andType:RKDOCXLinkRelationshipType];
	
	NSXMLElement *targetAttribute = [NSXMLElement attributeWithName:RKDOCXLinkTargetAttributeName stringValue:[NSString stringWithFormat: @"rId%lu", targetIdentifier]];
	
	return [NSXMLElement elementWithName:RKDOCXLinkHyperlinkElementName children:nil attributes:@[targetAttribute]];
}

+ (NSDictionary *)fieldHyperlinkRunElementsForLinkAttribute:(id)linkAttribute runType:(RKDOCXRunType)runType usingContext:(RKDOCXConversionContext *)context
{
	NSString *target = [self.class targetForLinkAttribute: linkAttribute];
	
	if (!target)
		return nil;
	
	NSMutableArray *fieldArray = [NSMutableArray new];
	
	[fieldArray addObject: [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXFieldCharElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFieldCharTypeAttributeName stringValue:RKDOCXFieldCharTypeBeginAttributeValue]]] usingContext:context]];
	[fieldArray addObject: [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:(runType == RKDOCXRunDeletedType ? RKDOCXDeletedInstructionTextElementName : RKDOCXInstructionTextElementName) stringValue:[NSString stringWithFormat: @"HYPERLINK \"%@\"", target]] usingContext:context]];
	[fieldArray addObject: [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXFieldCharElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFieldCharTypeAttributeName stringValue:RKDOCXFieldCharTypeSeparateAttributeValue]]] usingContext:context]];
	
	NSXMLElement *endElement = [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXFieldCharElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFieldCharTypeAttributeName stringValue:RKDOCXFieldCharTypeEndAttributeValue]]] usingContext:context];
	
	return @{RKDOCXFieldLinkFirstPartKey: fieldArray, RKDOCXFieldLinkLastPartKey: endElement};
}

+ (NSString *)targetForLinkAttribute:(id)linkAttribute
{
	if (!linkAttribute)
		return nil;
	
	NSAssert([linkAttribute isKindOfClass: NSURL.class] || [linkAttribute isKindOfClass: NSString.class], @"linkAttribute has invalid class type '%@'.", NSStringFromClass([linkAttribute class]));
	
	return [linkAttribute isKindOfClass: NSString.class] ? linkAttribute : [linkAttribute absoluteString];
}

@end
