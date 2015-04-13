//
//  RKDOCXSectionWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributedStringWriter.h"
#import "RKDOCXConversionContext.h"

/*!
 @abstract Generates a section properties element "<w:sectPr>" for each section of the parent document.
 @discussion See ISO 29500-1:2012: §17.6.18 (Section Properties).
 */
@interface RKDOCXSectionWriter : NSObject

/*!
 @abstract Returns an array of paragraphs and section properties in form of XML elements.
 @discussion Array represents the "children" array of the parent document.
 */
+ (NSArray *)sectionsUsingContext:(RKDOCXConversionContext *)context;

@end
