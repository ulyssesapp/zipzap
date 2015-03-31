//
//  RKDOCXContentTypesWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"
#import "RKDOCXConversionContext.h"

@interface RKDOCXContentTypesWriter : RKDOCXPartWriter

/*!
 @abstract Collects the content types of the conversion context in an [Content_Types].xml file and adds the data object to the context.
 */
+ (void)buildContentTypesUsingContext:(RKDOCXConversionContext *)context;

@end
