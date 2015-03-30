//
//  RKDOCXDocumentContentWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"
#import "RKDOCXConversionContext.h"

@interface RKDOCXDocumentContentWriter : RKDOCXPartWriter

/*!
 @abstract Writes the main document of the conversion context and adds the data object to the context.
 */
+ (void)buildDocumentUsingContext:(RKDOCXConversionContext *)context;

@end
