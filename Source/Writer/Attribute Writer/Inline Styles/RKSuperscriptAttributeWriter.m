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
    [RKAttributedStringWriter registerHandler:self forAttribute:NSSuperscriptAttributeName];
}

+ (void)addTagsForAttribute:(NSNumber *)superScriptModeObject
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSInteger mode = [superScriptModeObject integerValue];
    
    if (mode == 0) 
        return;
    
    if (mode > 0) {
        [taggedString registerTag:[NSString stringWithFormat:@"\\sup "] forPosition:range.location];
        [taggedString registerTag:[NSString stringWithFormat:@"\\sup0 "] forPosition:(range.location + range.length)];
    }
    else if (mode < 0) {
        [taggedString registerTag:[NSString stringWithFormat:@"\\sub "] forPosition:range.location];
        [taggedString registerTag:[NSString stringWithFormat:@"\\sub0 "] forPosition:(range.location + range.length)];
    }
}

@end
