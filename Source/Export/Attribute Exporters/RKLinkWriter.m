//
//  RKLinkWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKLinkWriter.h"

@interface RKLinkWriter ()

/*!
 @abstract Generates the required tag of a link attribute
 */
+ (void)tag:(RKTaggedString *)taggedString withLink:(NSURL *)url inRange:(NSRange)range;

@end

@implementation RKLinkWriter

+ (void)tag:(RKTaggedString *)taggedString withLink:(NSURL *)url inRange:(NSRange)range
{
    if (!url)
        return;
    
    [taggedString registerTag:[NSString stringWithFormat:@"{\\field{\\*\\fldinst{HYPERLINK \"%@\"}}{\\fldrslt ", [url absoluteString]]
                    forPosition:range.location];

    [taggedString registerTag:@"}}" forPosition:(range.location + range.length)];
}

+ (void)tag:(RKTaggedString *)taggedString withLinkStylesOfAttributedString:(NSAttributedString *)attributedString
{
    [attributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, [attributedString length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if ([value isKindOfClass: [NSString class]]) {
            value = [NSURL URLWithString:value];
        }
        
        [RKLinkWriter tag:taggedString withLink:value inRange:range];
    }];
}

                                                                                 
                                                                                 
@end
