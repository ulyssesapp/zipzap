//
//  RKLinkWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"

@class RKTaggedString, RKResourcePool;

/*!
 @abstract Writes out all tags required for a link style
 */
@interface RKLinkWriter : NSObject

/*!
 @abstract Adds tags for all link styles
 */
+ (void)addTagsForAttributedString:(NSAttributedString *)attributedString toTaggedString:(RKTaggedString *)taggedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end
