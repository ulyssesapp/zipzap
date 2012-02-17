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
 @abstract Returns the tags required to create a stylesheet for a certain attribute
 @discussion Returns an empty string if the attribute cannot be used inside a style sheet
 */
+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName 
                                  value:(id)value 
                           styleSetting:(NSDictionary *)styleSetting 
                              resources:(RKResourcePool *)resources;

/*!
 @abstract Adds a tag for a certain attribute
 */
+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(id)value 
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources;

@end
