//
//  RKTaggedString.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract A string that allows the placement of tags
 */
@interface RKTaggedString : NSObject

/*!
 @abstract Creates the tagged string using another string
 */
+ (RKTaggedString *)taggedStringWithString:(NSString *)string;

/*!
 @abstract Initializes the tagged string using another string
 */
- (RKTaggedString *)initTaggedStringWithString:(NSString *)string;

/*!
 @abstract Associates a tag with a certain string position
 @discussion When flattening the string, the order of adding tags to the tagged string is kept
             Throws an exception if the position is beyond the string boundaries
 */
- (void)registerTag:(NSString *)tag forPosition:(NSUInteger)position;

/*!
 @abstract Associates a closing tag with a certain string position
 @discussion In contrast to 'registerTag' the tag will be placed before all other tags at this position
 */
- (void)registerClosingTag:(NSString *)tag forPosition:(NSUInteger)position;

/*!
 @abstract Specifies a string range as to be removed in the flattened variant of the string
 */
- (void)removeRange:(NSRange)range;

/*!
 @abstract Creates a flat variant of the string. 
 @discussion All tags are integrated into the string. All non-tag charracters are converted to an 
            escaped RTF string. Substrings that have been marked for removal are removed.
 */
- (NSString *)flattenedRTFString;

/*!
 @abstract Returns the original string
 */
- (NSString *)untaggedString;

@end