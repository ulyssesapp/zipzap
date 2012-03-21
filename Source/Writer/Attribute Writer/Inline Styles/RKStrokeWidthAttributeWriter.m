//
//  RKStrokeWidthAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKStrokeWidthAttributeWriter.h"

@implementation RKStrokeWidthAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:RKStrokeWidthAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)strokeWidthObject resources:(RKResourcePool *)resources
{
    float strokeWidth = [strokeWidthObject floatValue];
    
    if (strokeWidth == 0)
        return @"";
    
    return [NSString stringWithFormat:@"\\outl\\strokewidth%u ", (NSUInteger)(strokeWidth * 20)];
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)strokeWidthObject resources:(RKResourcePool *)resources
{
    float strokeWidth = [strokeWidthObject floatValue];
    
    if (strokeWidth == 0)
        return @"";

    return @"\\outl0\\strokewidth0 ";
}

@end
