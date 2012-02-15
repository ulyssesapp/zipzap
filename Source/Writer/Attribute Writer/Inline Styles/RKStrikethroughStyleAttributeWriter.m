//
//  RKStrikethroughStyleAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKStrikethroughStyleAttributeWriter.h"

@implementation RKStrikethroughStyleAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSStrikethroughStyleAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSNumber *)strikethroughStyleObject
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSUInteger strikethroughStyle = [strikethroughStyleObject unsignedIntegerValue];
    
    // No strike through
    if (strikethroughStyle == NSUnderlineStyleNone)
        return;
    
    // Convert unsupported strikethrough styles to \strike, 
    NSString *opening = @"\\strike";
    NSString *closing = @"\\strike0 ";
    
    // Currently only \\strikedN is supported as alternative
    if ((strikethroughStyle & NSUnderlineStyleDouble) == NSUnderlineStyleDouble) {
        opening = @"\\striked1";
        closing = @"\\striked0 ";
    }
    
    [taggedString registerTag:opening forPosition:range.location];
    [taggedString registerClosingTag:closing forPosition:NSMaxRange(range)];
    
    // We add the Apple proprietary tag, to ensure full support of the text system
    [taggedString registerTag:[NSString stringWithFormat:@"\\strikestyle%u ", strikethroughStyle] forPosition:range.location];
    
}

@end
