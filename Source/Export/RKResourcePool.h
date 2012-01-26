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
 @abstract Returns the index of a font. If the font is not indexed, it will be registered.
 @discussion Only the family name of a font is registered, due to the requirements of the RTF header.
 */
- (NSUInteger)indexOfFont:(NSFont *)font;

/*!
 @abstract Returns the index of a color. If the color is not indexed, it will be registered.
 @discussion Colors will be registered without the alpha channel, due to the requirements of the RTF header.
 */
- (NSUInteger)indexOfColor:(NSColor *)color;

/*!
 @abstract Returns the collected font families sorted by their indices
 */
- (NSArray *)fontFamilyNames;

/*!
 @abstract Returns the collected colors sorted by their indices
 */
- (NSArray *)colors;

@end
