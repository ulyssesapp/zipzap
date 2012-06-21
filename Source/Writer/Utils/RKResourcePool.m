//
//  RKResourcePool.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKResourcePool.h"
#import "RKSection.h"
#import "RKConversion.h"
#import "RKListEnumerator.h"

@class RKDocument, RKSection;

@interface RKResourcePool()
{
    NSMutableDictionary	*_attachmentFileWrappers;
    NSMutableArray		*_colors;
    NSMutableArray		*_fonts;

    NSMutableArray		*_listStyles;
    NSMutableArray		*_listItemIndices;
}

@end

@implementation RKResourcePool

- (id)init
{
    self = [super init];
    
    if (self) {
        _fonts = [NSMutableArray new];
        _colors = [NSMutableArray new];
        _attachmentFileWrappers = [NSMutableDictionary new];
        _listStyles = [NSMutableArray new];
        _listItemIndices = [NSMutableArray new];
        
        // Adding the two default colors (black is required; white is useful for \cb1
        CGColorRef blackRGB = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){0, 0, 0, 1});
        CGColorRef whiteRGB = CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){1, 1, 1, 1});

        [self indexOfColor: blackRGB];        
        [self indexOfColor: whiteRGB];
        
        CGColorRelease(blackRGB);
        CGColorRelease(whiteRGB);
    }
        
    return self;
}

- (id)initWithDocument:(RKDocument *)initialDocument
{
    self = [self init];
    
    if (self) {
        _document = initialDocument;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSString *)postscriptNameWithoutBoldAndItalicTraits:(CTFontRef)font
{
    // Generate a font name without Italic and Bold traits
    NSString *postscriptName;
    CTFontSymbolicTraits traitMask = 0;

    // Is it a font with bold traits? If yes, remove them
    if (CTFontGetSymbolicTraits(font) & kCTFontBoldTrait) {
        traitMask |= kCTFontBoldTrait;
    }

    if (CTFontGetSymbolicTraits(font) & kCTFontItalicTrait) {
        traitMask |= kCTFontItalicTrait;
    }

    if (traitMask) {
        // We have to remove traits
        CTFontRef traitlessFont = CTFontCreateCopyWithSymbolicTraits(font, 0, NULL, 0, traitMask);

        postscriptName = (__bridge NSString *)CTFontCopyPostScriptName(traitlessFont);
        CFRelease(traitlessFont);
    }
    else {
        // Not traits to remove, just use the plain postscript name
        postscriptName = (__bridge NSString *)CTFontCopyPostScriptName(font);
    }
    
    return postscriptName;
}

- (NSUInteger)indexOfFont:(CTFontRef)font
{
    NSAssert(font, @"No font given");
    NSString *postscriptName = [self postscriptNameWithoutBoldAndItalicTraits: font];
        
    // Search for an index or create a font entry
    NSUInteger index = [_fonts indexOfObject: postscriptName];
    
    if (index == NSNotFound) {
        [_fonts addObject: postscriptName];
        index = [_fonts count] - 1;
    }
    
    return index;
}

- (NSArray *)fontFamilyNames
{
    return _fonts;
}

#pragma mark - Colors

- (NSUInteger)indexOfColor:(CGColorRef)color
{
    NSAssert(color, @"No color given");
   
    NSString *colorDefinition = nil;
    
    // Translate color depending on color space
    // Currently only RGB and B/W are supported (this is no problem on MacOS, since we convert all NSColors to RGB before; on iOS, we don't expect something else than RGB to be used in practice)
    switch (CGColorSpaceGetModel(CGColorGetColorSpace(color))) {
        case kCGColorSpaceModelRGB: {
            const CGFloat *components = CGColorGetComponents(color);

            colorDefinition = [NSString stringWithFormat:@"\\red%u\\green%u\\blue%u", (unsigned)(components[0] * 255), (unsigned)(components[1] * 255), (unsigned)(components[2] * 255)];
            break;
        }
        
        case kCGColorSpaceModelMonochrome: {
            const CGFloat *components = CGColorGetComponents(color);
            
            colorDefinition = [NSString stringWithFormat:@"\\red%u\\green%u\\blue%u", (unsigned)(components[0] * 255), (unsigned)(components[0] * 255), (unsigned)(components[0] * 255)];
            break;
        }
            
        default:
            NSAssert(false, @"Invalid color space model");
    }

    // Search for an index or create a color entry
    NSUInteger index = [_colors indexOfObject: colorDefinition];
    
    if (index == NSNotFound) {
        [_colors addObject: colorDefinition];
        index = _colors.count - 1;
    }
    
    return index;
}

- (NSArray *)colors
{
    return _colors;
}

#pragma mark - Style

- (NSUInteger) indexOfParagraphStyle:(NSString *)paragraphStyleName
{
    NSAssert(paragraphStyleName, @"No style name given");
    
    // We only support style names that have been previously registered to the document
    if ((_document.paragraphStyles)[paragraphStyleName] == nil)
        return 0;
    
    return [[_document.paragraphStyles allKeys] indexOfObject: paragraphStyleName] + 1;
}

- (NSUInteger)indexOfCharacterStyle:(NSString *)characterStyleName
{
    NSAssert(characterStyleName, @"No style name given");
    
    // We only support style names that have been previously registered to the document
    if ((_document.characterStyles)[characterStyleName] == nil)
        return 0;
    
    return [[_document.characterStyles allKeys] indexOfObject: characterStyleName] + _document.paragraphStyles.count + 1;
}

#pragma mark - File Wrapper

- (NSString *)registerFileWrapper:(NSFileWrapper *)fileWrapper
{
    NSAssert(fileWrapper, @"No file given");
    
    NSString *originalFilename = (fileWrapper.preferredFilename) ?: (fileWrapper.filename) ?: @"";
    NSString *filename = [NSString stringWithFormat: @"%lu.%@", _attachmentFileWrappers.count, [originalFilename sanitizedFilenameForRTFD]];
    
    fileWrapper.preferredFilename = filename;

    [_attachmentFileWrappers setValue:fileWrapper forKey:filename];
    
    return filename;
}

#pragma mark - Text Lists

- (NSUInteger)indexOfListStyle:(RKListStyle *)listStyle
{
    NSUInteger listIndex = [_listStyles indexOfObject: listStyle];
    
    if (listIndex == NSNotFound) {
        [_listStyles addObject: listStyle];
        [_listItemIndices addObject: [NSMutableArray new]];
        return _listStyles.count - 1;
    }
    
    return listIndex;
}

- (NSArray *)listStyles
{
    return _listStyles;
}

- (void)resetCounterOfList:(RKListStyle *)listStyle
{
    NSUInteger styleIndex = [_listStyles indexOfObject: listStyle];
    
    // Style unknown
    if (styleIndex == NSNotFound)
        return;
    
    // Reset style
    _listItemIndices[styleIndex] = [NSMutableArray new];
}

- (NSArray *)incrementItemNumbersForListLevel:(NSUInteger)level ofList:(RKListStyle *)textList;
{
    NSUInteger listIndex = [self indexOfListStyle: textList];    
    NSMutableArray *itemNumbers = _listItemIndices[listIndex];
    
    // Truncate nested item numbers, if a higher item number is increased
    if (level + 1 < itemNumbers.count) {
        [itemNumbers removeObjectsInRange: NSMakeRange(level + 1, itemNumbers.count - level - 1)];
    }
    
    if (level >= itemNumbers.count) {
        // Fill with 1 if requested, nested list is deeper nested than the current list length
        for (NSUInteger position = itemNumbers.count; position < level + 1; position ++) {
            [itemNumbers addObject: @([textList startNumberForLevel: position])];
        }
    }
    else {
        // Increment requested counter
        NSUInteger currentItemNumber = [itemNumbers[level] unsignedIntegerValue] + 1;
        itemNumbers[level] = @(currentItemNumber);
    }

    return [itemNumbers copy];
}

@end
