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

@interface RKListStyle (RKWriterAdditions)

/*!
 @abstract Returns the placeholder string used in a certain level
 @discussion If no placeholder is used, nil is returned
 */
- (NSString *)enumerationPlaceholderOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns whether the format string of a level requires to insert the format string of another level
 */
- (BOOL)isPrependingLevel:(NSUInteger)levelIndex;

/*!
 @astract Returns the RTF format code for a level as used by cocoa
 */
- (NSString *)cocoaRTFFormatCodeOfLevel:(NSUInteger)levelIndex;

/*!
 @astract Returns the RTF format code for a level
 @discussion If no format code is given at a certain level an RKTextListFormatCodeBullet is returned.
 */
- (RKTextListFormatCode)RTFFormatCodeOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the RTF format string of a level as required by the \leveltext tag.
 @discussion To generate the \levelnumbers tag, the array "placeholderPositions" will contain 
             the positions of the format string placeholders in the output string
             To ensure compatibility with the Cocoa text system, all placeholders are automatically enclosed by tabs
 */
- (NSString *)RTFFormatStringOfLevel:(NSUInteger)levelIndex withPlaceholderPositions:(NSArray **)placeholderPositions;

/*!
 @abstract Returns the RTF format string of a level as required by the \levelmarker tag of the RTF extension of Cocoa.
 @discussion If no format code exists in the level an empty string is returned
 */
- (NSString *)cocoaRTFFormatStringOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the concrete bullet point marker for a certain nesting of list item indices
 @discussion To ensure compatibility with the Cocoa text system, all markers are automatically enclosed by tabs
 */
- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers;

@end
