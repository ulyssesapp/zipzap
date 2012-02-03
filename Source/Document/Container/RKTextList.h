//
//  RKTextList.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Representation of a list styling
 @description A text list consists of the styling description for each nesting level of the list
 */
@interface RKTextList : NSObject

/*!
 @abstract Creates a text list with a format for all levels (at most 9)
 @discussion An array of NSString with format strings must be given. 
             The format strings consists of an arbitrary text and at most one placeholder
              The available placeholders are:
                %dN     Decimal numbers
                %rN     Lower roman numbers
                %RN     Upper roman numbers
                %aN     Lower alphabetic enumeration
                %AN     Upper alphabetic enumeration
    
              Additionally the following placeholders may be used
                %%      %-Charracter
 */
+ (RKTextList *)textListWithLevelFormats:(NSArray *)levelFormats;

/*!
 @abstract Creates a text list that overrides the start positions of selected levels
 */
+ (RKTextList *)textListWithLevelFormats:(NSArray *)levelFormats withOveridingStartItemNumbers:(NSDictionary *)overridingItemNumbers;

/*!
 @abstract Returns the format definition for a certain level
 */
- (NSString *)formatOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the starting item number of alever
 */
- (NSUInteger)startItemNumberOfLevel:(NSUInteger)levelIndex;

/*!
 @abstract Returns the count of list levels
 */
- (NSUInteger)countOfListLevels;

@end
