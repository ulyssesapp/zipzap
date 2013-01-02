//
//  NSDictionary+FlagSerialization.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Methods used to serialize flags and enums to arrays or strings
 @discussion The dictionary must contain a mapping from NSString to NSNumber, mapping from flag names to flag values
 */
@interface NSDictionary (FlagSerialization)

/*!
 @abstract Uses the flag definitions inside this dictionary to create an array of strings
 @discussion Throws an assertion, if not all flags were serialized. If a flag with value 0 is enlisted in the dictionary, this flag will be only given, if no other flag is set.
 */
- (NSArray *)arrayFromFlags:(NSUInteger)flags;

/*!
 @abstract Uses the flag definitions inside this dictionary to setup flags from an array of flag identifiers (NSString)
 @discussion Passes an error, if some flags are unknown
 */
- (NSUInteger)flagsFromArray:(NSArray *)serializedFlags error:(NSError **)error;

/*!
 @abstract Uses the flag definition inside this dictionary to create a string from an enum value
 @discussion Throws an assertion, if the enum value is unknown.
 */
- (NSString *)stringFromUnsignedEnumValue:(NSUInteger)enumValue;

/*!
 @abstract Uses the flag definition inside this dictionary to create a string from an enum value
 @discussion Passes an error, if some flags are unknown
 */
- (NSUInteger)unsignedEnumValueFromString:(NSString *)serializedEnumValue error:(NSError **)error;

/*!
 @abstract Uses the flag definition inside this dictionary to create a string from an enum value
 @discussion Throws an assertion, if the enum value is unknown.
 */
- (NSString *)stringFromSignedEnumValue:(NSInteger)enumValue;

/*!
 @abstract Uses the flag definition inside this dictionary to create a string from an enum value
 @discussion Passes an error, if some flags are unknown
 */
- (NSInteger)signedEnumValueFromString:(NSString *)serializedEnumValue error:(NSError **)error;

@end
