//
//  RKTextListWriterAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversion.h"
#import "RKTextList.h"
#import "RKTextListWriterAdditions.h"
#import "RKNumberFormatting.h"

@interface RKTextList (RKWriterAdditionsPrivateMethods)

/*!
 @abstract Returns the position of the first prepending placeholder inside a format string
 */
- (NSRange)rangeOfPrependingPlaceholder:(NSString *)formatString;

/*!
 @abstract Returns the position of the first prepending placeholder of a certain level
 */
- (NSRange)rangeOfPrependingPlaceholderOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the position of the first enumeration placeholder inside a format string
 */
- (NSRange)rangeOfEnumerationPlaceholder:(NSString *)formatString;

/*!
 @abstract Returns the position of the first enumeration placeholder of a certain level
 */
- (NSRange)rangeOfEnumerationPlaceholderOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the format definition for a certain level while all level strings of higher levels are inserted
 @description All format strings receive a further number enumerating the level the format string belongs to
 */
- (NSString *)normalizedFormatOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the level number of a placeholder from a normalized format string
 @discussion Expects the position of the placeholder as argument
             Returns 0 on an invalid level
 */
- (NSUInteger)levelFromNormalizedFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position;

/*!
 @abstract Returns the current enumeration index for the level of a placeholder from a format string
 @discussion Expects the position of the placeholder as argument
 Returns 0 on an invalid level
 */
- (NSUInteger)itemNumberFromNormalizedFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position fromItemNumbers:(NSArray *)itemNumbers;

@end

@implementation RKTextList (RKWriterAdditions)

NSDictionary *placeholderCodes;
NSDictionary *cocoaPlaceholderCodes;
NSRegularExpression *prependPlaceholderRegExp;
NSRegularExpression *enumerationPlaceholderRegexp;

+ (void)initialize
{
    prependPlaceholderRegExp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%\\*" options:0 error:nil];
    enumerationPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%[drRaA]" options:0 error:nil];
   
    placeholderCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInteger: RKTextListFormatCodeDecimal],           @"%d",
                        [NSNumber numberWithInteger: RKTextListFormatCodeLowerCaseRoman],     @"%r",
                        [NSNumber numberWithInteger: RKTextListFormatCodeUpperCaseRoman],     @"%R",
                        [NSNumber numberWithInteger: RKTextListFormatCodeLowerCaseLetter],    @"%a",
                        [NSNumber numberWithInteger: RKTextListFormatCodeUpperCaseLetter],    @"%A",
                        nil
                        ];
    
    cocoaPlaceholderCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"\\{decimal\\}",         @"%d",
                        @"\\{lower-roman\\}",     @"%r",
                        @"\\{upper-roman\\}",     @"%R",
                        @"\\{lower-alpha\\}",     @"%a",
                        @"\\{upper-alpha\\}",     @"%A",
                        nil
                        ];    
}

- (NSRange)rangeOfPrependingPlaceholder:(NSString *)formatString
{
    return [prependPlaceholderRegExp rangeOfFirstMatchInString:formatString options:0 range:NSMakeRange(0, formatString.length)];
}

- (NSRange)rangeOfPrependingPlaceholderOfLevel:(NSUInteger)levelIndex
{
    NSString *formatString = [self formatOfLevel:levelIndex];
    
    return [self rangeOfPrependingPlaceholder: formatString];
}

- (BOOL)isPrependingLevel:(NSUInteger)levelIndex
{
   return [self rangeOfPrependingPlaceholderOfLevel: levelIndex].location != NSNotFound;
}

- (NSRange)rangeOfEnumerationPlaceholder:(NSString *)formatString
{
    return [enumerationPlaceholderRegexp rangeOfFirstMatchInString:formatString options:0 range:NSMakeRange(0, formatString.length)];
}

- (NSRange)rangeOfEnumerationPlaceholderOfLevel:(NSUInteger)levelIndex
{
    NSString *formatString = [self formatOfLevel: levelIndex];

    return [self rangeOfEnumerationPlaceholder: formatString];
}

- (NSString *)enumerationPlaceholderOfLevel:(NSUInteger)levelIndex
{
    NSRange firstMatch = [self rangeOfEnumerationPlaceholderOfLevel: levelIndex];
    
    if (firstMatch.location != NSNotFound) {
        NSString *formatString = [self formatOfLevel:levelIndex];
        
        return [formatString substringWithRange:firstMatch];
    }
    else {
        return nil;
    }
}

- (NSString *)normalizedFormatOfLevel:(NSUInteger)levelIndex
{
    NSMutableString *normalizedFormat = [NSMutableString stringWithString: @"%*"];
                                         
    do {
        NSMutableString *nextLevelFormat = [NSMutableString stringWithString: [self formatOfLevel: levelIndex]];
        
        // Add level index, if it exists
        NSRange enumerationPlaceholderPosition = [self rangeOfEnumerationPlaceholder: nextLevelFormat];
        
        if (enumerationPlaceholderPosition.location != NSNotFound) {
            [nextLevelFormat insertString:[NSString stringWithFormat:@"%u", levelIndex] atIndex:enumerationPlaceholderPosition.location + enumerationPlaceholderPosition.length];
        }
        
        // Exchange generated level string with placeholder
        NSRange prependPlaceholderPosition = [self rangeOfPrependingPlaceholder: normalizedFormat];
        [normalizedFormat replaceCharactersInRange:prependPlaceholderPosition withString:nextLevelFormat];
    }while ([self isPrependingLevel: levelIndex] && levelIndex --);

    return normalizedFormat;
}

- (NSString *)cocoaRTFFormatCodeOfLevel:(NSUInteger)levelIndex
{
    NSString *formatPlaceholder = [self enumerationPlaceholderOfLevel: levelIndex];
    
    if (formatPlaceholder != nil)
        return [cocoaPlaceholderCodes objectForKey: formatPlaceholder];
    else
        return @"";
}

- (NSString *)cocoaRTFFormatStringOfLevel:(NSUInteger)levelIndex
{
    NSMutableString *cocoaFormatString = [NSMutableString stringWithString: [self formatOfLevel: levelIndex]];
    NSRange enumerationPlaceholderPosition = [self rangeOfEnumerationPlaceholderOfLevel: levelIndex];
    
    if (enumerationPlaceholderPosition.location != NSNotFound) {
        [cocoaFormatString replaceCharactersInRange:enumerationPlaceholderPosition withString:[self cocoaRTFFormatCodeOfLevel: levelIndex]];
    }
    
    NSRange prependingPlaceholderPosition = [self rangeOfPrependingPlaceholderOfLevel: levelIndex];
    
    if (prependingPlaceholderPosition.location != NSNotFound) {
        [cocoaFormatString deleteCharactersInRange: prependingPlaceholderPosition];
    }
        
    return cocoaFormatString;
}

- (RKTextListFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex
{
    NSString *formatPlaceholder = [self enumerationPlaceholderOfLevel: levelIndex];
    
    if (formatPlaceholder != nil)
        return [[placeholderCodes objectForKey: formatPlaceholder] intValue ];
    else
        return RKTextListFormatCodeBullet;
}

- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositionsOut
{
    NSString *formatString = [self normalizedFormatOfLevel: levelIndex];
    NSMutableString *rtfFormat = [NSMutableString new];
    NSUInteger tokenCount = 0;
    NSMutableArray *placeholderPositions = [NSMutableArray new];
    
    for (NSUInteger position = 0; position < formatString.length; position ++) {
        NSString *currentToken = nil;
        unichar currentChar = [formatString characterAtIndex:position];
        
        if ((currentChar == '%') && (position + 1 < formatString.length)) {
            position ++;
            unichar placeholderCommand = [formatString characterAtIndex: position];
            
            switch(placeholderCommand) {
                case '%':
                    currentToken = [@"%" RTFEscapedString];
                    break;
                    
                case 'd':
                case 'r':
                case 'R':
                case 'a':
                case 'A':
                    currentToken = [NSString stringWithFormat:@"\\'%.2x", [self levelFromNormalizedFormatString:formatString atPlaceholderPosition:position]];
                    position ++;   
                    
                    [placeholderPositions addObject: [NSNumber numberWithUnsignedInteger: tokenCount + 2]];
                        
                    break;
            }
        }
        else {
            currentToken = [[NSString stringWithFormat:@"%C", currentChar] RTFEscapedString];
        }
        
        [rtfFormat appendString: currentToken];
        
        tokenCount ++;
    }    
    
    *placeholderPositionsOut = placeholderPositions;
    
    return [NSString stringWithFormat:@"\\'%.2x\t%@\t", tokenCount + 2, rtfFormat];
}

- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers
{
    NSUInteger destinationLevel = itemNumbers.count - 1;
    NSString *formatString = [self normalizedFormatOfLevel: destinationLevel];

    NSMutableString *markerString = [NSMutableString new];
    
    for (NSUInteger position = 0; position < formatString.length; position ++) {
        NSString *currentMarker = nil;
        unichar currentChar = [formatString characterAtIndex:position];
        
        if ((currentChar == '%') && (position + 1 < formatString.length)) {
            position ++;
            unichar placeholderCommand = [formatString characterAtIndex: position];

            if (placeholderCommand == '%') {
                currentMarker = @"%";
            }
            else {
                NSUInteger itemNumber = [self itemNumberFromNormalizedFormatString:formatString atPlaceholderPosition:position fromItemNumbers:itemNumbers];
                position ++;
                
                if (itemNumber == NSNotFound) {
                    // Invalid level number used
                    currentMarker = @"??";
                }
                 else
                {
                    switch(placeholderCommand) {
                        case '%':
                            currentMarker = @"%";
                            break;
                            
                        case 'd':
                            currentMarker = [NSString stringWithFormat:@"%d", itemNumber];
                            break;
                            
                        case 'r':
                            currentMarker = [NSString lowerCaseRomanNumeralsFromUnsignedInteger: itemNumber];
                            break;
                            
                        case 'R':
                            currentMarker = [NSString upperCaseRomanNumeralsFromUnsignedInteger: itemNumber];
                            break;

                        case 'a':
                            currentMarker = [NSString lowerCaseAlphabeticNumeralsFromUnsignedInteger: itemNumber];
                            break;

                        case 'A':
                            currentMarker = [NSString upperCaseAlphabeticNumeralsFromUnsignedInteger: itemNumber];
                            break;
                            
                    }                     
                }
            }
        }
        else {
            currentMarker = [NSString stringWithFormat:@"%C", currentChar];
        }
        
        [markerString appendString: [currentMarker RTFEscapedString]];
    }    
    
    return [NSString stringWithFormat:@"\t%@\t", markerString];
}

- (NSUInteger)levelFromNormalizedFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position
{
    NSAssert (position + 1 < formatString.length, @"Format string not correctly normalized");
    
    return [[formatString substringWithRange:NSMakeRange(position + 1, 1)] integerValue];
}

- (NSUInteger)itemNumberFromNormalizedFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position fromItemNumbers:(NSArray *)itemNumbers
{
    NSUInteger level = [self levelFromNormalizedFormatString:formatString atPlaceholderPosition:position];
    
    if (itemNumbers.count < level)
        return NSNotFound;
    
    return [[itemNumbers objectAtIndex: level] unsignedIntegerValue];
}

@end
