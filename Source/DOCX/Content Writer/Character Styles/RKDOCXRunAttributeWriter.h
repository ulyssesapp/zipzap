//
//  RKDOCXRunAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"


/*!
 @abstract Generates a run element "<w:r>" to be added to the parent paragraph.
 @discussion See ISO 29500-1:2012: §17.3.2 (Run) and §17.3.3 (Run Content).
 */
@interface RKDOCXRunAttributeWriter : RKDOCXAttributedStringWriter

/*!
 @abstract Returns an XML element representing a run with the given attributes and the corresponding text.
 @discussion The text is built using the attributed string and the range.
 */
+ (NSXMLElement *)runElementForAttributedString:(NSAttributedString *)attributedString attributes:(NSDictionary *)attributes range:(NSRange)range;

@end

/*!
 @abstract Subclasses generate run properties and return the respective XML elements.
 */
@interface RKDOCXRunAttributeWriter (Subclassing)

/*!
 @abstract Returns an array of XML elements containing the properties of a run.
 */
+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes;

@end