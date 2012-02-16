//
//  RKTextListWriterAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversion.h"
#import "RKListStyle.h"
#import "RKListWriterAdditions.h"
#import "RKNumberFormatting.h"
#import "RKStringConvenienceAdditions.h"

@interface RKListStyle (RKListWriterAdditionsPrivateMethods)

/*!
 @abstract Executes the given block for each token of a full format string
 @discussion A full format string contains all format strings of all levels that have been append by %*
             A token is either:
                NSString        Ordinary string
                NSNumber        A RKListStyleFormatCode representing the format code
             Besides the token, the block receives also the level index of the format string to which the token belongs
 */
- (void)scanFullFormatStringFromLevel:(NSUInteger)levelIndex usingBlock:(void (^)(NSString *token, NSUInteger tokenLevel))block;

/*!
 @abstract Returns the range of the first enumeration placeholder inside a format string
 */
+ (NSRange)rangeOfFormatPlaceholder:(NSString *)formatString;

/*!
 @abstract Returns the range of the first level link placeholder inside a format string
 */
+ (NSRange)rangeOfLinkedLevelPlaceholder:(NSString *)formatString;

/*!
 @abstract Returns the placeholder used by the text system in the \levelmarker header.
 @discussion Requires a format string and the position of the enumeration placeholder within the format string
 */
+ (NSString *)textSystemPlaceholderFromFormatString:(NSString *)formatString range:(NSRange)range;

/*!
 @abstract The Cocoa text system requires all marker strings to be enclosed in tabs
 @discussion These tabs must be real "\t" charracters. Using \tab will break compatability
 */
+ (NSString *)textSystemCompatibleMarker:(NSString *)marker;

/*!
 @abstract Returns the format code that belongs to a placeholder as an object containing an RKListStyleFormatCode constant
 */
+ (NSNumber *)RTFFormatCodeFromPlaceholder:(NSString *)placeholder;

@end

@implementation RKListStyle (RKListWriterAdditions)

#pragma mark - Internal helper

+ (NSRange)rangeOfFormatPlaceholder:(NSString *)formatString
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

+ (NSString *)textSystemCompatibleMarker:(NSString *)marker
{
    return [NSString stringWithFormat:@"\t%@\t", marker];
}

#pragma mark - Text system header generation

- (NSString *)textSystemPlaceholderFromFormatString:(NSString *)formatString range:(NSRange)range
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
    
    NSString *placeholder = [formatString substringWithRange: range];
    
    return [textSystemPlaceholder objectForKey: placeholder];
}

- (NSString *)textSystemFormatOfLevel:(NSUInteger)levelIndex
{
    NSString *formatString = [self formatForLevel: levelIndex];

    // Replace enumeration placeholder
    NSRange enumerationPlaceholderRange = [self.class rangeOfFormatPlaceholder: formatString];

    if (enumerationPlaceholderRange.length) {
        NSString *textSystemCode = [self textSystemPlaceholderFromFormatString:formatString range:enumerationPlaceholderRange];

        formatString = [formatString stringByReplacingCharactersInRange:enumerationPlaceholderRange withString:textSystemCode];
    }
    
    // Remove link level placeholder if it exists
    NSRange linkedLevelPlaceholderRange = [self.class rangeOfLinkedLevelPlaceholder: formatString];
    BOOL hasLevelLink = linkedLevelPlaceholderRange.length != 0;
    
    if (hasLevelLink) {
        formatString = [formatString stringByReplacingCharactersInRange:linkedLevelPlaceholderRange withString:@""];
    }
    
    return [NSString stringWithFormat:@"{\\*\\levelmarker %@}%@",
            [[formatString stringByReplacingOccurrencesOfString:@"%%" withString:@"%"] RTFEscapedString],
            hasLevelLink ? @"\\levelprepend" : @ ""
            ];
}

#pragma mark - RTF format code generation

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

- (RKListStyleFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex
{
    NSString *formatString = [self formatForLevel: levelIndex];
    NSRange enumerationPlaceholderRange = [self.class rangeOfFormatPlaceholder: formatString];
    RKListStyleFormatCode formatCode = RKListFormatCodeBullet;
    
    if (enumerationPlaceholderRange.length) {
        formatCode = [[self.class RTFFormatCodeFromPlaceholder: [formatString substringWithRange: enumerationPlaceholderRange]] intValue];
    }
    
    return formatCode;
}

#pragma mark - Full format string operations

- (void)scanFullFormatStringFromLevel:(NSUInteger)levelIndex usingBlock:(void (^)(NSString *token, NSUInteger currentLevel))block
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
            if ([token isEqualTo: @"%*"]) {
                // Remember the level link placeholder
                nextInsert = insertAt;
            }
            else {
                // Translate or keep token
                id insertToken;

                if ([token isEqualTo: @"%%"]) {
                    insertToken = @"%";
                }
                 else if ([token hasPrefix: @"%"]) {
                    insertToken = [self.class RTFFormatCodeFromPlaceholder: token];
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
        block(token, [[levels objectAtIndex: tokenIndex] unsignedIntegerValue]);
    }];
}

- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex placeholderPositions:(NSArray **)placeholderPositionsOut
{
    __block NSMutableString *formatString = [NSMutableString new];
    __block NSMutableArray *placeholderPositions = [NSMutableArray new];
    
    // The token counting starts at 2, since the prefixing \t and the length modifier is counted
    __block NSUInteger RTFTokenCount = 2;
        
    [self scanFullFormatStringFromLevel:levelIndex usingBlock:^(NSString *token, NSUInteger currentLevel) {
        if ([token isKindOfClass:NSNumber.class]) {
            // Format placeholder token
            token = [NSString stringWithFormat:@"\\'%.2x", currentLevel];
            RTFTokenCount ++;

            // Store placeholder position
            [placeholderPositions addObject: [NSNumber numberWithUnsignedInteger: RTFTokenCount]];
        }
        else {
            // Other string token
            RTFTokenCount += token.length;
            token = [token RTFEscapedString];
        }

        [formatString appendString: token];
    }];
    
    *placeholderPositionsOut = placeholderPositions;
    
    return [NSString stringWithFormat:@"\\'%.2x%@", RTFTokenCount, [self.class textSystemCompatibleMarker: formatString]];
}

- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers
{
    NSUInteger levelIndex = itemNumbers.count;
    NSMutableString *markerString = [NSMutableString new];
    
    [self scanFullFormatStringFromLevel:levelIndex-1 usingBlock:^(NSString *token, NSUInteger currentLevel) {
        if ([token isKindOfClass:NSNumber.class]) {
            // Format placeholder token
            NSUInteger currentItemNumber = [[itemNumbers objectAtIndex:currentLevel] unsignedIntegerValue];
            
            switch ([token intValue]) {
                case RKListFormatCodeDecimal:
                    token = [NSString stringWithFormat:@"%u", currentItemNumber];
                    break;
                
                case RKListFormatCodeLowerCaseLetter:
                    token = [NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger: currentItemNumber];
                    break;

                case RKListFormatCodeUpperCaseLetter:
                    token = [NSString upperCaseAlphabeticNumeralsFromUnsignedInteger: currentItemNumber];
                    break;

                case RKListFormatCodeLowerCaseRoman:
                    token = [NSString lowerCaseRomanNumeralsFromUnsignedInteger: currentItemNumber];
                    break;
                    
                case RKListFormatCodeUpperCaseRoman:
                    token = [NSString upperCaseRomanNumeralsFromUnsignedInteger: currentItemNumber];
                    break;
            }
        }
        else {
            // Other string token
            token = [token RTFEscapedString];
        }
        
        [markerString appendString: token];
    }];
    
    return [self.class textSystemCompatibleMarker: markerString];
}

@end
