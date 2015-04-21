//
//  RKDOCXPlaceholderWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

extern NSString *RKDOCXBreakAttributeName;

typedef enum : NSUInteger {
	RKDOCXNoBreak	= 0,
	RKDOCXLineBreak	= 1,
	RKDOCXPageBreak	= 2,
} RKDOCXBreakType;

/*!
 @abstract Converter for placeholder run elements.
 */
@interface RKDOCXPlaceholderWriter : NSObject

/*!
 @abstract Converts the passed placeholder to a "simple field" element including a run element.
 @discussion DOCX only supports page number placeholders. See ISO 29500-1:2012: §17.16.19 (Simple Field).
 */
+ (NSXMLElement *)placeholderElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Returns an XML element representing a run with a break of the given type.
 */
+ (NSXMLElement *)runElementWithBreak:(RKDOCXBreakType)type;

@end
