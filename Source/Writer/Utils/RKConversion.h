//
//  RKConversion.h
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSString (RKConversion)

/*!
 @abstract Escapes a string for usages within an RTF file
 @discussion Replaces \ { } and all characters outside the ANSI CP1252
 */
- (NSString *)RTFEscapedString;

/*!
 @abstract Sanitizes a filename for usage within an RTFD file
 @discussion Replaces all diacritic characters by their base characters and removes all non-iso characters
 */
- (NSString *)sanitizedFilenameForRTFD;

@end

@interface NSDate (RKConversion)

/*!
 @abstract Converts a date to the date string representation used by RTF
 */
- (NSString *)RTFDate;

@end

@interface NSData (RKConversion)

/*!
 @abstract Converts an NData object to a RTF hex encoding like it is required for embedded file encoding
 @description Every line contains at most 128 characters
 */
- (NSString *)stringWithRTFHexEncoding;

@end

#if !TARGET_OS_IPHONE

@interface NSColor (RKConversion)

/*!
 @abstract Converts a color to the generic RGB color space and creates a CGColor from it
 */
- (CGColorRef)CGColorWithGenericRGBColorSpace;

/*!
 @abstract Generates a color object that must not be converted to be valid for RTF
 */
+ (NSColor *)rtfColorFromColor:(NSColor *)color;

/*!
 @abstract Generates a color object that must not be converted to be valid for RTF
 */
+ (NSColor *)rtfColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end

#endif
