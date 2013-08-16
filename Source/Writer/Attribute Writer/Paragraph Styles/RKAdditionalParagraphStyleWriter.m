//
//  RKAdditionalParagraphStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAdditionalParagraphStyleWriter.h"

#import "RKAdditionalParagraphStyle.h"
#import "RKAttributedStringWriter.h"
#import "RKTaggedString.h"

@implementation RKAdditionalParagraphStyleWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKAdditionalParagraphStyleAttributeName priority:RKAttributedStringWriterPriorityParagraphAdditionalStylingLevel];
    }
}

+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName
                                  value:(RKAdditionalParagraphStyle *)value
                           styleSetting:(NSDictionary *)styleSetting
                              resources:(RKResourcePool *)resources
{
    if (value.keepWithFollowingParagraph)
        return @"\\keepn ";
    else
        return @"";
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(RKAdditionalParagraphStyle *)value
             effectiveRange:(NSRange)range
                   toString:(RKTaggedString *)taggedString
             originalString:(NSAttributedString *)originalString
           conversionPolicy:(RKConversionPolicy)conversionPolicy
                  resources:(RKResourcePool *)resources;
{
    [taggedString registerTag:[self stylesheetTagForAttribute:attributeName value:value styleSetting:nil resources:resources] forPosition:range.location];
}

@end