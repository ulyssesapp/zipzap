//
//  RSDOCXContextObject.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @abstract Contains the zip file version of an RKDocument
 */
@interface RKDOCXContextObject : NSObject

/*!
 @abstract The DOCX archive containing the XML files of a DOCX
 */
@property (readonly) NSData *docx;

- (void)addDocumentPart:(NSData *)part withFilename:(NSString *)filename;

@end
