//
//  RKListStyleWriterAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+FormatStringParserAdditions.h"
#import "RKListStyle+WriterAdditions.h"
#import "RKConversion.h"
#import "NSString+RKNumberFormatting.h"

@implementation RKListStyle (WriterAdditions)

#pragma mark - Internal helper

+ (NSString *)systemCompatibleMarker:(NSString *)marker
{
    return [NSString stringWithFormat:@"\t%@\t", marker];
}

#pragma mark - Text system header generation

- (NSString *)systemFormatOfLevel:(NSUInteger)levelIndex
{
    NSString *formatString = [self formatForLevel: levelIndex];
    
    // Replace enumeration placeholder
    NSRange enumerationPlaceholderRange = [self.class rangeOfEnumerationPlaceholder: formatString];
    
    if (enumerationPlaceholderRange.length) {
        NSString *textSystemCode = [self.class systemFormatCodeFromEnumerationPlaceholder:[formatString substringWithRange:enumerationPlaceholderRange]];
        
        formatString = [formatString stringByReplacingCharactersInRange:enumerationPlaceholderRange withString:textSystemCode];
    }
    
    // Remove link level placeholder if it exists
    NSRange linkedLevelPlaceholderRange = [self.class rangeOfLinkedLevelPlaceholder: formatString];
    BOOL hasLevelLink = linkedLevelPlaceholderRange.length != 0;
    
    if (hasLevelLink) {
        formatString = [formatString stringByReplacingCharactersInRange:linkedLevelPlaceholderRange withString:@""];
    }
    
    // Generate placeholder
    return [NSString stringWithFormat:@"{\\*\\levelmarker %@}%@",
            [[formatString stringByReplacingOccurrencesOfString:@"%%" withString:@"%"] RTFEscapedString],
            hasLevelLink ? @"\\levelprepend" : @ ""
            ];
}

#pragma mark - RTF header writing

- (RKListStyleFormatCode)formatCodeOfLevel:(NSUInteger)levelIndex
{
    NSString *formatString = [self formatForLevel: levelIndex];
    NSRange enumerationPlaceholderRange = [self.class rangeOfEnumerationPlaceholder: formatString];
    RKListStyleFormatCode formatCode = RKListFormatCodeBullet;
    
    if (enumerationPlaceholderRange.length) {
        formatCode = [[self.class formatCodeFromEnumerationPlaceholder: [formatString substringWithRange: enumerationPlaceholderRange]] unsignedIntegerValue];
    }
    
    return formatCode;
}

- (NSString *)formatStringOfLevel:(NSUInteger)levelIndex placeholderPositions:(NSArray **)placeholderPositionsOut
{
    __block NSMutableString *formatString = [NSMutableString new];
    __block NSMutableArray *placeholderPositions = [NSMutableArray new];
    
    // The token count starts at 2, since the prefixing \t and the length modifier must be counted
    __block NSUInteger RTFTokenCount = 2;
    
    [self scanFullFormatStringOfLevel:levelIndex usingBlock:^(id token, NSUInteger currentLevel) {
        if ([token isKindOfClass:NSNumber.class]) {
            // Store placeholder position
            [placeholderPositions addObject: @(RTFTokenCount)];

            // Format placeholder token
            token = [NSString stringWithFormat:@"\\'%.2lx", currentLevel];
            RTFTokenCount ++;
        }
        else {
            // Other string token
            RTFTokenCount += [token length];
            token = [token RTFEscapedString];
        }
        
        [formatString appendString: token];
    }];
    
    *placeholderPositionsOut = placeholderPositions;
    
    return [NSString stringWithFormat:@"\\'%.2lx%@", RTFTokenCount, [self.class systemCompatibleMarker: formatString]];
}

#pragma mark - List item marker writing

- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers
{
    NSUInteger levelIndex = itemNumbers.count;
    NSMutableString *markerString = [NSMutableString new];
    
    [self scanFullFormatStringOfLevel:levelIndex-1 usingBlock:^(id token, NSUInteger currentLevel) {
        if ([token isKindOfClass:NSNumber.class]) {
            // Format placeholder token
            NSUInteger currentItemNumber = [itemNumbers[currentLevel] unsignedIntegerValue];
            
            switch ([token unsignedIntegerValue]) {
                case RKListFormatCodeDecimal:
                    token = [NSString stringWithFormat:@"%lu", currentItemNumber];
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
        
        [markerString appendString: token];
    }];
    
    return markerString;
}

@end