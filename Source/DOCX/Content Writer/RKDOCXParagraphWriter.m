//
//  RKDOCXParagraphWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphWriter.h"

#import "RKDOCXLinkWriter.h"
#import "RKDOCXListItemWriter.h"
#import "RKDOCXParagraphStyleWriter.h"
#import "RKDOCXPlaceholderWriter.h"
#import "RKDOCXReviewAnnotationWriter.h"
#import "RKDOCXRunWriter.h"
#import "RKDOCXStyleTemplateWriter.h"

NSString *RKDOCXParagraphElementName			= @"w:p";
NSString *RKDOCXParagraphPropertiesElementName	= @"w:pPr";

@implementation RKDOCXParagraphWriter

+ (NSXMLElement *)paragraphElementFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSArray *runElements = [self runElementsFromAttributedString:attributedString inRange:paragraphRange usingContext:context];
	NSArray *propertyElements = [self propertyElementsForAttributes:[attributedString attributesAtIndex:paragraphRange.location effectiveRange:NULL] usingContext:context isDefaultStyle:NO];
	
	return [self paragraphElementWithProperties:propertyElements runElements:runElements];
}

+ (NSXMLElement *)paragraphElementWithProperties:(NSArray *)properties runElements:(NSArray *)runElements
{
	NSMutableArray *paragraphChildren = [NSMutableArray new];
	if (!properties && !runElements)
		return [NSXMLElement elementWithName: RKDOCXParagraphElementName];
	
	if (properties)
		[paragraphChildren addObject: [self paragraphPropertiesElementWithProperties: properties]];
	if (runElements)
		[paragraphChildren addObjectsFromArray: runElements];
	
	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:(paragraphChildren.count != 0) ? paragraphChildren : nil attributes:nil];
}

+ (NSXMLElement *)paragraphPropertiesElementWithProperties:(NSArray *)properties
{
	if (!properties.count)
		return nil;
	
	return [NSXMLElement elementWithName:RKDOCXParagraphPropertiesElementName children:properties attributes:nil];
}

+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context isDefaultStyle:(BOOL)isDefaultStyle
{
	NSMutableArray *properties = [NSMutableArray new];
	
	NSXMLElement *styleReferenceElement = [RKDOCXStyleTemplateWriter paragraphStyleReferenceElementForAttributes:attributes usingContext:context];
	if (styleReferenceElement)
		[properties addObject: styleReferenceElement];
	
	[properties addObjectsFromArray: [RKDOCXListItemWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle]];
	[properties addObjectsFromArray: [RKDOCXParagraphStyleWriter propertyElementsForAttributes:attributes usingContext:context isDefaultStyle:isDefaultStyle]];
	
	if (properties.count > 0)
		return properties;
	
	return nil;
}

+ (NSArray *)runElementsFromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)paragraphRange usingContext:(RKDOCXConversionContext *)context
{
	NSMutableArray *runElements = [NSMutableArray new];
	
	[attributedString enumerateAttribute:RKReviewCommentAttributeName inRange:paragraphRange options:0 usingBlock:^(id commentAttribute, NSRange commentRange, BOOL *stopCommentEnumeration) {
		NSUInteger commentID = NSNotFound;
		
		if (commentAttribute)
			[runElements addObject: [RKDOCXReviewAnnotationWriter startElementForCommentAttribute:commentAttribute withID:&commentID usingContext:context]];
		
		[attributedString enumerateAttribute:RKLinkAttributeName inRange:commentRange options:0 usingBlock:^(id linkAttribute, NSRange linkRange, BOOL *stopLinkEnumeration) {
			[attributedString enumerateAttribute:RKReviewAnnotationTypeAttributeName inRange:linkRange options:0 usingBlock:^(id reviewAnnotationAttribute, NSRange reviewAnnotationRange, BOOL *stopReviewAnnotationEnumeration) {
				RKDOCXRunType runType = RKDOCXRunStandardType;
				NSXMLElement *containerElement;
				
				switch ((RKReviewAnnotationType)[reviewAnnotationAttribute unsignedIntegerValue]) {
					case RKReviewAnnotationTypeDeletion:
						runType = RKDOCXRunDeletedType;
						containerElement = [RKDOCXReviewAnnotationWriter containerElementForDeletedRunsUsingContext: context];
						break;
						
					case RKReviewAnnotationTypeInsertion:
						runType = RKDOCXRunInsertedType;
						containerElement = [RKDOCXReviewAnnotationWriter containerElementForInsertedRunsUsingContext: context];
						break;
						
					case RKReviewAnnotationTypeNone:
						break;
				}
				
				NSMutableArray *localRunElements = [NSMutableArray new];
				
				[attributedString enumerateAttributesInRange:reviewAnnotationRange options:0 usingBlock:^(NSDictionary *attributes, NSRange runRange, BOOL *stopRunEnumeration) {
					[localRunElements addObjectsFromArray: [RKDOCXRunWriter runElementsForAttributedString:attributedString attributes:attributes range:runRange runType:runType usingContext:context]];
				}];
				
				NSArray *childElements = [[RKDOCXLinkWriter runElementsForLinkAttribute:linkAttribute runType:runType runElements:localRunElements usingContext:context] mutableCopy];
				
				if (containerElement) {
					containerElement.children = childElements;
					[runElements addObject: containerElement];
				}
				else
					[runElements addObjectsFromArray: childElements];
			}];
		}];
		
		if (commentID != NSNotFound)
			[runElements addObjectsFromArray: [RKDOCXReviewAnnotationWriter endElementsForCommentID:commentID usingContext:context]];
	}];

	return runElements;
}

+ (NSXMLElement *)paragraphElementWithPageBreak
{
	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:@[[RKDOCXPlaceholderWriter runElementWithSymbolicCharacter:RKDOCXPageBreakCharacter attributes:nil usingContext:nil]] attributes:nil];
}

+ (NSXMLElement *)paragraphPropertiesElementForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth
{
	return [self paragraphPropertiesElementWithProperties: @[[RKDOCXParagraphStyleWriter tabSettingsForMarkerLocation:markerLocation markerWidth:markerWidth],
															 [RKDOCXParagraphStyleWriter indentationSettingsForMarkerLocation:markerLocation markerWidth:markerWidth]]];
}

+ (NSXMLElement *)paragraphElementForSeparatorElement:(NSXMLElement *)separatorElement usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *paragraphPropertiesElement = [self paragraphPropertiesElementWithProperties: [RKDOCXParagraphStyleWriter paragraphPropertiesForSeparatorElementUsingContext:context]];
	NSXMLElement *runElement = [RKDOCXRunWriter runElementForAttributes:nil contentElement:separatorElement usingContext:context];

	return [NSXMLElement elementWithName:RKDOCXParagraphElementName children:@[paragraphPropertiesElement, runElement] attributes:nil];
}

@end
