//
//  RKHeaderDefinitionsContainer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"

@class RKDocument;

/*!
 @abstract Collects font and color definitions from an RKDocument as required for the document header
 */
@interface RKHeaderDefinitionsContainer : NSObject

/*!
 @abstract Collects font and color definitions and stores them to a dictionary
 */
+ (RKHeaderDefinitionsContainer *)headerDefinitionsFromDocument:(RKDocument *)document;

/*!
 @abstract Returns the index of a font
 */
- (NSUInteger)indexOfFont:(NSFont *)font;

/*!
 @abstract Returns the index of a color
 */
- (NSUInteger)indexOfColor:(NSColor *)color;

/*!
 @abstract Returns the collected fonts
 */
- (NSArray *)collectedFonts;

/*!
 @abstract Returns the collected colors
 */
- (NSArray *)collectedColors;

@end
