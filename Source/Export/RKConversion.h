//
//  RKConversion.h
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKConversion : NSObject

/*!
 @abstract Escapes a string to be stored directly in an RTF document
 @discussion Escapes the characters \ { }
 */
+ (NSString *)safeRTFString:(NSString *)string;

/*!
 @abstract Converts a date to the string representation used inside the RTF header
 */
+ (NSString *)RTFDate:(NSDate *)date;

@end
