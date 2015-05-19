//
//  RKDOCXPlaceholderWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 17.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

extern NSString *RKDOCXBreakAttributeName;

/*!
 @abstract Represents symbolic characters used for placeholder conversion.
 
 @const RKDOCXLineBreakCharacter	Represents a line break character. See See ISO 29500-1:2012: §17.3.3.1 (Break).
 @const RKDOCXPageBreakCharacter	Represents a page break character. See See ISO 29500-1:2012: §17.3.3.1 (Break).
 @const RKDOCXTabStopCharacter		Represents a tab stop character. See ISO 29500-1:2012: §17.3.3.32 (Tab Character).
 */
typedef enum : NSUInteger {
	RKDOCXLineBreakCharacter,
	RKDOCXPageBreakCharacter,
	RKDOCXTabStopCharacter,
} RKDOCXSymbolicCharacterType;

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
 @discussion See ISO 29500-1:2012: §17.3.3.1 (Break) and §17.3.3.32 (Tab Character).
 */
+ (NSXMLElement *)runElementWithSymbolicCharacter:(RKDOCXSymbolicCharacterType)type;

@end
