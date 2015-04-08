//
//  RKDOCXAttributedStringWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

/*!
 @abstract Generates a paragraph containing the paragraph's properties and its child runs.
 */
@interface RKDOCXAttributedStringWriter : NSObject

/*!
 @abstract Returns an array of XML elements representing the paragraphs of the attributed string.
 */
+ (NSArray *)processAttributedString:(NSAttributedString *)attributedString;

@end
