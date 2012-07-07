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
 @abstract Provides a page number string for a page number based on the numbering style of the section
 */
- (NSString *)stringForPageNumber:(NSUInteger)pageNumber;

@end
