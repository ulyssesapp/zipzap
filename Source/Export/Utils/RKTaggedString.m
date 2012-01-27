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
    NSMutableDictionary *tagPlacement;
    NSString *originalString;
}

/*!
 @abstract Appends an excerp of the original string to another string while converting it to the escaped RTF variant
 */
- (void)appendSourceStringToString:(NSMutableString *)flattenedString inRange:(NSRange)range;

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
        tagPlacement = [NSMutableDictionary new];
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

- (void)associateTag:(NSString *)tag atPosition:(NSUInteger)position
{
    if (position > [originalString length]) {
        [NSException raise:NSRangeException format:@"Position %u beyond string bounds of %u.", position, [originalString length]];
    }
    
    NSNumber *mapIndex = [NSNumber numberWithUnsignedInteger:position];
    NSMutableArray *tags = [tagPlacement objectForKey:mapIndex];
    
    if (!tags) {
        tags = [NSMutableArray new];
        [tagPlacement setObject:tags forKey:mapIndex];
    }
    
    [tags addObject: tag];
}

- (void)appendSourceStringToString:(NSMutableString *)flattenedString inRange:(NSRange)range
{
    NSString *safeOriginalString = [[originalString substringWithRange:range] RTFEscapedString];
    
    [flattenedString appendString:safeOriginalString];
}

- (NSString *)flattenedRTFString
{
    __block NSMutableString *flattened = [NSMutableString new];
    __block NSUInteger lastSourceOffset = 0;
    
    // Iterate over all tag positions
    [[[tagPlacement allKeys] sortedArrayUsingSelector:@selector(compare:)] enumerateObjectsUsingBlock:^(NSNumber *mapIndex, NSUInteger idx, BOOL *stop) {
        NSUInteger currentSourceOffset = [mapIndex unsignedIntegerValue];

        // Copy all untagged chars
        [self appendSourceStringToString:flattened inRange:NSMakeRange(lastSourceOffset, currentSourceOffset - lastSourceOffset)];
     
        lastSourceOffset = currentSourceOffset;
        
        // Insert tags
        NSArray *tags = [tagPlacement objectForKey:mapIndex];
        
        [tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger tagIndex, BOOL *stop) {
            [flattened appendString: tag];
        }];
    }];
    
    // Append remaining string
    if (lastSourceOffset < [originalString length]) {
        [self appendSourceStringToString:flattened inRange:NSMakeRange(lastSourceOffset, [originalString length] - lastSourceOffset)];
    }
        
    return flattened;
}

@end
