//
//  RKForegroundColorAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKForegroundColorAttributeWriter.h"

@implementation RKForegroundColorAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSForegroundColorAttributeName withPriority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSColor *)color
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources;
{
    NSUInteger colorIndex = (color == nil) ? 0 : [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\cf%lu ", colorIndex] forPosition:range.location];
}

@end
