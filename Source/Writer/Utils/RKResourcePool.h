//
//  RKResourcePool.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Manages files, font and color definitions from an RKDocument
 */
@interface RKResourcePool : NSObject

/*!
 @abstract Returns the index of a font. 
 @discussion If the font is not indexed, it will be registered. The font name is stored with all non-standard traits (e.g. Roman, Condensed). Standard traits (Bold, Italic) are removed.
 */
- (NSUInteger)indexOfFont:(NSFont *)font;

/*!
 @abstract Returns the index of a color. 
 @discussion If the color is not indexed, it will be registered. Colors will be registered without the alpha channel.
 */
- (NSUInteger)indexOfColor:(NSColor *)color;

/*!
 @abstract Registers a referenced file and returns a referencable filename
 */
- (NSString *)registerFileWrapper:(NSFileWrapper *)file;

/*!
 @abstract Returns the index of a list
 */
- (NSUInteger)indexOfList:(RKListStyle *)textList;

/*!
 @abstract Returns a new item number of a list level
 @discussion All item numbers for more nested list levels will be reset to the starting number of the level
 */
- (NSArray *)incrementItemNumbersForListLevel:(NSUInteger)level ofList:(RKListStyle *)textList;

/*!
 @abstract Returns the collected font families sorted by their indices
 @discussion Elements are NSString
 */
- (NSArray *)fontFamilyNames;

/*!
 @abstract Returns the collected colors sorted by their indices
 @discussion Elements are NSColor
 */
- (NSArray *)colors;

/*!
 @abstract A dictionary mapping from filenames to the file wrappers of all attached files
 */
@property (nonatomic,strong,readonly) NSDictionary* attachmentFileWrappers;

/*!
 @abstract Returns the available lists
 */
- (NSArray *)textLists;

@end
