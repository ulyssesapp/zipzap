//
//  RKAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeWriter.h"

@implementation RKAttributeWriter

+ (void)addTagsForAttribute:(id)value
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSAssert(false, @"Missing method of abstract class");
}

+ (void)addTagsForAttribute:(id)value
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
         ofAttributedString:(NSAttributedString *)attributedString
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    // If this method is not overriden, we just call the basic variant that requires less arguments
    [self addTagsForAttribute:value toTaggedString:taggedString inRange:range withAttachmentPolicy:attachmentPolicy resources:resources];
}

@end
