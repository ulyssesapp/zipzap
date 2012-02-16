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
    [RKAttributedStringWriter registerWriter:self forAttribute:NSStrokeWidthAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSNumber *)strokeWidthObject
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    float strokeWidth = [strokeWidthObject floatValue];
    
    if (strokeWidth == 0)
        return;
    
    // We use the additional \strokewidth tag of Cocoa
    [taggedString registerTag:[NSString stringWithFormat:@"\\outl\\strokewidth%u ", (NSUInteger)(strokeWidth * 20)] forPosition:range.location];
    [taggedString registerClosingTag:@"\\outl0\\strokewidth0 " forPosition:NSMaxRange(range)];
}

@end
