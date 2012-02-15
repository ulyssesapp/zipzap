//
//  RKTextList.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#define RKListMaxiumLevelCount             9

/*!
 @abstract Representation of a list styling
 @description A text list consists of the styling description for each nesting level of the list
 */
@interface RKListStyle : NSObject

/*!
 @abstract Creates a text list with a format for all levels (at most RKListMaxiumLevelCount)
 @discussion An array of NSString with format strings per level must be given. 
             The format strings consists of an arbitrary text and at most one placeholder
              The available placeholders are:
                %d     Decimal numbers
                %r     Lower roman numbers
                %R     Upper roman numbers
                %a     Lower alphabetic enumeration
                %A     Upper alphabetic enumeration
    
              Additionally the following placeholders may be used
                %%      %-Charracter
                %*      Insert level string of a higher level here
 */
+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)levelFormats;

/*!
 @abstract Creates a text list that overrides the start positions of selected levels
 */
+ (RKListStyle *)listStyleWithLevelFormats:(NSArray *)levelFormats startNumbers:(NSArray *)startNumbers;

/*!
 @abstract Initializes a text list that overrides the start positions of selected levels
 @discussion See listStyleWithLevelFormats
 */
- (id)initWithLevelFormats:(NSArray *)levelFormats startNumbers:(NSArray *)startNumbers;

/*!
 @abstract Returns the format definition for a certain level
 */
- (NSString *)formatForLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the starting item number of alever
 */
- (NSUInteger)startNumberForLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the count of list levels
 */
- (NSUInteger)numberOfLevels;

@end
