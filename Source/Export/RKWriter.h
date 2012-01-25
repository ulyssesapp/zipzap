//
//  RKWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKDocument;

/*!
 @abstract The internally used RTF writer
 */
@interface RKWriter : NSObject

/*!
 @abstract Builds an RTF from an RTFDocument
 */
+ (NSData *)RTFfromDocument:(RKDocument *)document;

/*!
 @abstract Builds an RTF from an RTFDocument
 */
+ (NSFileWrapper *)RTFDfromDocument:(RKDocument *)document;

@end
