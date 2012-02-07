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

+ (void)addTagsForAttribute:(RKFootnote *)footnote
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (footnote) {
        NSString *noteTag = (footnote.isEndnote) ? @"footnote\\ftnalt {\\super \\chftn }" : @"footnote {\\super \\chftn }";
                
        NSString *noteContent = [RKAttributedStringWriter RTFfromAttributedString:footnote.content insideTag:noteTag withAttachmentPolicy:RKAttachmentPolicyIgnore resources:resources];
        
        // Footnote marker
        [taggedString registerTag:@"{\\super \\chftn }" forPosition:range.location];
        
        // Footnote content
        [taggedString registerTag:noteContent forPosition:range.location];
                
        // Remove attachment charracter
        [taggedString removeRange: range];
    }
}

@end
