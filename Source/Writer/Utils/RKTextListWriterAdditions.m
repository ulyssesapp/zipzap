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
 @abstract Returns the level number of a placeholder from a format string
 @discussion Expects the position of the placeholder as argument
             Returns 0 on an invalid level
 */
- (NSUInteger)levelFromFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position;

/*!
 @abstract Returns the current enumeration index for the level of a placeholder from a format string
 @discussion Expects the position of the placeholder as argument
 Returns 0 on an invalid level
 */
- (NSUInteger)itemNumberFromFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position fromItemNumbers:(NSArray *)itemNumbers;

@end

@implementation RKTextList (RKWriterAdditions)

NSDictionary *placeholderCodes;
NSRegularExpression *placeholderRegExp;

+ (void)initialize
{
    placeholderRegExp = [NSRegularExpression regularExpressionWithPattern:@"(\\\\[a-zA-Z0-9]+|\\\\|\\\\'[0-9]{2}|[^\\\\])" options:0 error:nil];
    
    placeholderCodes = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInteger: RKTextListFormatCodeDecimal],           @"%d",
                        [NSNumber numberWithInteger: RKTextListFormatCodeLowerCaseRoman],     @"%r",
                        [NSNumber numberWithInteger: RKTextListFormatCodeUpperCaseRoman],     @"%R",
                        [NSNumber numberWithInteger: RKTextListFormatCodeLowerCaseLetter],    @"%a",
                        [NSNumber numberWithInteger: RKTextListFormatCodeUpperCaseLetter],    @"%A",
                        nil
                        ];
}

- (RKTextListFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex
{
    NSString *levelString = [self formatOfLevel: levelIndex];
    __block RKTextListFormatCode formatCode = RKTextListFormatCodeBullet;
    
    [placeholderCodes enumerateKeysAndObjectsUsingBlock:^(NSString *placeholder, NSNumber *code, BOOL *stop) {
        NSUInteger placeholderLocation = [levelString rangeOfString: placeholder].location;
        
        if (placeholderLocation != NSNotFound) {
            NSUInteger level = [self levelFromFormatString:levelString atPlaceholderPosition:placeholderLocation + 1];
            
            // Take only placeholders that really belong to the selected level
            if (level == levelIndex) {            
                *stop = true;
                formatCode = [code intValue];
            }
        }
    }];
    
    return formatCode;
}

- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositionsOut
{
    NSString *formatString = [self formatOfLevel: levelIndex];
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
                    currentToken = [NSString stringWithFormat:@"\\'%.2x", [self levelFromFormatString:formatString atPlaceholderPosition:position]];
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
    NSString *formatString = [self formatOfLevel: destinationLevel];

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
                NSUInteger itemNumber = [self itemNumberFromFormatString:formatString atPlaceholderPosition:position fromItemNumbers:itemNumbers];
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

- (NSUInteger)levelFromFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position
{
    if (position + 1 >= formatString.length)
        return 0;
    
    return [[formatString substringWithRange:NSMakeRange(position + 1, 1)] integerValue];
}

- (NSUInteger)itemNumberFromFormatString:(NSString *)formatString atPlaceholderPosition:(NSUInteger)position fromItemNumbers:(NSArray *)itemNumbers
{
    NSUInteger level = [self levelFromFormatString:formatString atPlaceholderPosition:position];
    
    if (itemNumbers.count < level)
        return NSNotFound;
    
    return [[itemNumbers objectAtIndex: level] unsignedIntegerValue];
}

@end
