//
//  NSString+Hyphenation.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSString (Hyphenation)

/*!
 @abstract Creates a new string that is hyphenated for the given locale using the given character
 @discussion Applies no hyphenation if the given locale does not support it.
 */
- (NSString *)stringByHyphenatingWithCharacter:(NSString *)hyphenationCharacter locale:(NSLocale *)locale inRange:(NSRange)range;

/*!
 @abstract Enumerates all possible hyphenation points in the given string using the given locale
 @discussion Returns NO, if hyphenation is not available for the given locale. Mutation is allowed within the given string range.
 */
- (BOOL)enumerateHyphenationsInRange:(NSRange)range usingLocale:(NSLocale *)locale block:(void(^)(NSUInteger index, NSString *suggestedSeparator))block;

@end

@interface NSLocale (Hyphenation)

/*!
 @abstract Verifies, whether the given locale support hyphenation
 */
- (BOOL)supportsHyphenation;

@end
