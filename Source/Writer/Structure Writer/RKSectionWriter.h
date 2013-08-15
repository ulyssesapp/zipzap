//
//  RKSectionWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversionPolicy.h"
#import "RKWriter.h"

@class RKResourcePool;

/*!
 @abstract Translates the content of an RTF section
 */
@interface RKSectionWriter : NSObject

/*!
 @abstract Translates an RKSection to RTF
 @discussion Requires an attachment policy to specify how attached files are exported and a resource pool to collect fonts and colors.
 */
+ (NSString *)RTFFromSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;

@end
