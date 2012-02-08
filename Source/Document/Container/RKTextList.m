//
//  RKTextList.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextList.h"
#import "RKConversion.h"

@interface RKTextList () {
    NSArray *definedLevelFormats;
    NSDictionary *startItemNumbers;
}

/*!
 @abstract See textListWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats;

/*!
 @abstract See textListWithLevelFormats:withOverdingStartIndices:
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSDictionary *)overridingItemNumbers;

@end

@implementation RKTextList

NSRegularExpression *preprendPlaceholderRegexp;
NSRegularExpression *enumerationPlaceholderRegexp;

+ (void)load
{
    enumerationPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%[drRaA]" options:0 error:nil];
    preprendPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%\\*" options:0 error:nil];
}

+ (RKTextList *)textListWithLevelFormats:(NSArray *)levelFormats;
{
    return [[RKTextList alloc] initWithLevelFormats: levelFormats];
}

+ (RKTextList *)textListWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSDictionary *)overridingItemNumbers
{
    return [[RKTextList alloc] initWithLevelFormats:levelFormats withOveridingStartItemNumbers:overridingItemNumbers];
}

- (id)initWithLevelFormats:(NSArray *)levelFormats
{
    self = [self init];
    
    if (self) {
        if (levelFormats.count > 9) {
            [NSException raise:NSRangeException format:@"Level nesting is limited to 9."];
        }    

        definedLevelFormats = levelFormats;
    }
    
    return self;
}

- (id)initWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSDictionary *)overridingItemNumbers
{
    self = [self initWithLevelFormats:levelFormats];
    
    if (self) {
        startItemNumbers = overridingItemNumbers;
    }
    
    return self;
}

- (NSString *)formatOfLevel:(NSUInteger)levelIndex
{
    if (levelIndex >= definedLevelFormats.count)
        return @"";
    
    return [definedLevelFormats objectAtIndex: levelIndex];
}

-(NSUInteger)startItemNumberOfLevel:(NSUInteger)levelIndex
{
    NSNumber *startItemNumber = [startItemNumbers objectForKey:[NSNumber numberWithUnsignedInteger: levelIndex]];
    
    if (startItemNumber == nil)
        return 1;
    
    return [startItemNumber unsignedIntegerValue];
}

- (NSUInteger)countOfListLevels
{
    return definedLevelFormats.count;
}

@end
