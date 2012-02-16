//
//  RKListStyleConversionAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyleConversionAdditions.h"

@implementation RKListStyle (RKListStyleConversionAdditions)

+ (NSNumber *)RTFFormatCodeFromPlaceholder:(NSString *)placeholder
{
    static NSDictionary *placeholderCodes = nil;
    placeholderCodes = (placeholderCodes) ?: [NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithInteger: RKListFormatCodeDecimal],            @"%d",
                                              [NSNumber numberWithInteger: RKListFormatCodeLowerCaseRoman],     @"%r",
                                              [NSNumber numberWithInteger: RKListFormatCodeUpperCaseRoman],     @"%R",
                                              [NSNumber numberWithInteger: RKListFormatCodeLowerCaseLetter],    @"%a",
                                              [NSNumber numberWithInteger: RKListFormatCodeUpperCaseLetter],    @"%A",
                                              nil
                                              ];
    
    return [placeholderCodes objectForKey: placeholder];
}

+ (NSString *)textSystemPlaceholderFromPlaceholder:(NSString *)placeholder
{
    static NSDictionary *textSystemPlaceholder = nil;
    textSystemPlaceholder = (textSystemPlaceholder) ?: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        @"{decimal}",         @"%d",
                                                        @"{lower-roman}",     @"%r",
                                                        @"{upper-roman}",     @"%R",
                                                        @"{lower-alpha}",     @"%a",
                                                        @"{upper-alpha}",     @"%A",
                                                        nil
                                                        ];   
    
    return [textSystemPlaceholder objectForKey: placeholder];
}

@end
