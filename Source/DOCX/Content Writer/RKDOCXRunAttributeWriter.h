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
 @discussion See standard chapters §17.3.2 and §17.3.3.
 */
@interface RKDOCXRunAttributeWriter : RKDOCXAttributedStringWriter

+ (NSXMLElement *)XMLRunElementWithRunProperties:(NSXMLElement *)runProperties runContentFromString:(NSString *)content;

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