//
//  RKTaggedString.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Represents tags that should be inserted into a string by keeping the original string positions
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
 @throw Throws an exception if the position is beyond the string boundaries
 */
- (void)associateTag:(NSString *)tag atPosition:(NSUInteger)position;

/*!
 @abstract Creates a flat variant of the string that contains all tags
 */
- (NSString *)flattenedString;

@end
