//
//  RKSuperscriptAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKSuperscriptAttributeWriter.h"

@implementation RKSuperscriptAttributeWriter

+ (void)load
{
    [RKAttributedStringWriter registerWriter:self forAttribute:RKSuperscriptAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)superScriptModeObject resources:(RKResourcePool *)resources
{
    NSInteger mode = [superScriptModeObject integerValue];
    
    if (mode > 0) {
        return [NSString stringWithFormat:@"\\super "];
    }
    else if (mode < 0) {
        return [NSString stringWithFormat:@"\\sub "];
    }

    return @"";
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)superScriptModeObject resources:(RKResourcePool *)resources
{
    NSInteger mode = [superScriptModeObject integerValue];
    
    if (mode > 0) {
        return [NSString stringWithFormat:@"\\super0 "];
    }
    else if (mode < 0) {
        return [NSString stringWithFormat:@"\\sub0 "];
    }

    return @"";
}

@end
