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
    NSMutableIndexSet *acceptedRanges;
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
    }
    
    return self;
}

- (id)initTaggedStringWithString:(NSString *)string
{
    self = [self init];
    
    if (self) {
        originalString = string;
        acceptedRanges = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, string.length)];
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
        [NSException raise:NSRangeException format:@"Position %lu beyond string bounded by %lu.", position, [originalString length]];
    }
    
    NSNumber *mapIndex = @(position);
    NSMutableArray *tags = tagPositions[mapIndex];
    
    if (!tags) {
        tags = [NSMutableArray new];
        tagPositions[mapIndex] = tags;
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
    [acceptedRanges enumerateRangesInRange:range options:0 usingBlock:^(NSRange acceptedRange, BOOL *stop) {
        [flattenedString appendString: [[originalString substringWithRange:acceptedRange] RTFEscapedString]];
    }];
}

- (void)removeRange:(NSRange)range
{
    [acceptedRanges removeIndexesInRange:range];
}

- (NSString *)flattenedRTFString
{
    NSMutableString *flattened = [NSMutableString new];
    NSUInteger lastSourceOffset = 0;
    
    // Iterate over all tag positions
    for (NSNumber *mapIndex in [[tagPositions allKeys] sortedArrayUsingSelector: @selector(compare:)]) {
        NSUInteger currentSourceOffset = [mapIndex unsignedIntegerValue];

        // Copy all untagged chars
        [self appendOriginalStringRange:NSMakeRange(lastSourceOffset, currentSourceOffset - lastSourceOffset) toString:flattened];
        lastSourceOffset = currentSourceOffset;
        
        // Insert tags
        for (NSString *tag in tagPositions[mapIndex]) {
            [flattened appendString: tag];
        }
    }

    // Append remaining string
    if (lastSourceOffset < [originalString length]) {
        [self appendOriginalStringRange:NSMakeRange(lastSourceOffset, originalString.length - lastSourceOffset) toString:flattened];
    }
        
    return flattened;
}

@end
