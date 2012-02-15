//
//  RKSuperscriptAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKSuperscriptAttributeWriter.h"

@implementation RKSuperscriptAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSSuperscriptAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSNumber *)superScriptModeObject
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSInteger mode = [superScriptModeObject integerValue];
    
    if (mode == 0) 
        return;
    
    if (mode > 0) {
        [taggedString registerTag:[NSString stringWithFormat:@"\\sup "] forPosition:range.location];
        [taggedString registerClosingTag:[NSString stringWithFormat:@"\\sup0 "] forPosition:(NSMaxRange(range))];
    }
    else if (mode < 0) {
        [taggedString registerTag:[NSString stringWithFormat:@"\\sub "] forPosition:range.location];
        [taggedString registerClosingTag:[NSString stringWithFormat:@"\\sub0 "] forPosition:(NSMaxRange(range))];
    }
}

@end
