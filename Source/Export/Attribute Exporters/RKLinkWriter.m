//
//  RKLinkWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKLinkWriter.h"

@implementation RKLinkWriter

+ (void)addTagsForAttributedString:(NSAttributedString *)attributedString toTaggedString:(RKTaggedString *)taggedString withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    [attributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value) {
            NSString *absoluteUrl = ([value isKindOfClass: [NSString class]]) ? value : [value absoluteString];
            
            [taggedString registerTag:[NSString stringWithFormat:@"{\\field{\\*\\fldinst{HYPERLINK \"%@\"}}{\\fldrslt ", absoluteUrl]
                      forPosition:range.location];
        
            [taggedString registerTag:@"}}" forPosition:(range.location + range.length)];
        }
    }];
}
                                                                                 
@end
