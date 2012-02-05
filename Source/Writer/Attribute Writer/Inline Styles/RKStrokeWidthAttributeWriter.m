//
//  RKStrokeWidthAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKStrokeWidthAttributeWriter.h"

@implementation RKStrokeWidthAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSStrokeWidthAttributeName withPriority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSNumber *)strokeWidthObject
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    float strokeWidth = [strokeWidthObject floatValue];
    
    if (strokeWidth == 0)
        return;
    
    [taggedString registerTag:[NSString stringWithFormat:@"\\outl\\strokewidth%u ", (NSUInteger)(strokeWidth * 20)] forPosition:range.location];
    [taggedString registerClosingTag:@"\\outl0\\strokewidth0 " forPosition:(range.location + range.length)];
}

@end
