//
//  RKTaggedString.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKConversion.h"

@interface RKTaggedString ()
{
    NSMutableDictionary *tagPositions;
    NSMutableIndexSet *removedRanges;
    NSString *originalString;
}

/*!
 @abstract Returns the tag array for a certain position
 @discussion Throws an exception if an invalid position is used
 */
- (NSMutableArray *)arrayForPosition:(NSUInteger)position;

/*!
 @abstract Appends an excerpt of the original string to a string
 @discussion All characters are escaped for RTF output. Characters inside ranges that have been removed are also not copied.
 */
- (void)appendOriginalStringRange:(NSRange)range toString:(NSMutableString *)flattenedString;

@end

@implementation RKTaggedString

+ (RKTaggedString *)taggedStringWithString:(NSString *)string
{
    return [[RKTaggedString alloc] initTaggedStringWithString: string];
}

- (id)init
{
    self = [super init];

    if (self) {
        tagPositions = [NSMutableDictionary new];
        removedRanges = [NSMutableIndexSet new];
    }
    
    return self;
}

- (id)initTaggedStringWithString:(NSString *)string
{
    self = [self init];
    
    if (self) {
        originalString = string;
    }
    
    return self;
}

- (NSString *)untaggedString
{
    return originalString;
}

- (NSMutableArray *)arrayForPosition:(NSUInteger)position
{
    if (position > [originalString length]) {
        [NSException raise:NSRangeException format:@"Position %u beyond string bounded by %u.", position, [originalString length]];
    }
    
    NSNumber *mapIndex = [NSNumber numberWithUnsignedInteger:position];
    NSMutableArray *tags = [tagPositions objectForKey:mapIndex];
    
    if (!tags) {
        tags = [NSMutableArray new];
        [tagPositions setObject:tags forKey:mapIndex];
    }
    
    return tags;
}

- (void)registerTag:(NSString *)tag forPosition:(NSUInteger)position
{
    NSMutableArray *tags = [self arrayForPosition:position];
    
    [tags addObject: tag];
}

- (void)registerClosingTag:(NSString *)tag forPosition:(NSUInteger)position
{
    NSMutableArray *tags = [self arrayForPosition:position];
    
    [tags insertObject:tag atIndex:0];
}

- (void)appendOriginalStringRange:(NSRange)range toString:(NSMutableString *)flattenedString
{
    for (NSUInteger position = range.location; position < (NSMaxRange(range)); position ++) {
        if (![removedRanges containsIndex:position]) {
            [flattenedString appendString: [[originalString substringWithRange:NSMakeRange(position, 1)] RTFEscapedString]];
        }
    }
}

- (void)removeRange:(NSRange)range
{
    [removedRanges addIndexesInRange:range];
}

- (NSString *)flattenedRTFString
{
    __block NSMutableString *flattened = [NSMutableString new];
    __block NSUInteger lastSourceOffset = 0;
    
    // Iterate over all tag positions
    for (NSNumber *mapIndex in [[tagPositions allKeys] sortedArrayUsingSelector: @selector(compare:)]) {
        
        NSUInteger currentSourceOffset = [mapIndex unsignedIntegerValue];

        // Copy all untagged chars
        [self appendOriginalStringRange:NSMakeRange(lastSourceOffset, currentSourceOffset - lastSourceOffset) toString:flattened];
     
        lastSourceOffset = currentSourceOffset;
        
        // Insert tags
        NSArray *tags = [tagPositions objectForKey: mapIndex];
        
        for (NSString *tag in tags) {
            [flattened appendString: tag];
        };
    }

    // Append remaining string
    if (lastSourceOffset < [originalString length]) {
        [self appendOriginalStringRange:NSMakeRange(lastSourceOffset, originalString.length - lastSourceOffset) toString:flattened];
    }
        
    return flattened;
}

@end
