//
//  RKDOCXDocumentPropertiesWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"
#import "RKDOCXConversionContext.h"

/*!
 @abstract Collects the core properties and app-specific extended properties used by the given context and adds it to the output document.
 @discussion See standard chapter §11.1 (Part 2). The collected properties will be stored inside the app.xml and core.xml files inside the output document.
 */
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
