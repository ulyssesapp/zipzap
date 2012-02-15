//
//  RKColorAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKColorAttributeWriter.h"

@implementation RKColorAttributeWriter

static NSDictionary *colorTags = nil;
static NSDictionary *defaultColorTags = nil;

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSBackgroundColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSForegroundColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSUnderlineColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSStrikethroughColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSStrokeColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];    

    colorTags = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"\\cb",        NSBackgroundColorAttributeName,
                     @"\\cf",        NSForegroundColorAttributeName,
                     @"\\ulc",       NSUnderlineColorAttributeName,
                     @"\\strikec",   NSStrikethroughColorAttributeName,
                     @"\\strokec",   NSStrokeColorAttributeName,
                     nil
                     ];
        
    // There are different default colors for background (= 1) and stroke styles (= 0)
    defaultColorTags = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"\\cb1 ",        NSBackgroundColorAttributeName,
                            @"\\cf0 ",        NSForegroundColorAttributeName,
                            @"\\ulc0 ",       NSUnderlineColorAttributeName,
                            @"\\strikec0 ",   NSStrikethroughColorAttributeName,
                            @"\\strokec0 ",   NSStrokeColorAttributeName,
                            nil
                       ];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSColor *)color
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (color != nil) {
        NSUInteger colorIndex = [resources indexOfColor: color];
        
        [taggedString registerTag:[NSString stringWithFormat:@"%@%u ", [colorTags objectForKey: attributeName], colorIndex] forPosition:range.location];        
    }
    else {
        [taggedString registerTag:[defaultColorTags objectForKey: attributeName] forPosition:range.location];
    }
}

@end
