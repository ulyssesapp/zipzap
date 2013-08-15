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
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKLinkAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
    }
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(id)value
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources

{
    if (value) {
        NSString *absoluteUrl = ([value isKindOfClass: [NSURL class]]) ? [value absoluteString] : value;
            
        [taggedString registerTag:[NSString stringWithFormat:@"{\\field{\\*\\fldinst{HYPERLINK \"%@\"}}{\\fldrslt ", absoluteUrl]
                      forPosition:range.location];
        
        [taggedString registerClosingTag:@"}}" forPosition:(NSMaxRange(range))];
    }
}
                                                                                 
@end
