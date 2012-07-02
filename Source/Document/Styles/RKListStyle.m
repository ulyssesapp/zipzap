//
//  RKListStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle.h"
#import "RKConversion.h"

@interface RKListStyle () {
    NSArray     *_levelFormats;
    NSArray     *_startNumbers;
}

@end

@implementation RKListStyle

@synthesize levelFormats=_levelFormats, startNumbers=_startNumbers, firstLineHeadIndentOffsets, headIndentOffsets, tabStopLocations, tabStopAlignments;

+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)initialLevelFormats;
{
    return [[RKListStyle alloc] initWithLevelFormats: initialLevelFormats startNumbers:nil];
}

+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)initialLevelFormats startNumbers:(NSArray *)startNumbers
{
    return [[RKListStyle alloc] initWithLevelFormats:initialLevelFormats startNumbers:startNumbers];
}

- (id)initWithLevelFormats:(NSArray *)initialLevelFormats startNumbers:(NSArray *)initialStartNumbers
{
    self = [self init];
    
    if (self) {
        if (_levelFormats.count >= RKListMaxiumLevelCount) {
            [NSException raise:NSRangeException format:@"Level nesting is limited to %u.", RKListMaxiumLevelCount];
        }    

        _levelFormats = initialLevelFormats;
        _startNumbers = initialStartNumbers;
    }
    
    return self;
}

- (NSString *)formatForLevel:(NSUInteger)levelIndex
{
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    if (levelIndex >= self.levelFormats.count)
        return @"";
    
    return self.levelFormats[levelIndex];
}

-(NSUInteger)startNumberForLevel:(NSUInteger)levelIndex
{
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    NSNumber *startItemNumber = self.startNumbers[levelIndex];
    
    if (startItemNumber == nil)
        return 1;
    
    return [startItemNumber unsignedIntegerValue];
}

- (NSUInteger)numberOfLevels
{
    return self.levelFormats.count;
}

- (BOOL)isEqual:(RKListStyle *)other
{
    if (![other isKindOfClass: RKListStyle.class])
        return NO;
    
    return [self.levelFormats isEqual: other.levelFormats] && [self.startNumbers isEqual: other.startNumbers];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"(RKListStyle levelFormats:%@ startNumbers:%@)", self.levelFormats, self.startNumbers];
}

@end
