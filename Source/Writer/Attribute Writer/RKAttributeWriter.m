//
//  RKAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeWriter.h"

@implementation RKAttributeWriter

+ (NSString *)stylesheetTagForAttribute:(NSString *)attributeName 
                                  value:(id)value 
                           styleSetting:(NSDictionary *)styleSetting 
                              resources:(RKResourcePool *)resources
{
    return @"";
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(id)value 
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)originalString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources;
{
    NSAssert(NO, @"Method not implemented");
}

+ (void)preprocessAttribute:(NSString *)attributeName
                      value:(id)attributeValue
             effectiveRange:(NSRange)range
         ofAttributedString:(NSMutableAttributedString *)preprocessedString
				usingPolicy:(RKAttributePreprocessingPolicy)preprocessing
{
    return;
}

@end
