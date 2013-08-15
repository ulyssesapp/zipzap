//
//  RKInlineStyleWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 17.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKInlineStyleWriter.h"

@implementation RKInlineStyleWriter

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(id)value resources:(RKResourcePool *)resources
{
    NSAssert(NO, @"Missing implementation of abstract method");
    
    return @"";
}

/*!
 @abstract Abstract method that delivers an closing tag for a certain inline style
 @discussion Returns an empty string, if the attribute is inactive or must not be closed
 */
+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(id)value resources:(RKResourcePool *)resources
{
    NSAssert(NO, @"Missing implementation of abstract method");
    
    return @"";
}

+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName 
                                  value:(id)value 
                           styleSetting:(NSDictionary *)styleSetting 
                              resources:(RKResourcePool *)resources
{
    return [self openingTagsForAttribute:attributeName value:value resources:resources];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(id)value 
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)originalString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources;
{
    [taggedString registerTag:[self openingTagsForAttribute:attributeName value:value resources:resources] forPosition:range.location];
    [taggedString registerClosingTag:[self closingTagsForAttribute:attributeName value:value resources:resources] forPosition:NSMaxRange(range)];
}

@end
