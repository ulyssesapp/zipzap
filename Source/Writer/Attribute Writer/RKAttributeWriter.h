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

/*!
 @abstract Abstract class for converting attributes to RTF tags
 */
@interface RKAttributeWriter : NSObject

/*!
 @abstract Adds a tag for a certain attribute
 @discussion Advanced variant, automatic fallback to addTagsForAttribute:toTaggedString:inRange:withAttachmentPolicy:resources if not implemented.
 */
+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(id)value 
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources;

@end
