//
//  NSString+RKConvenienceAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 15.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSString (RKConvenienceAdditions)

/*!
 @abstract Creates an RTF group tag 
 @discussion Syntax {\TAG BODY}
 */
+ (NSString *)stringWithRTFGroupTag:(NSString *)tag body:(NSString *)body;

/*!
 @abstract Splits the string by matches and non-matches of a regular expression.
 @discussion This is in contrast to componentsSeparatedByString of AppKit which removes the separator.
 */
- (NSArray *)componentsSeparatedByRegularExpression:(NSRegularExpression *)regularExpression;

@end