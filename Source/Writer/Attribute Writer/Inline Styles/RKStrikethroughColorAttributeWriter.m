//
//  RKStrikethroughColorAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKStrikethroughColorAttributeWriter.h"

@implementation RKStrikethroughColorAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSStrikethroughColorAttributeName withPriority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSColor *)color
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (color == nil)
        return;
    
    NSUInteger colorIndex = [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikec%u ", colorIndex] forPosition:range.location];
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikec0 ", colorIndex] forPosition:(range.location + range.length)];
}

@end
