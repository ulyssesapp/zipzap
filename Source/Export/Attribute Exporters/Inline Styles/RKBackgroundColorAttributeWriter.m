//
//  RKBackgroundColorAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKBackgroundColorAttributeWriter.h"

@implementation RKBackgroundColorAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSBackgroundColorAttributeName];
}

+ (void)addTagsForAttribute:(NSColor *)color
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSUInteger colorIndex = (color == nil) ? 1 : [resources indexOfColor:color];
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\cb%lu ", colorIndex] forPosition:range.location];
}

@end
