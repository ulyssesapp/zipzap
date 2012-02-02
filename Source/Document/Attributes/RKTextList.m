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
    NSString *generalLevelFormat;
    NSArray *definedLevelFormats;
}

/*!
 @abstract See textListWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats;

@end

@implementation RKTextList

+ (RKTextList *)textListWithGeneralLevelFormat:(NSString *)levelFormat;
{
    return [self textListWithLevelFormats: [NSArray arrayWithObjects: levelFormat, nil]];
}

+ (RKTextList *)textListWithLevelFormats:(NSArray *)levelFormats;
{
    return [[RKTextList alloc] initWithLevelFormats: levelFormats];
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
