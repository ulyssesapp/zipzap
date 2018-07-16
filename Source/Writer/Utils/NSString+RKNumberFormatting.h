//
//  NSString+RKNumberFormatting.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Extension of NSString that allows to format numbers as roman numbers etc.
 */
@interface NSString (RKNumberFormatting)

/*!
 @abstract Converts an integer number to lower case roman numerals
 */
+ (NSString *)rk_lowerCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to upper case roman numerals
 */
+ (NSString *)rk_upperCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to lower case alphabetic numerals
 */
+ (NSString *)rk_lowerCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to upper case alphabetic numerals
 */
+ (NSString *)rk_upperCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to chicago manual style numerals
 */
+ (NSString *)rk_chicagoManualOfStyleNumeralsFromUnsignedInteger:(NSUInteger)number;

@end
