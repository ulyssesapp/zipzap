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

@end

@interface NSDate (RKConversion)

/*!
 @abstract Converts a date to the date string representation used by RTF
 */
- (NSString *)RTFDate;

@end
