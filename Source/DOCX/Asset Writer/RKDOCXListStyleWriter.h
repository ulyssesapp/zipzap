//
//  RKDOCXListStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 24.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"
#import "RKDOCXPartWriter.h"

/*!
 @abstract Generates the numbering file containing all numbering definitions referenced by the given context and adds them to the output document.
 @discussion See ISO 29500-1:2012: §17.9 (Numbering). The defintions will be stored in the numbering.xml file inside the output document. Should be called after the main document translation.
 */
@interface RKDOCXListStyleWriter : RKDOCXPartWriter

/*!
 @abstract Writes the numbering definitions of the conversion context and adds the data objects to the context.
 */
+ (void)buildNumberingsUsingContxt:(RKDOCXConversionContext *)context;

@end
