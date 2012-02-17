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

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:NSBackgroundColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSForegroundColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSUnderlineColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSStrikethroughColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    [RKAttributedStringWriter registerWriter:self forAttribute:NSStrokeColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];    
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSColor *)color resources:(RKResourcePool *)resources
{
    
    static NSDictionary *colorTags = nil;
    static NSDictionary *defaultColorTags = nil;
    
    colorTags = (colorTags) ?: [NSDictionary dictionaryWithObjectsAndKeys:
                 @"\\cb",        NSBackgroundColorAttributeName,
                 @"\\cf",        NSForegroundColorAttributeName,
                 @"\\ulc",       NSUnderlineColorAttributeName,
                 @"\\strikec",   NSStrikethroughColorAttributeName,
                 @"\\strokec",   NSStrokeColorAttributeName,
                 nil
                 ];
    
    // There are different default colors for background (= 1) and stroke styles (= 0)
    defaultColorTags = (defaultColorTags) ?: [NSDictionary dictionaryWithObjectsAndKeys:
                        @"\\cb1 ",        NSBackgroundColorAttributeName,
                        @"\\cf0 ",        NSForegroundColorAttributeName,
                        @"\\ulc0 ",       NSUnderlineColorAttributeName,
                        @"\\strikec0 ",   NSStrikethroughColorAttributeName,
                        @"\\strokec0 ",   NSStrokeColorAttributeName,
                        nil
                        ];
    
    if (color) {
        NSUInteger colorIndex = [resources indexOfColor: color];
        
        return [NSString stringWithFormat:@"%@%u ", [colorTags objectForKey: attributeName], colorIndex];        
    }
    else {
        return [defaultColorTags objectForKey: attributeName];
    }
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(id)value resources:(RKResourcePool *)resources
{
    return @"";
}

@end
