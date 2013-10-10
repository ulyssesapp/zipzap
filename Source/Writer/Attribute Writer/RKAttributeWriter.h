//
//  RKAttributeWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"
#import "RKConversionPolicy.h"
#import "RKResourcePool.h"
#import "RKTaggedString.h"

/*!
 @abstract A policy that should be applied during the preprocessing of an attributed string.
 
 @const RKAttributePreprocessorListMarkerPositionsUsingIndent				Specifies that a list marker should be positioned using the first line indent, rather than by tabs. This is required for MS Word export.
 @const RKAttributePreprocessorInnerListParagraphsByLineBreak				Specifies that paragraph breaks inside text list items should be converted to line breaks. Required for any RTF export.
 */
typedef enum : NSUInteger {
	RKAttributePreprocessorListMarkerPositionsUsingIndent		= (1 << 0),
	RKAttributePreprocessorInnerListParagraphsUsingLineBreak	= (1 << 1)
}RKAttributePreprocessingPolicy;

/*!
 @abstract Abstract class for converting attributes to RTF tags
 */
@interface RKAttributeWriter : NSObject

/*!
 @abstract Returns the tags required to create a stylesheet for a certain attribute
 @discussion Returns an empty string if the attribute cannot be used inside a style sheet
 */
+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName 
                                  value:(id)value 
                           styleSetting:(NSDictionary *)styleSetting 
                              resources:(RKResourcePool *)resources;

/*!
 @abstract Adds a tag for a certain attribute
 @discussion The selected range is inside a paragraph of the attributed string
 */
+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(id)value 
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources;

/*!
 @abstract Pre-processes the given attribute
 @discussion The selected range is the longest effective range of the attribute. It is allowed to modify attributed of the attributed string. If not overriden by a subclass, no action occurs.
 */
+ (void)preprocessAttribute:(NSString *)attributeName
                      value:(id)attributeValue
             effectiveRange:(NSRange)range
         ofAttributedString:(NSMutableAttributedString *)preprocessedString
				usingPolicy:(RKAttributePreprocessingPolicy)preprocessing;

@end
