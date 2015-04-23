//
//  NSString+ParsingConvenience.h
//  RTFKit
//
//  Created by Lucas Hauswald on 23.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@interface NSString (ParsingConvenience)

/*!
 @abstract Enumerates the string over characters of the given character set in the given range. Block must not be nil.
 @param tokenRange Range of the next substring without delimiter.
 @param delimiter Character found after the end of tokenRange. Is NULL if no delimiter was found.
 */
- (void)enumerateTokensWithDelimiters:(NSCharacterSet *)set inRange:(NSRange)range usingBlock:(void(^)(NSRange tokenRange, unichar delimiter))block;

@end
