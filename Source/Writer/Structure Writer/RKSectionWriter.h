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
 @abstract The position of the first page.
 
 @const RKSectionStartsOnSamePage		The section should start on the same page.
 @const RKSectionStartsOnNextPage		The first page of the section should be placed on the next page.
 @const RKSectionStartsOnOddPage		The first page of the section should be placed on an od page.
 @const RKSectionStartsOnEvenPage		The first page of the section should be placed on an od page.
 */
typedef enum : NSUInteger {
	RKSectionStartsOnSamePage,
	RKSectionStartsOnNextPage,
	RKSectionStartsOnOddPage,
	RKSectionStartsOnEvenPage
}RKSectionFirstPagePosition;

/*!
 @abstract Translates the content of an RTF section
 */
@interface RKSectionWriter : NSObject

/*!
 @abstract Translates an RKSection to RTF
 @discussion Requires an attachment policy to specify how attached files are exported and a resource pool to collect fonts and colors. It can be specified on which position the first page of a section should be placed (left, right, next)
 */
+ (NSString *)RTFFromSection:(RKSection *)section withConversionPolicy:(RKConversionPolicy)conversionPolicy firstPagePosition:(RKSectionFirstPagePosition)firstPagePosition resources:(RKResourcePool *)resources;

@end
