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
    NSArray     *levelFormats;
    NSArray     *startNumbers;
}

/*!
 @abstract See textListWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats;

@end

@implementation RKListStyle

NSRegularExpression *preprendPlaceholderRegexp;
NSRegularExpression *enumerationPlaceholderRegexp;

+ (void)load
{
    enumerationPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%[drRaA]" options:0 error:nil];
    preprendPlaceholderRegexp = [NSRegularExpression regularExpressionWithPattern:@"(?<!%)%\\*" options:0 error:nil];
}

+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)initialLevelFormats;
{
    return [[RKListStyle alloc] initWithLevelFormats: initialLevelFormats];
}

+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)initialLevelFormats startNumbers:(NSArray *)startNumbers
{
    return [[RKListStyle alloc] initWithLevelFormats:initialLevelFormats startNumbers:startNumbers];
}

- (id)initWithLevelFormats:(NSArray *)initialLevelFormats
{
    self = [self init];
    
    if (self) {
        if (levelFormats.count > 9) {
            [NSException raise:NSRangeException format:@"Level nesting is limited to 9."];
        }    

        levelFormats = initialLevelFormats;
    }
    
    return self;
}

- (id)initWithLevelFormats:(NSArray *)initialLevelFormats startNumbers:(NSArray *)initialStartNumbers
{
    self = [self initWithLevelFormats:initialLevelFormats];
    
    if (self) {
        startNumbers = initialStartNumbers;
    }
    
    return self;
}

- (NSString *)formatOfLevel:(NSUInteger)levelIndex
{
    if (levelIndex >= levelFormats.count)
        return @"";
    
    return [levelFormats objectAtIndex: levelIndex];
}

-(NSUInteger)startItemNumberOfLevel:(NSUInteger)levelIndex
{
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    NSNumber *startItemNumber = [startNumbers objectAtIndex: levelIndex];
    
    if (startItemNumber == nil)
        return 1;
    
    return [startItemNumber unsignedIntegerValue];
}

- (NSUInteger)countOfListLevels
{
    return levelFormats.count;
}

@end
