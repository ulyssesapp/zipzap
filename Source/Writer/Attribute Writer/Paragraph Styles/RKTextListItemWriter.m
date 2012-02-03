//
//  RKTextListItemWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListItemWriter.h"
#import "RKAttributedStringWriter.h"
#import "RKTextListItem.h"

@implementation RKTextListItemWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:RKTextListItemAttributeName withPriority:RKAttributedStringWriterPriorityParagraphStylingLevel];
}

+ (void)addTagsForAttribute:(RKTextListItem *)listItem
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    
}

@end
