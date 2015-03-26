//
//  RKDOCXWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@class RKDocument;

/*!
 @abstract The internally used DOCX writer
 */
@interface RKDOCXWriter : NSObject

/*!
 @abstract Builds a DOCX from an RKDocument
 */
+ (NSData *)DOCXfromDocument:(RKDocument *)document;

@end
