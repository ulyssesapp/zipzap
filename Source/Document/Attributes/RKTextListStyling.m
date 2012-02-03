//
//  RKTextListStyling.m
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextListStyling.h"
#import "RKConversion.h"

@interface RKTextListStyling () {
    NSString *generalLevelFormat;
    NSArray *definedLevelFormats;
}

/*!
 @abstract See textListWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats;

@end

@implementation RKTextListStyling

+ (RKTextListStyling *)textListWithGeneralLevelFormat:(NSString *)levelFormat;
{
    return [self textListWithLevelFormats: [NSArray arrayWithObjects: levelFormat, nil]];
}

+ (RKTextListStyling *)textListWithLevelFormats:(NSArray *)levelFormats;
{
    return [[RKTextListStyling alloc] initWithLevelFormats: levelFormats];
}

- (id)initWithLevelFormats:(NSArray *)levelFormats
{
    self = [self init];
    
    if (self) {
        definedLevelFormats = levelFormats;
        generalLevelFormat = [levelFormats objectAtIndex: levelFormats.count - 1];
    }
    
    return self;
}

-(NSString *)formatOfLevel:(NSUInteger)levelIndex
{
    if (levelIndex < definedLevelFormats.count)
        return [definedLevelFormats objectAtIndex: levelIndex];
    else
        return generalLevelFormat;
}

@end
