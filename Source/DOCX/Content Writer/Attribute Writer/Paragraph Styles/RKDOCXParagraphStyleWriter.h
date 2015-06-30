//
//  RKDOCXParagraphStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributeWriter.h"

/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.1.6 (Right to Left Paragraph Layout), §17.3.1.12 (Paragraph Indentation), §17.3.1.13 (Paragraph Alignment), §17.15.1.25 (Distance Between Automatic Stops), §17.3.1.33 (Spacing Between Lines and Above/Below Paragraph), §17.3.1.38 (Set of Custom Tab Stops), §17.3.1.15 (Keep Paragraph With Next Paragraph), §17.3.1.34 (Supress Hyphenation for Paragraph) and §17.3.1.44 (Allow First/Last Line to Display on a Separate Page).
 */
@interface RKDOCXParagraphStyleWriter : RKDOCXAttributeWriter

/*!
 @abstract Returns tab stop settings required for text lists.
 */
+ (NSXMLElement *)tabSettingsForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth;

/*!
 @abstract Returns indentation settings required for text lists.
 */
+ (NSXMLElement *)indentationSettingsForMarkerLocation:(NSUInteger)markerLocation markerWidth:(NSUInteger)markerWidth;

/*!
 @abstract Returns the alignment and spacing properties of the footnote area separators of the given context.
 */
+ (NSArray *)paragraphPropertiesForSeparatorElementUsingContext:(RKDOCXConversionContext *)context;

@end
