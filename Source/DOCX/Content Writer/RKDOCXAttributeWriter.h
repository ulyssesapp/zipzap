//
//  RKDOCXAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 10.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

// Commonly used attribute name
extern NSString *RKDOCXAttributeWriterValueAttributeName;


@interface RKDOCXAttributeWriter : NSObject

@end

/*!
 @abstract Subclasses generate paragraph or run properties and return the respective XML elements.
 */
@interface RKDOCXAttributeWriter (Subclassing)

/*!
 @abstract Returns an array of XML elements containing the properties of a paragraph or run.
 */
+ (NSArray *)propertyElementsForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context;

@end
