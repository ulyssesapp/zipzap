//
//  RKFontAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKFontAttributeWriter.h"

@implementation RKFontAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerHandler:self forAttribute:NSFontAttributeName withPriority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (void)addTagsForAttribute:(NSFont *)font
             toTaggedString:(RKTaggedString *)taggedString 
                    inRange:(NSRange)range
       withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources;
{
    NSUInteger openPosition = range.location;
    NSUInteger closePosition = range.location + range.length;
    
    // Default font is "Helvetica", 12pt
    if (!font)
        font = [NSFont fontWithName:@"Helvetica" size:12];
    
    NSUInteger fontIndex = [resources indexOfFont:font];
    
    // Add font and size tag
    [taggedString registerTag:[NSString stringWithFormat:@"\\f%u ", fontIndex] forPosition:openPosition];
    [taggedString registerTag:[NSString stringWithFormat:@"\\fs%u ", (NSUInteger)font.pointSize] forPosition:openPosition];
    
    // Add trait tags
    NSUInteger fontTraits = [[NSFontManager sharedFontManager] traitsOfFont:font];
    
    if (fontTraits & NSBoldFontMask) {
        [taggedString registerTag:@"\\b " forPosition:openPosition];
        [taggedString registerClosingTag:@"\\b0 " forPosition:closePosition];
    }
    
    if (fontTraits & NSItalicFontMask) {
        [taggedString registerTag:@"\\i " forPosition:openPosition];
        [taggedString registerClosingTag:@"\\i0 " forPosition:closePosition];
    }   
}

@end
