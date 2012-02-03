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

@interface RKTextListStyling (RKWriterAdditionsPrivateMethods)

/*!
 @abstract Returns the RTF format string for a single level without prepending
 @discussion "relativePlaceholderPosition" will contain the position of the level place holder
             "prependRange" will contain the position of a prepend tag, if exists. Otherwise, it is set to NSNotFound
 */
- (NSString *)singleRTFFormatStringOfLevel:(NSUInteger)levelIndex 
                            withTokenCount:(NSUInteger *)length  
                                prependsAt:(NSRange *)prependRange;

/*!
 @abstract Determins all placeholder positions from an RTF format string
 */
- (NSArray *)placeholderPositionsForString:(NSString *)rtfFormatString;

@end

@implementation RKTextListStyling (RKWriterAdditions)

NSDictionary *placeholderCodes;

+ (void)initialize
{
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

- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositions
{
    NSMutableString *rtfFormat = [NSMutableString new];
    NSUInteger currentLevelIndex = levelIndex;
    NSUInteger totalTokenCount = 0;
    NSRange insertionRange = NSMakeRange(0, 0);
    
    while(1) {
        NSUInteger tokenCount;
        NSRange currentPrependRange;
        
        // Get single format token
        NSString *singleFormat = [self singleRTFFormatStringOfLevel:currentLevelIndex 
                                                     withTokenCount:&tokenCount 
                                                         prependsAt:&currentPrependRange
                                 ];
        
        totalTokenCount += tokenCount;
        
        // Insert converted token string
        [rtfFormat replaceCharactersInRange:insertionRange withString:singleFormat];
        
        // Prepend to previous level?
        if ((currentPrependRange.location != NSNotFound) && (currentLevelIndex)) {
            currentLevelIndex --;
            
            // Setup the next replacement position
            insertionRange.location = insertionRange.location + currentPrependRange.location;
        }
        else {
            // No further levels
            break;
        }
    }    
    
    *placeholderPositions = [self placeholderPositionsForString:rtfFormat];
    
    return [NSString stringWithFormat:@"\\'%.2i%@", totalTokenCount, rtfFormat];
}

- (NSString *)singleRTFFormatStringOfLevel:(NSUInteger)levelIndex 
                            withTokenCount:(NSUInteger *)length 
                                prependsAt:(NSRange *)prependRange
{
    NSString *formatString = [self formatOfLevel: levelIndex];
    NSMutableString *rtfFormat = [NSMutableString new];
    NSUInteger tokenCount = 0;
    
    prependRange->location = NSNotFound;
    
    for (NSUInteger position = 0; position < formatString.length; position ++) {
        NSString *currentToken = [formatString substringWithRange: NSMakeRange(position, 1)];
        
        if (([currentToken isEqual:@"%"]) && (position < formatString.length - 1)) {
            position ++;
            
            switch ([formatString characterAtIndex:position]) {
                    // Convert %% to %
                    case '%':
                        currentToken = [@"%" RTFEscapedString];
                        break;
                    
                    // Setup \'XX marker for all replacable tokens
                    case 'd':
                    case 'r':
                    case 'R':
                    case 'a':
                    case 'A':
                        currentToken = [NSString stringWithFormat: @"\\'%.2i", levelIndex - 1];
                        break;
                    
                    // Remember prepend marker
                    case '*':
                        *prependRange = NSMakeRange(position - 1, 2);
                        break;
            }
        }
        else {
            currentToken = [currentToken RTFEscapedString];
        }

        tokenCount ++;
        
        [rtfFormat appendString: currentToken];
    }
    
    *length = tokenCount;
    
    return rtfFormat ;
}

- (NSArray *)placeholderPositionsForString:(NSString *)rtfFormatString
{
    NSMutableArray *placeholderPositions = [NSMutableArray new];
    NSRange searchRange = NSMakeRange(0, rtfFormatString.length);
    
    while (searchRange.length < 2) {
        NSRange occurence = [rtfFormatString rangeOfString:@"\\'" options:0 range:searchRange];
        
        if (occurence.location == NSNotFound) {
            break;
        }
         else {
            searchRange.location = occurence.location + 2;
            searchRange.length = rtfFormatString.length - (occurence.location + 2);
             
             [placeholderPositions addObject:[NSNumber numberWithUnsignedInteger:occurence.location + 1]];
        }
    }
    
    return placeholderPositions;
}

- (NSString *)markerForItemNumber:(NSUInteger)itemNumber forLevels:(NSArray *)levelIndices
{
    return @"";
}


@end
