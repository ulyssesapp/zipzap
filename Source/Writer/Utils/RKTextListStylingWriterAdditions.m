//
//  RKTextListConversionAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversion.h"
#import "RKTextListStyling.h"
#import "RKTextListStylingWriterAdditions.h"

@implementation RKTextListStyling (RKWriterAdditions)

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
        if ([levelString rangeOfString: placeholder].location != NSNotFound) {
            *stop = true;
            formatCode = [code intValue];
        }
    }];
    
    return formatCode;
}

- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositionsOut
{
    NSString *formatString = [self formatOfLevel:levelIndex];
    NSMutableString *rtfFormat = [NSMutableString new];
    NSUInteger tokenCount = 0;
    NSMutableArray *placeholderPositions = [NSMutableArray new];
    
    for (NSUInteger position = 0; position < formatString.length; position ++) {
        NSString *currentToken = nil;
        unichar currentChar = [formatString characterAtIndex:position];
        
        if ((currentChar == '%') && (position + 1 < formatString.length)) {
            position ++;
            currentChar = [formatString characterAtIndex: position];
            
            switch(currentChar) {
                case '%':
                    currentToken = @"%";
                    break;
                    
                case 'd':
                case 'r':
                case 'R':
                case 'a':
                case 'A':
                    if (position + 1 < formatString.length) {
                        position ++;

                        NSInteger level = [[formatString substringWithRange:NSMakeRange(position, 1)] integerValue];
                        
                        currentToken = [NSString stringWithFormat:@"\\'0%x", level];
                        
                        [placeholderPositions addObject: [NSNumber numberWithUnsignedInteger: tokenCount + 1]];
                        
                        break;
                    }
            }
        }
        else {
            currentToken = [[NSString stringWithFormat:@"%C", currentChar] RTFEscapedString];
        }
        
        [rtfFormat appendString: currentToken];
        
        tokenCount ++;
    }    
    
    *placeholderPositionsOut = placeholderPositions;
    
    return [NSString stringWithFormat:@"\\'%.2x%@", tokenCount, rtfFormat];
}

- (NSString *)markerForItemNumber:(NSUInteger)itemNumber forLevels:(NSArray *)levelIndices
{
    return @"";
}


@end
