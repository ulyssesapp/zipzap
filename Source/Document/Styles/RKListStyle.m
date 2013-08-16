//
//  RKListStyle.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle.h"
#import "RKConversion.h"

NSString *RKListStyleMarkerLocationKey		= @"RKListStyleMarkerLocation";
NSString *RKListStyleMarkerWidthKey			= @"RKListStyleMarkerWidth";

@implementation RKListStyle

@synthesize levelFormats=_levelFormats, startNumbers=_startNumbers, levelStyles=_levelStyles;

+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)initialLevelFormats styles:(NSArray *)levelStyles;
{
    return [[RKListStyle alloc] initWithLevelFormats:initialLevelFormats styles:levelStyles startNumbers:nil];
}

+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)initialLevelFormats styles:(NSArray *)levelStyles startNumbers:(NSArray *)startNumbers
{
    return [[RKListStyle alloc] initWithLevelFormats:initialLevelFormats styles:levelStyles startNumbers:startNumbers];
}

- (id)initWithLevelFormats:(NSArray *)initialLevelFormats styles:(NSArray *)levelStyles startNumbers:(NSArray *)startNumbers
{
    self = [self init];
    
    if (self) {
        if (_levelFormats.count >= RKListMaxiumLevelCount) {
            [NSException raise:NSRangeException format:@"Level nesting is limited to %u.", RKListMaxiumLevelCount];
        }    

        _levelFormats = initialLevelFormats;
		_levelStyles = levelStyles;
        _startNumbers = startNumbers;
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

- (NSDictionary *)markerStyleForLevel:(NSUInteger)levelIndex
{
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    if (levelIndex >= self.levelStyles.count)
        return @{};
    
    return self.levelStyles[levelIndex];
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
    
    return [self.levelFormats isEqual: other.levelFormats] && [self.startNumbers isEqual: other.startNumbers] && [self.levelStyles isEqual: other.levelStyles];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"(RKListStyle levelFormats:%@ startNumbers:%@ levelStyles:%@)", self.levelFormats, self.startNumbers, self.levelStyles];
}

@end
