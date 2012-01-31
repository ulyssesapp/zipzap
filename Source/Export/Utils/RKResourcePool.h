//
//  RKResourcePool.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"

@class RKDocument;

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
 @abstract Registers a referenced file
 */
- (void)registerFileWrapper:(NSFileWrapper *)file;

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
 @abstract Returns the collected file wrappers
 @discussion Elements are NSFileWrapper
 */
- (NSArray *)fileWrappers;

@end
