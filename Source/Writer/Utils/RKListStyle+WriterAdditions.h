//
//  RKListStyleWriterAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+ConversionAdditions.h"

@interface RKListStyle (WriterAdditions)

/*!
 @abstract Returns the RTF list level format as required by the Cocoa text system
 @discussion If no format code exists in the level an empty string is returned
 */
- (NSString *)systemFormatOfLevel:(NSUInteger)levelIndex;

/*!
 @astract Returns the RTF format code for a level
 @discussion If no format code is given at a certain level an RKTextListFormatCodeBullet is returned.
 */
- (RKListStyleFormatCode)formatCodeOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the RTF format string of a level as required by the \leveltext tag.
 @discussion To generate the \levelnumbers tag, the array "placeholderPositions" will contain 
 the positions of the format string placeholders in the output string
 To ensure compatibility with the Cocoa text system, all placeholders are automatically enclosed by tabs
 */
- (NSString *)formatStringOfLevel:(NSUInteger)levelIndex placeholderPositions:(NSArray **)placeholderPositionsOut;

/*!
 @abstract Returns the concrete bullet point marker for a certain nesting of list item indices
 @discussion To ensure compatibility with the Cocoa text system, the string should be postprocessed with "systemCompatibleMarker"
 */
- (NSString *)markerForItemNumbers:(NSArray *)itemNumbers;

/*!
 @abstract The text system requires every marker to be enclosed by tabs
 @discussion These tabs must not be escabed to a \tab tag afterwards since this breaks compatibility
 */
+ (NSString *)systemCompatibleMarker:(NSString *)marker;

@end
