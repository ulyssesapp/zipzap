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
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKUnderlineStyleAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    }
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)underlineStyleObject resources:(RKResourcePool *)resources
{
    NSUInteger underlineStyle = [underlineStyleObject unsignedIntegerValue];
    
    // No underlining
    if (!underlineStyleObject || (underlineStyle == RKUnderlineStyleNone))
        return @"";
    
    NSMutableString *openingTag = [NSMutableString new];
    
    // Word-wise underlining (must precede other tags)
    if (underlineStyle & RKUnderlineByWordMask) {
        [openingTag appendString:@"\\ulw"];
    }
    
    // Never write \\ulw \\ul, since this is misinterpreted by several RTF interpreters
    if (underlineStyle != (RKUnderlineByWordMask | RKUnderlineStyleSingle)) {
        // Determine pattern flag
        NSString *patternString = @"";
        
        switch (underlineStyle & RKUnderlinePatternMask) {
            case RKUnderlinePatternDash:
                patternString = @"dash";
                break;
            case RKUnderlinePatternDashDot:
                patternString = @"dashd";
                break;
            case RKUnderlinePatternDashDotDot:
                patternString = @"dashdd";
                break;
        }
        
        // Determine style flag
        NSString *styleString = @"";
        
        if ((underlineStyle & RKUnderlineStyleDouble) == RKUnderlineStyleDouble) {
            // Underlining mode double (cannot be combined with dash-styles
            styleString = @"db";
            patternString = @"";
        }
        else if ((underlineStyle & RKUnderlineStyleThick) == RKUnderlineStyleThick) {
            styleString = @"th";
        }
        
        // Generate \\ul<STYLE><PATTERN> flag
        [openingTag appendFormat:@"\\ul%@%@", styleString, patternString];
    }
    
    // We add the Apple proprietary tag, to ensure full support of the text system
    [openingTag appendFormat:@"\\ulstyle%lu ", underlineStyle];

    return openingTag;
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)underlineStyleObject resources:(RKResourcePool *)resources
{
    NSUInteger underlineStyle = [underlineStyleObject unsignedIntegerValue];
    
    // No underlining
    if (!underlineStyleObject || (underlineStyle == RKUnderlineStyleNone))
        return @"";
    
    return @"\\ulnone ";
}

@end
