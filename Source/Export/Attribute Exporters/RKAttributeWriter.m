//
//  RKAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeWriter.h"

@implementation RKAttributeWriter

/*!
 @abstract Adds a tag for a certain attribute
 */
+ (void)addTagsForAttribute:(id)value
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSAssert(false, @"Missing method of abstract class");
}

@end
