//
//  RKDOCXParagraphAttributeWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphAttributeWriter.h"

NSString *RKDOCXAttributeWriterParagraphElementName	= @"w:p";


@implementation RKDOCXParagraphAttributeWriter

+ (NSXMLElement *)paragraphElementWithProperties:(NSXMLElement *)propertiesElement runElements:(NSArray *)runElements
{
	NSParameterAssert(runElements.count);
	
	NSXMLElement *paragraph = [NSXMLElement elementWithName: RKDOCXAttributeWriterParagraphElementName];
	
	if (propertiesElement)
		[paragraph addChild: propertiesElement];
	
	for (NSXMLElement *runElement in runElements) {
		[paragraph addChild: runElement];
	}
	
	return paragraph;
}

@end
