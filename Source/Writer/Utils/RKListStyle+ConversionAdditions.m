//
//  RKListStyleConversionAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+ConversionAdditions.h"

@implementation RKListStyle (ConversionAdditions)

+ (NSNumber *)formatCodeFromEnumerationPlaceholder:(NSString *)placeholder
{
    static NSDictionary *placeholderCodes = nil;
    placeholderCodes = (placeholderCodes) ?: @{@"%d": @(RKListFormatCodeDecimal),
                                              @"%r": @(RKListFormatCodeLowerCaseRoman),
                                              @"%R": @(RKListFormatCodeUpperCaseRoman),
                                              @"%a": @(RKListFormatCodeLowerCaseLetter),
                                              @"%A": @(RKListFormatCodeUpperCaseLetter)};
    
    return placeholderCodes[placeholder];
}

+ (NSString *)systemFormatCodeFromEnumerationPlaceholder:(NSString *)placeholder
{
    static NSDictionary *textSystemPlaceholder = nil;
    textSystemPlaceholder = (textSystemPlaceholder) ?: @{@"%d": @"{decimal}",
                                                        @"%r": @"{lower-roman}",
                                                        @"%R": @"{upper-roman}",
                                                        @"%a": @"{lower-alpha}",
                                                        @"%A": @"{upper-alpha}"};   
    
    return textSystemPlaceholder[placeholder];
}

@end
