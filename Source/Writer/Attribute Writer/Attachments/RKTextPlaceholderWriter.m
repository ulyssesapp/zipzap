//
//  RKPlaceholderWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextPlaceholderWriter.h"
#import "RKAttributedStringWriter.h"

@implementation RKTextPlaceholderWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:RKTextPlaceholderAttributeName withPriority:RKAttributedStringWriterPriorityTextAttachmentLevel];
}

+ (void)addTagsForAttribute:(RKTextPlaceholder *)placeholder
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (placeholder) {
        NSString *tag;
        
        switch (placeholder.placeholderType) {
            case RKTextPlaceholderPageNumber:
                tag = @"\\chpgn";
                break;
            
            case RKTextPlaceholderSectionNumber:
                tag = @"\\sectnum";
                break;
        }
        
        // Footnote content
        [taggedString registerTag:tag forPosition:range.location];
        
        // Remove attachment charracter
        [taggedString removeRange: range];
    }
}

@end
