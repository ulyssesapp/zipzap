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
    NSArray     *levelFormats;
    NSArray     *startNumbers;
}

@end

@implementation RKListStyle

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
        if (levelFormats.count >= RKListMaxiumLevelCount) {
            [NSException raise:NSRangeException format:@"Level nesting is limited to %u.", RKListMaxiumLevelCount];
        }    

        levelFormats = initialLevelFormats;        
        startNumbers = initialStartNumbers;
    }
    
    return self;
}

- (NSString *)formatForLevel:(NSUInteger)levelIndex
{
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    if (levelIndex >= levelFormats.count)
        return @"";
    
    return [levelFormats objectAtIndex: levelIndex];
}

-(NSUInteger)startNumberForLevel:(NSUInteger)levelIndex
{
    NSAssert(levelIndex < RKListMaxiumLevelCount, @"Invalid level index");
    
    NSNumber *startItemNumber = [startNumbers objectAtIndex: levelIndex];
    
    if (startItemNumber == nil)
        return 1;
    
    return [startItemNumber unsignedIntegerValue];
}

- (NSUInteger)numberOfLevels
{
    return levelFormats.count;
}

@end
