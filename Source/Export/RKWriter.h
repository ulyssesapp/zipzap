//
//  RKWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKDocument;

/*!
 @abstract Attachment policies for RTF generation
 @const RKAttachmentPolicyIgnore Ignore all attachments
        RKAttachmentPolicyEmbed Embed all attachments as \pict commands as in RTF
        RKAttachmentPolicyReference Create references to all attachments for RTFD generation
 */
typedef enum {
    RKAttachmentPolicyIgnore = 0,
    RKAttachmentPolicyEmbed = 1,
    RKAttachmentPolicyReference = 2
} RKAttachmentPolicy;

/*!
 @abstract The internally used RTF writer
 */
@interface RKWriter : NSObject

/*!
 @abstract Builds an RTF document without attached files
 */
+ (NSData *)PlainRTFfromDocument:(RKDocument *)document;

/*!
 @abstract Builds an RTF from an RTFDocument
 */
+ (NSData *)RTFfromDocument:(RKDocument *)document;

/*!
 @abstract Builds an RTF from an RTFDocument
 */
+ (NSFileWrapper *)RTFDfromDocument:(RKDocument *)document;

@end
