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
    RKListFormatCodeDecimal             Decimal numbers (e.g. 1, 2, 3, 4, ...)
    RKListFormatCodeUpperCaseRoman      Upper case roman numbers (I, II, III, IV, ..)
    RKListFormatCodeLowerCaseRoman      Lower case roman numbers (i, ii, iii, iv, ...)
    RKListFormatCodeUpperCaseLetter     Upper case letter (A, B, C, D, ...)
    RKListFormatCodeLowerCaseLetter     Lower case letter (a, b, c, d, ...)
    RKListFormatCodeBullet              Arbitary bullet point, no automatic enumeration
 */
typedef enum {
    RKListFormatCodeDecimal             = 0,
    RKListFormatCodeUpperCaseRoman      = 1,
    RKListFormatCodeLowerCaseRoman      = 2,
    RKListFormatCodeUpperCaseLetter     = 3,
    RKListFormatCodeLowerCaseLetter     = 4,
    RKListFormatCodeBullet              = 23
} RKListStyleFormatCode;

@interface RKListStyle (RKListWriterAdditions)

/*!
 @abstract Returns the RTF list level format as required by the Cocoa text system
 @discussion If no format code exists in the level an empty string is returned
 */
- (NSString *)textSystemFormatOfLevel:(NSUInteger)levelIndex;

/*!
 @astract Returns the RTF format code for a level
 @discussion If no format code is given at a certain level an RKTextListFormatCodeBullet is returned.
 */
- (RKListStyleFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the RTF format string of a level as required by the \leveltext tag.
 @discussion To generate the \levelnumbers tag, the array "placeholderPositions" will contain 
 the positions of the format string placeholders in the output string
 To ensure compatibility with the Cocoa text system, all placeholders are automatically enclosed by tabs
 */
- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex placeholderPositions:(NSArray **)placeholderPositionsOut;

/*!
 @abstract Returns the concrete bullet point marker for a certain nesting of list item indices
 @discussion To ensure compatibility with the Cocoa text system, all markers are automatically enclosed by tabs
 */
- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers;

@end
