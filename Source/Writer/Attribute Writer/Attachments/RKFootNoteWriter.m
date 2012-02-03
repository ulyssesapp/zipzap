//
//  RKFootnoteWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnoteWriter.h"
#import "RKAttributedStringWriter.h"

@implementation RKFootnoteWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:RKFootnoteAttributeName withPriority:RKAttributedStringWriterPriorityTextAttachmentLevel];
}

+ (void)addTagsForAttribute:(RKFootnote *)footNote
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (footNote) {
        NSString *tag = [RKAttributedStringWriter RTFfromAttributedString:footNote.content insideTag:@"footnote" withAttachmentPolicy:RKAttachmentPolicyIgnore resources:resources];
        
        [taggedString registerTag:tag forPosition:range.location];
        
        // Remove attachment charracter
        [taggedString removeRange: range];
    }
}

@end
