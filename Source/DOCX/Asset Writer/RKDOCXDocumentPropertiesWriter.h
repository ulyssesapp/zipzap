//
//  RKDOCXDocumentPropertiesWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"
#import "RKDOCXConversionContext.h"

@interface RKDOCXDocumentPropertiesWriter : RKDOCXPartWriter

/*!
 @abstract Writes the core properties (Dublin Core) of the conversion context and adds the data object to the context.
 */
+ (void)buildCorePropertiesUsingContext:(RKDOCXConversionContext *)context;

/*!
 @abstract Writes the extended properties of the conversion context and adds the data object to the context.
 */
+ (void)buildExtendedPropertiesUsingContext:(RKDOCXConversionContext *)context;

@end
