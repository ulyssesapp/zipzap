//
//  RKListStyle.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Representation of a list styling
 @discussion Each distinct text list requires a distinct list style. A text list consists of the styling description for each nesting level of the list.
 */
@interface RKListStyle : NSObject

/*!
 @abstract Creates a text list with a format for all levels
 @discussion An array of NSString with format strings per level must be given. The format strings consists of an arbitrary text and at most one placeholder
 
              The available placeholders are:
                %d     Decimal numbers
                %r     Lower roman numbers
                %R     Upper roman numbers
                %a     Lower alphabetic enumeration
                %A     Upper alphabetic enumeration
    
              Additionally the following placeholders may be used
                %%      %-Charracter
                %*      Insert level string of a higher level here
 
 Additionally an array of marker styles may be passed. See -levelStyles for further details.
 
 @note This is in contrast to NSTextList where prepending is done using a prepend flag. Since Word does not provide a prepend flag and some locales require to sort enumerations in another direction, we have to encode the placeholder ordering manually.
 */
+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)levelFormats styles:(NSArray *)levelStyles;

/*!
 @abstract Creates a text list that overrides the start positions of selected levels. Additionally an array of marker styles may be passed. See -levelStyles for further details.
 */
+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)levelFormats styles:(NSArray *)levelStyles startNumbers:(NSArray *)startNumbers;

/*!
 @abstract Initializes a text list that overrides the start positions of selected levels. Additionally an array of marker styles may be passed. See -levelStyles for further details.
 @discussion See listStyleWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats styles:(NSArray *)levelStyles startNumbers:(NSArray *)startNumbers;

/*!
 @abstract Returns the format definition for a certain level
 */
- (NSString *)formatForLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the marker style for a certain level
 */
- (NSDictionary *)markerStyleForLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the starting item number of alever
 */
- (NSUInteger)startNumberForLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the count of list levels
 */
- (NSUInteger)numberOfLevels;

/*!
 @abstract Accessor for the level formats
 @discussion Array of NSString
 */
@property (strong, readonly) NSArray *levelFormats;

/*!
 @abstract Accesor for the marker styles for each level
 @discussion Array of NSDictionary containing string attributes. Additionally the keys RKListStyleMarkerLocationKey and RKListStyleMarkerWidthKey are interpreted.
 */
@property (strong, readonly) NSArray *levelStyles;

/*!
 @abstract Accessor for the level starting numbers
 @discussion Array of NSNumber
 */
@property (strong, readonly) NSArray *startNumbers;

@end

/*!
 @abstract Key used inside the style of a list level to determine the location of a list marker relative to the leading page margin in points.
 @discussion Maps to NSNumber. See -levelStyles of RKListStyle.
 */
extern NSString *RKListStyleMarkerLocationKey;

/*!
 @abstract Key used inside the style of a list level to specify the width of a list marker in points.
 @discussion Maps to NSNumber. See -levelStyles of RKListStyle.
 */
extern NSString *RKListStyleMarkerWidthKey;

