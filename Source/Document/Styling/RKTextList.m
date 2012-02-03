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
}

/*!
 @abstract See textListWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats;

@end

@implementation RKTextList

+ (RKTextList *)textListWithLevelFormats:(NSArray *)levelFormats;
{
    return [[RKTextList alloc] initWithLevelFormats: levelFormats];
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

-(NSString *)formatOfLevel:(NSUInteger)levelIndex
{
    if (levelIndex >= definedLevelFormats.count)
        return @"";
    
    return [definedLevelFormats objectAtIndex: levelIndex];
}

@end
