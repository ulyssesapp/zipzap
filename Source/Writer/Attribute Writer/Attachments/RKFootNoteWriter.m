//
//  RKFootNoteWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootNoteWriter.h"
#import "RKAttributedStringWriter.h"

@implementation RKFootNoteWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:RKFootNoteAttributeName withPriority:RKAttributedStringWriterPriorityTextAttachmentLevel];
}

+ (void)addTagsForAttribute:(RKFootNote *)footNote
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (footNote) {
        NSString *body = [RKAttributedStringWriter RTFfromAttributedString:footNote.content withAttachmentPolicy:RKAttachmentPolicyIgnore resources:resources];
        NSString *tag = [NSString stringWithFormat:@"{\\footnote %@}", body];
        
        [taggedString registerTag:tag forPosition:range.location];
        
        // Remove attachment charracter
        [taggedString removeRange: range];
    }
}

@end
