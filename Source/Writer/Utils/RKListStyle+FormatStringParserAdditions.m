//
//  RKListStyleFormatStringParserAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversion.h"
#import "RKListStyle.h"
#import "RKListStyle+FormatStringParserAdditions.h"
#import "NSString+RKConvenienceAdditions.h"

@implementation RKListStyle (FormatStringParserAdditions)

#pragma mark - Extraction of placeholders

+ (NSRange)rangeOfEnumerationPlaceholder:(NSString *)formatString
{
    static NSRegularExpression *placeholderExpression;
    placeholderExpression = (placeholderExpression) ?: [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%[drRaA]" options:0 error:nil];
    
    return [placeholderExpression rangeOfFirstMatchInString:formatString options:0 range:NSMakeRange(0, formatString.length)];
}

+ (NSRange)rangeOfLinkedLevelPlaceholder:(NSString *)formatString
{
    static NSRegularExpression *placeholderExpression;
    placeholderExpression = (placeholderExpression) ?: [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%\\*" options:0 error:nil];
    
    return [placeholderExpression rangeOfFirstMatchInString:formatString options:0 range:NSMakeRange(0, formatString.length)];
}

#pragma mark - Full format string operations

- (void)scanFullFormatStringOfLevel:(NSUInteger)levelIndex usingBlock:(void (^)(NSString *token, NSUInteger currentLevel))block
{
    static NSRegularExpression *tokenRegEx;
    tokenRegEx = (tokenRegEx) ?: [NSRegularExpression regularExpressionWithPattern:@"%[%*daArR]" options:0 error:nil];

    NSMutableArray *tokens = [NSMutableArray new];
    NSMutableArray *levels = [NSMutableArray new];

    // Collect all tokens    
    __block NSUInteger insertAt = 0;
    
    for (NSInteger currentLevelIndex = levelIndex; currentLevelIndex >= 0; currentLevelIndex --) {
        NSString *formatString = [self formatForLevel: currentLevelIndex];
        NSUInteger nextInsert = NSNotFound;

        // Scan tokens of current level
        for (NSString *token in [formatString componentsSeparatedByRegularExpression: tokenRegEx]) {
            if ([token isEqual: @"%*"]) {
                // Remember the level link placeholder
                nextInsert = insertAt;
            }
            else {
                // Translate or keep token
                id insertToken;

                if ([token isEqual: @"%%"]) {
                    insertToken = @"%";
                }
                 else if ([token hasPrefix: @"%"]) {
                    insertToken = [self.class formatCodeFromEnumerationPlaceholder: token];
                }
                 else {
                     insertToken = token;
                }
                
                // Store token and the level to which it belongs
                [tokens insertObject:insertToken atIndex:insertAt];
                [levels insertObject:[NSNumber numberWithUnsignedInteger:currentLevelIndex] atIndex:insertAt];
                
                insertAt ++;
            }
        }
        
        if (nextInsert == NSNotFound)
            break;
        else
            insertAt = nextInsert;
    }

    // Iterate over all tokens
    [tokens enumerateObjectsUsingBlock:^(NSString *token, NSUInteger tokenIndex, BOOL *stop) {
        block(token, [levels[tokenIndex] unsignedIntegerValue]);
    }];
}

@end
