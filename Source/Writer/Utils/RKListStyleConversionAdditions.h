//
//  RKListStyleConversionAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
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
typedef enum : NSUInteger {
    RKListFormatCodeDecimal             = 0,
    RKListFormatCodeUpperCaseRoman      = 1,
    RKListFormatCodeLowerCaseRoman      = 2,
    RKListFormatCodeUpperCaseLetter     = 3,
    RKListFormatCodeLowerCaseLetter     = 4,
    RKListFormatCodeBullet              = 23
} RKListStyleFormatCode;

@interface RKListStyle (RKListStyleConversionAdditions)

/*!
 @abstract Returns the format code that belongs to a placeholder as an object containing an RKListStyleFormatCode constant
 */
+ (NSNumber *)formatCodeFromEnumerationPlaceholder:(NSString *)placeholder;

/*!
 @abstract Returns the placeholder name required by the text system
 */
+ (NSString *)systemFormatCodeFromEnumerationPlaceholder:(NSString *)placeholder;

@end
