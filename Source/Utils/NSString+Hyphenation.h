//
//  NSString+Hyphenation.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSMutableString (Hyphenation)

/*!
 @abstract Inserts the given hyphenation character according to the hyphenation rules of the given locale.
 @discussion Returns NO, if the locale does not support hyphenation.
 */
- (BOOL)insertHyphenationCharacter:(NSString *)hyphenationCharacter forLocale:(NSLocale *)locale inRange:(NSRange)range;

@end

@interface NSString (Hyphenation)

/*!
 @abstract Creates a new string that is hyphenated for the given locale using the given character
 @discussion Applies no hyphenation if the given locale does not support it.
 */
- (NSString *)stringByHyphenatingWithCharacter:(NSString *)hyphenationCharacter locale:(NSLocale *)locale inRange:(NSRange)range;

@end

@interface NSLocale (Hyphenation)

/*!
 @abstract Verifies, whether the given locale support hyphenation
 */
- (BOOL)supportsHyphenation;

@end
