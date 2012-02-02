//
//  RKTextListConversionAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextList.h"
#import "RKTextListConversionAdditions.h"

@implementation RKTextList (RKConversionAdditions)

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

-(RKTextListFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex
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

-(NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositions
{
    
}

-(NSString *)markerForItemNumber:(NSUInteger)itemNumber forLevels:(NSArray *)levelIndices
{
    return @"";
}


@end
