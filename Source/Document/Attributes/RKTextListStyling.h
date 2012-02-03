//
//  RKTextListStyling.h
//  RTFKit
//
//  Created by Friedrich Gräter on 02.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

extern NSString *RKTextListItemAttributeName;

/*!
 @abstract Representation of a list styling
 @description A text list consists of the styling description for each nesting level of the list
 */
@interface RKTextListStyling : NSObject

/*!
 @abstract Creates a text list with a general format for all levels
 @discussion The format string consists of an arbitrary text and at most one placeholder
              The available placeholders are:
                %d      Decimal numbers
                %r      Lower roman numbers
                %R      Upper roman numbers
                %a      Lower alphabetic enumeration
                %A      Upper alphabetic enumeration
    
              Additionally the following placeholders may be used
                %%      %-Charracter
                %*      Insert prepending levels here
 */
+ (RKTextListStyling *)textListWithGeneralLevelFormat:(NSString *)levelFormat;

/*!
 @abstract Creates a text list with seperate format for the first given levels.
 @discussion The last level format will be used as generic format for all undefined levels
 */
+ (RKTextListStyling *)textListWithLevelFormats:(NSArray *)levelFormats;

/*!
 @astract Returns the format definition for a certain level
 */
-(NSString *)formatOfLevel:(NSUInteger)levelIndex;

@end
