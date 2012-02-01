//
//  RKResourcePool.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePool.h"
#import "RKSection.h"

@class RKDocument, RKSection;

@interface RKResourcePool()
{
    NSMutableArray *fonts;
    NSMutableArray *colors;
    NSMutableArray *fileWrappers;

    NSMutableArray *listTable;
}

@end

@implementation RKResourcePool

- (id)init
{
    self = [super init];
    
    if (self) {
        fonts = [NSMutableArray new];
        colors = [NSMutableArray new];
        fileWrappers = [NSMutableArray new];
        listTable = [NSMutableArray new];
        
        // Adding the two default colors (black is required; white is useful for \cb1
        [self indexOfColor: [NSColor colorWithSRGBRed:0 green:0.0 blue:0.0 alpha:1.0]];
        [self indexOfColor: [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    }
        
    return self;
}

- (NSUInteger)indexOfFont:(NSFont *)font
{
    NSAssert(font, @"No font given");
    
    NSString *familyName = [[[NSFontManager sharedFontManager] convertFont:font toNotHaveTrait:NSBoldFontMask|NSItalicFontMask] fontName];
    NSUInteger index = [fonts indexOfObject: familyName];
    
    if (index == NSNotFound) {
        [fonts addObject: familyName];
        index = [fonts count] - 1;
    }
    
    return index;
}

- (NSUInteger)indexOfColor:(NSColor *)color
{
    NSAssert(color, @"No color given");
    
    // Ensure that no alpha is used and that the color is converted to the RGB color space
    NSColor *opaqueColor = [[color colorUsingColorSpace: [NSColorSpace sRGBColorSpace]] colorWithAlphaComponent: 1.0];
    NSUInteger index = [colors indexOfObject: opaqueColor];
    
    if (index == NSNotFound) {
        [colors addObject: opaqueColor];
        index = [colors count] - 1;
    }
    
    return index;
}

- (NSString *)registerFileWrapper:(NSFileWrapper *)fileWrapper
{
    NSAssert(fileWrapper, @"No file given");
    
    NSFileWrapper *referencedFile = [[NSFileWrapper alloc] initRegularFileWithContents:[fileWrapper regularFileContents]];
    [referencedFile setFilename:[NSString stringWithFormat:@"%u.%@", fileWrappers.count, [[fileWrapper filename] pathExtension]]];
    
    [fileWrappers addObject:referencedFile];
    
    return referencedFile.filename;
}

- (NSArray *)fontFamilyNames
{
    return fonts;
}

- (NSArray *)colors
{
    return colors;
}

- (NSArray *)fileWrappers
{
    return fileWrappers;
}

- (NSUInteger)indexOfList:(NSTextList *)listHead
{
    NSAssert(listHead, @"No list head given");
    NSUInteger __block listIndex = NSNotFound;
    
    [listTable enumerateObjectsUsingBlock:^(NSArray *listLevels, NSUInteger currentIndex, BOOL *stop) {
        NSTextList *currentHead = [listLevels objectAtIndex:0];
        
        if (currentHead == listHead) {
            listIndex = currentIndex;
            *stop = true;
        }
    }];
    
    if (listIndex == NSNotFound) {     
        [listTable addObject: [NSMutableArray arrayWithObject:listHead]];
        listIndex = listTable.count - 1;
    }

    return listIndex;
}

- (void)registerLevelSettings:(NSArray *)listNestings forListIndex:(NSUInteger)listIndex
{
    NSAssert(listTable.count > listIndex, @"Invalid list index given");
    
    NSMutableArray *knownListLevels = [listTable objectAtIndex:listIndex];
    
    // Never overwrite the head element of a list
    NSAssert([knownListLevels objectAtIndex:0] == [listNestings objectAtIndex:0], @"Head element was overwritten");
            
    [knownListLevels replaceObjectsInRange:NSMakeRange(0, listNestings.count - 1) withObjectsFromArray:listNestings];
}

- (NSArray *)levelDescriptionsOfList:(NSUInteger)listIndex
{
    return [listTable objectAtIndex:listIndex];
}

@end
