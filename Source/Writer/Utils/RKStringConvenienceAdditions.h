//
//  RKStringConvenienceAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 15.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSString (RKStringConvenienceAdditions)

/*!
 @abstract Creates an RTF group tag 
 @discussion Syntax {\TAG BODY}
 */
+ (NSString *)stringWithRTFGroupTag:(NSString *)tag body:(NSString *)body;

@end
