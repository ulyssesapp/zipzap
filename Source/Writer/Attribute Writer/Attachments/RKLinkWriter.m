//
//  RKLinkWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKTaggedString.h"
#import "RKLinkWriter.h"

@implementation RKLinkWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSLinkAttributeName withPriority:RKAttributedStringWriterPriorityTextAttachmentLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(id)value
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources

{
    if (value) {
        NSString *absoluteUrl = ([value isKindOfClass: [NSString class]]) ? value : [value absoluteString];
            
        [taggedString registerTag:[NSString stringWithFormat:@"{\\field{\\*\\fldinst{HYPERLINK \"%@\"}}{\\fldrslt ", absoluteUrl]
                      forPosition:range.location];
        
        [taggedString registerTag:@"}}" forPosition:(NSMaxRange(range))];
    }
}
                                                                                 
@end
