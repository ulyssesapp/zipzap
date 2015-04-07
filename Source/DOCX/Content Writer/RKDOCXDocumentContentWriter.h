//
//  RKDOCXDocumentContentWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXPartWriter.h"

@class RKDOCXConversionContext;


/*!
 @abstract Generates the main document used by the given context and adds it to the output document.
 @discussion See ISO 29500-1:2012: §17.2 (Main Document Story). The document data will be stored inside the document.xml file inside the output document. This is the main document translation.
 */
@interface RKDOCXDocumentContentWriter : RKDOCXPartWriter

/*!
 @abstract Writes the main document of the conversion context and adds the data object to the context.
 */
+ (void)buildDocumentUsingContext:(RKDOCXConversionContext *)context;

@end
