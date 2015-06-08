//
//  RKDOCXParagraphStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributeWriter.h"

// Names required by text lists
extern NSString *RKDOCXParagraphStyleCenterAlignmentAttributeValue;
extern NSString *RKDOCXParagraphStyleJustifiedAlignmentAttributeValue;
extern NSString *RKDOCXParagraphStyleLeftAlignmentAttributeValue;
extern NSString *RKDOCXParagraphStyleRightAlignmentAttributeValue;

/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.1.6 (Right to Left Paragraph Layout), §17.3.1.12 (Paragraph Indentation), §17.3.1.13 (Paragraph Alignment), §17.15.1.25 (Distance Between Automatic Stops), §17.3.1.33 (Spacing Between Lines and Above/Below Paragraph) and §17.3.1.38 (Set of Custom Tab Stops).
 */
@interface RKDOCXParagraphStyleWriter : RKDOCXAttributeWriter

/*!
 @abstract Returns tab stop settings required for text lists.
 */
+ (NSXMLElement *)tabSettingsForMarkerLocationKey:(NSUInteger)markerLocationKey markerWidthKey:(NSUInteger)markerWidthKey;

/*!
 @abstract Returns indentation settings required for text lists.
 */
+ (NSXMLElement *)indentationSettingsForMarkerLocationKey:(NSUInteger)markerLocationKey markerWidthKey:(NSUInteger)markerWidthKey;

/*!
 @abstract Returns the alignment and spacing properties of the footnote area separators of the given context.
 */
+ (NSArray *)paragraphPropertiesForSeparatorElementUsingContext:(RKDOCXConversionContext *)context;

@end
