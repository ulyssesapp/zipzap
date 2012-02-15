//
//  RKTextList.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle.h"
#import "RKConversion.h"

@interface RKListStyle () {
    NSArray     *definedLevelFormats;
    NSArray     *startItemNumbers;
}

/*!
 @abstract See textListWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats;

/*!
 @abstract See textListWithLevelFormats:withOverdingStartIndices:
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSArray *)overridingItemNumbers;

@end

@implementation RKListStyle

NSRegularExpression *preprendPlaceholderRegexp;
NSRegularExpression *enumerationPlaceholderRegexp;

+ (void)load
{
    enumerationPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%[drRaA]" options:0 error:nil];
    preprendPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%\\*" options:0 error:nil];
}

+ (RKListStyle *)textListWithLevelFormats:(NSArray *)levelFormats;
{
    return [[RKListStyle alloc] initWithLevelFormats: levelFormats];
}

+ (RKListStyle *)textListWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSArray *)overridingItemNumbers
{
    return [[RKListStyle alloc] initWithLevelFormats:levelFormats withOveridingStartItemNumbers:overridingItemNumbers];
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

- (id)initWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSArray *)overridingItemNumbers
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
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    NSNumber *startItemNumber = [startItemNumbers objectAtIndex: levelIndex];
    
    if (startItemNumber == nil)
        return 1;
    
    return [startItemNumber unsignedIntegerValue];
}

- (NSUInteger)countOfListLevels
{
    return definedLevelFormats.count;
}

@end
