//
//  RKHeaderWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKResourcePool;
@class RKDocument;

/*!
 @abstract Generates the header of an RTF file
 */
@interface RKHeaderWriter : NSObject

/*!
 @abstract Generates the header content of a RTF document based on a set of filtered resources (e.g. fonts, colors)
 */
+ (NSString *)RTFHeaderFromDocument:(RKDocument *)document withResources:(RKResourcePool *)resources;

@end
