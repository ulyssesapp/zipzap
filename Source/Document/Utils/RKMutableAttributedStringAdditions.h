//
//  RKAttributedStringAdditions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 08.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface NSMutableAttributedString (RKMutableAttributedStringAdditions)

/*!
 @abstract Inserts a list item paragraph into an attributed string at a certain position
 */
- (void)insertListItem:(NSAttributedString *)text usingList:(RKTextList*)textList withIndentationLevel:(NSUInteger)indentationLevel atIndex:(NSUInteger)location; 

/*!
 @abstract Appends a list item paragraph to an attributed string
 */
- (void)appendListItem:(NSAttributedString *)text usingList:(RKTextList*)textList withIndentationLevel:(NSUInteger)indentationLevel; 

@end
