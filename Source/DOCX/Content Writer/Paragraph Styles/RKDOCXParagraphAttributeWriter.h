//
//  RKDOCXParagraphAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"


/*!
 @abstract Generates a paragraph element "<w:p>" to be added to the parent document.
 @discussion See ISO 29500-1:2012: §17.3.1 (Paragraphs).
 */
@interface RKDOCXParagraphAttributeWriter : RKDOCXAttributedStringWriter

/*!
 @abstract Returns an XML element representing a paragraph including properties and runs.
 @discussion See ISO 29500-1:2012: §17.3.1 (Paragraphs).
 */
+ (NSXMLElement *)paragraphElementWithProperties:(NSXMLElement *)properties runElements:(NSArray *)runElements;

@end

/*!
 @abstract Subclasses generate paragraph properties and return the respective XML elements.
 */
@interface RKDOCXParagraphAttributeWriter (Subclassing)

/*!
 @abstract Returns an array of XML elements containing the properties of a paragraph.
 */
+ (NSArray *)paragraphPropertiesForAttributes:(NSDictionary *)attributes;

@end
