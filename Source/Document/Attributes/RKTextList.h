//
//  RKTextList.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKTextListItemAttributeName;

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

/*!
 @abstract Representation of a bullet point list / enumeration
 @description A text list consists of the styling description for each nesting level of the list
 */
@interface RKTextList : NSObject

/*!
 @abstract Creates a text list with a general format for all levels
 @discussion The format string consists of an arbitrary text
              The available placeholders are:
                %d      Decimal numbers
                %r      Lower roman numbers
                %R      Upper roman numbers
                %a      Lower alphabetic enumeration
                %A      Upper alphabetic enumeration
                %%      %-Charracter
 */
+ (RKTextList *) textListWithGeneralLevelFormat:(NSString *)levelFormat;

/*!
 @abstract Creates a text list with seperate format for the first given levels.
 @discussion The last level format will be used as generic format for all undefined levels
 */
+ (RKTextList *) textListWithLevelFormats:(NSArray *)levelFormats;

/*!
 @astract Returns the format definition for a certain level
 */
-(NSString *) formatOfLevel:(NSUInteger)levelIndex;

/*!
 @astract Returns the RTF format code for a level
 */
-(RKTextListFormatCode) RTFFormatCodeOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the RTF format string of a level
 */
-(NSString *) RTFFormatStringOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the concrete bullet point marker for a certain list item at a distinct level
 */
-(NSString *) markerForItemNumber:(NSUInteger)itemNumber atLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the concrete bullet point marker for a certain list item
 */
-(NSString *) markerForItemNumber:(NSUInteger)itemNumber forLevels:(NSArray *)levelIndices;

@end
