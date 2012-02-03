//
//  RKTextListWriterAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract RTF format codes for text lists
 @const
 RKTextListFormatCodeDecimal             Decimal numbers (e.g. 1, 2, 3, 4, ...)
 RKTextListFormatCodeUpperCaseRoman      Upper case roman numbers (I, II, III, IV, ..)
 RKTextListFormatCodeLowerCaseRoman      Lower case roman numbers (i, ii, iii, iv, ...)
 RKTextListFormatCodeUpperCaseLetter     Upper case letter (A, B, C, D, ...)
 RKTextListFormatCodeLowerCaseLetter     Lower case letter (a, b, c, d, ...)
 RKTextListFormatCodeBullet              Arbitary bullet point, no automatic enumeration
 */
typedef enum {
    RKTextListFormatCodeDecimal             = 0,
    RKTextListFormatCodeUpperCaseRoman      = 1,
    RKTextListFormatCodeLowerCaseRoman      = 2,
    RKTextListFormatCodeUpperCaseLetter     = 3,
    RKTextListFormatCodeLowerCaseLetter     = 4,
    RKTextListFormatCodeBullet              = 23
} RKTextListFormatCode;

@interface RKTextList (RKWriterAdditions)

/*!
 @astract Returns the RTF format code for a level
 */
-(RKTextListFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the RTF format string of a level as required by the \leveltext tag
 @discussion To generate the \levelnumbers tag, the array "placeholderPositions" will contain 
             the positions of the format string placeholders in the output string
 */
-(NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositions;

/*!
 @abstract Returns the concrete bullet point marker for a certain nesting of list item indices
 */
- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers;

@end
