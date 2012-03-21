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
    [RKAttributedStringWriter registerWriter:self forAttribute:RKStrikethroughStyleAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)strikethroughStyleObject resources:(RKResourcePool *)resources
{
    NSUInteger strikethroughStyle = [strikethroughStyleObject unsignedIntegerValue];
    
    // No strike through
    if (strikethroughStyle == RKUnderlineStyleNone)
        return @"";
    
    // Convert unsupported strikethrough styles to \strike
    NSMutableString *openingTags;
 
    if ((strikethroughStyle & RKUnderlineStyleDouble) != RKUnderlineStyleDouble) {
        // Convert all unsupported strikethrough styles to \strike
        openingTags = [NSMutableString stringWithString: @"\\strike"];
    }
    else {
        // RTF natively only supports \\strikedN as alternative        
        openingTags = [NSMutableString stringWithString: @"\\striked1"];
    }
    
    // We add the Apple proprietary tag, to ensure full support of the text system
    [openingTags appendFormat:@"\\strikestyle%u ", strikethroughStyle];
    
    return openingTags;
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)strikethroughStyleObject resources:(RKResourcePool *)resources
{
    NSUInteger strikethroughStyle = [strikethroughStyleObject unsignedIntegerValue];
    
    // No strike through
    if (strikethroughStyle == RKUnderlineStyleNone)
        return @"";
    
    if ((strikethroughStyle & RKUnderlineStyleDouble) != RKUnderlineStyleDouble) {
        // Convert all unsupported strikethrough styles to \strike
        return @"\\strike0 ";
    }
    else {
        // RTF natively only supports \\strikedN as alternative        
        return @"\\striked0 ";
    }    
}

@end
