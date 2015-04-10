//
//  RKDOCXAdditionalParagraphStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 10.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphAttributeWriter.h"

/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.1.15 (Keep Paragraph With Next Paragraph), §17.3.1.34 (Supress Hyphenation for Paragraph) and §17.3.1.44 (Allow First/Last Line to Display on a Separate Page).
 */
@interface RKDOCXAdditionalParagraphStyleWriter : RKDOCXParagraphAttributeWriter

@end
