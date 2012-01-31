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

+ (void)addTagsForAttribute:(id)value
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (value) {
        NSString *absoluteUrl = ([value isKindOfClass: [NSString class]]) ? value : [value absoluteString];
            
        [taggedString registerTag:[NSString stringWithFormat:@"{\\field{\\*\\fldinst{HYPERLINK \"%@\"}}{\\fldrslt ", absoluteUrl]
                      forPosition:range.location];
        
        [taggedString registerTag:@"}}" forPosition:(range.location + range.length)];
    }
}
                                                                                 
@end
