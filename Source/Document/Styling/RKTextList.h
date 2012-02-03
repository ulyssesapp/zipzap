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
 @discussion The format string consists of an arbitrary text and at most one placeholder
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
 @astract Returns the format definition for a certain level
 */
-(NSString *)formatOfLevel:(NSUInteger)levelIndex;

@end
