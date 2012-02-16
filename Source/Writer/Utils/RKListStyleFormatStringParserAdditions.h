//
//  RKListStyleFormatStringParserAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyleConversionAdditions.h"

@interface RKListStyle (RKListStyleFormatStringParserAdditions)

/*!
 @abstract Executes the given block for each token of a full format string
 @discussion A full format string contains all format strings of all levels that have been append by %*
 A token is either:
 NSString        Ordinary string
 NSNumber        A RKListStyleFormatCode representing the format code
 Besides the token, the block receives also the level index of the format string to which the token belongs
 */
- (void)scanFullFormatStringFromLevel:(NSUInteger)levelIndex usingBlock:(void (^)(NSString *token, NSUInteger tokenLevel))block;

/*!
 @abstract Returns the range of the first enumeration placeholder inside a format string
 */
+ (NSRange)rangeOfEnumerationPlaceholder:(NSString *)formatString;

/*!
 @abstract Returns the range of the first level link placeholder inside a format string
 */
+ (NSRange)rangeOfLinkedLevelPlaceholder:(NSString *)formatString;

@end
