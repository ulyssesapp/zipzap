//
//  RKPlaceholderWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPlaceholderWriter.h"
#import "RKAttributedStringWriter.h"

@implementation RKPlaceholderWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:RKPlaceholderAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSNumber *)placeholder
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources
{
     if (placeholder) {
        NSString *tag;
        
        switch ([placeholder unsignedIntegerValue]) {
            case RKPlaceholderPageNumber:
                tag = @"\\chpgn";
                break;
            
            case RKPlaceholderSectionNumber:
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
