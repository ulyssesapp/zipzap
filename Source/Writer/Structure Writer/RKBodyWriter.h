//
//  RKBodyWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversionPolicy.h"
#import "RKWriter.h"

@class RKDocument, RKResourcePool;

/*!
 @abstract Generates the body of a RTF document
 */
@interface RKBodyWriter : NSObject

/*!
 @abstract Generates the body content of a RTF document
 @discussion Requires an attachment policy to specify how attached files are exported and a resource pool to collect fonts and colors.
 */
+ (NSString *)RTFBodyFromDocument:(RKDocument *)document withConversionPolicy:(RKConversionPolicy)RKConversionPolicy resources:(RKResourcePool *)resources;

@end
