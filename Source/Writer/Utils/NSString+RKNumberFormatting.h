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
+ (NSString *)lowerCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to upper case roman numerals
 */
+ (NSString *)upperCaseRomanNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to lower case alphabetic numerals
 */
+ (NSString *)lowerCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to upper case alphabetic numerals
 */
+ (NSString *)upperCaseAlphabeticNumeralsFromUnsignedInteger:(NSUInteger)number;

/*!
 @abstract Converts an integer number to chicago manual style numerals
 */
+ (NSString *)chicagoManualOfStyleNumeralsFromUnsignedInteger:(NSUInteger)number;

@end
