//
//  RKPDFWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKDocument;

/*!
 @abstract Encapsulates all PDF writing capabilities
 */
@interface RKPDFWriter : NSObject

/*!
 @abstract Generates a PDF file from an RKDocument
 */
+ (NSData *)PDFFromDocument:(RKDocument *)document;

@end
