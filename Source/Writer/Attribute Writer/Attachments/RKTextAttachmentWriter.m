//
//  RKTextAttachmentWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKTextAttachmentWriter.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"
#import "RKWriter.h"

@implementation RKTextAttachmentWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSAttachmentAttributeName];
}

+ (void)addTagsForAttribute:(NSParagraphStyle *)paragraphStyle
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    
}

@end
