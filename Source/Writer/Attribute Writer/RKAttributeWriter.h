//
//  RKAttributeWriter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"
#import "RKResourcePool.h"
#import "RKTaggedString.h"

@interface RKAttributeWriter : NSObject

/*!
 @abstract Adds a tag for a certain attribute
 */
+ (void)addTagsForAttribute:(id)value
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources;

@end
