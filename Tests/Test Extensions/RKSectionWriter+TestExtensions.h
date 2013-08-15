//
//  RKSectionWriter+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"
#import "RKSectionWriter.h"
#import "RKResourcePool.h"
#import "RKWriter.h"

@interface RKSectionWriter (TestExtensions)

+ (NSString *)sectionAttributesForSection:(RKSection *)section;
+ (NSString *)headersForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;
+ (NSString *)footersForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;
+ (NSString *)contentForSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool *)resources;

@end