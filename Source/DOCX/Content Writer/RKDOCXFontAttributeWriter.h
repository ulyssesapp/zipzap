//
//  RKDOCXFontAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"

/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See standard chapters §17.3.2.1, §17.3.2.16, §17.3.2.26 and §17.3.2.38.
 */
@interface RKDOCXFontAttributeWriter : RKDOCXRunAttributeWriter

+ (NSArray *)runPropertiesForAttributes:(NSDictionary *)attributes;

@end
