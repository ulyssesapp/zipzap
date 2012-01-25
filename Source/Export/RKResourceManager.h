//
//  RKResourceManager.h
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
@interface RKResourceManager : NSObject

- (RKResourceManager *)init;

/*!
 @abstract Returns the index of a font
 */
- (NSUInteger)indexOfFont:(NSFont *)font;

/*!
 @abstract Returns the index of a color
 */
- (NSUInteger)indexOfColor:(NSColor *)color;

/*!
 @abstract Returns the collected font families sorted by their indices
 */
- (NSArray *)collectedFonts;

/*!
 @abstract Returns the collected colors sorted by their indices
 */
- (NSArray *)collectedColors;

@end
