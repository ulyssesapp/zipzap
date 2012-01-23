//
//  RKWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKDocument;

/*!
 @abstract The RTF exporter
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
