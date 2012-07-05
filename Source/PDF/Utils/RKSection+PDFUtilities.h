//
//  RKSection+PDFUtilities.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"

@interface RKSection (PDFUtilities)

/*!
 @abstract Creates a new section containing the given endnotes
 @discussion An array of NSAttributedString ordered by endnote indices
 */
+ (RKSection *)sectionWithEndnotes:(NSArray *)endnotes;

@end
