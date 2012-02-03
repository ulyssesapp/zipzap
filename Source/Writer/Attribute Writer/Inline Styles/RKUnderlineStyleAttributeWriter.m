//
//  RKUnderlineStyleAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKUnderlineStyleAttributeWriter.h"

/*!
 @abstract A common bitmask of the NSUnderlinePattern constant
 */
#define RKUnderlinePatternMask          0x700

@implementation RKUnderlineStyleAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSUnderlineStyleAttributeName withPriority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSNumber *)underlineStyleObject
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    NSUInteger underlineStyle = [underlineStyleObject unsignedIntegerValue];
    
    // No underlining
    if (underlineStyle == NSUnderlineStyleNone)
        return;
    
    // Word-wise underlining (must precede other tags)
    if (underlineStyle & NSUnderlineByWordMask) {
        [taggedString registerTag:@"\\ulw" forPosition:range.location];
    }
    
    // Never write \\ulw \\ul, since this is misinterpreted by several RTF interpreters
    if (underlineStyle != (NSUnderlineByWordMask | NSUnderlineStyleSingle)) {
        // Determine pattern flag
        NSString *patternString = @"";
        
        switch (underlineStyle & RKUnderlinePatternMask) {
            case NSUnderlinePatternDash:
                patternString = @"dash";
                break;
            case NSUnderlinePatternDashDot:
                patternString = @"dashd";
                break;
            case NSUnderlinePatternDashDotDot:
                patternString = @"dashdd";
                break;
        }
        
        // Determine style flag
        NSString *styleString = @"";
        
        if ((underlineStyle & NSUnderlineStyleDouble) == NSUnderlineStyleDouble) {
            // Underlining mode double (cannot be combined with dash-styles
            styleString = @"db";
            patternString = @"";
        }
        else if ((underlineStyle & NSUnderlineStyleThick) == NSUnderlineStyleThick) {
            styleString = @"th";
        }
        
        // Generate \\ul<STYLE><PATTERN> flag
        [taggedString registerTag:[NSString stringWithFormat:@"\\ul%@%@", styleString, patternString] forPosition:range.location];
    }
    
    // Add the deactivating tag
    [taggedString registerTag:@"\\ulnone " forPosition:(range.location + range.length)];
    
    // We add the Apple proprietary tag, to ensure full support of the text system
    [taggedString registerTag:[NSString stringWithFormat:@"\\ulstyle%U ", underlineStyle] forPosition:range.location];
}

@end
