//
//  RKTextAttachmentWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"

@class RKResourcePool, RKTaggedString;

/*!
 @abstract Writes out all tags required for text attachments
 */
@interface RKTextAttachmentWriter : NSObject

/*!
 @abstract Adds tags for all font styles
 */
+ (void)tag:(RKTaggedString *)taggedString withTextAttachmentsOfAttributedString:(NSAttributedString *)attributedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end
