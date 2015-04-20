//
//  RKDOCXParagraphStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributeWriter.h"

/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.1.6 (Right to Left Paragraph Layout), §17.3.1.12 (Paragraph Indentation), §17.3.1.13 (Paragraph Alignment), §17.15.1.25 (Distance Between Automatic Stops), §17.3.1.33 (Spacing Between Lines and Above/Below Paragraph) and §17.3.1.38 (Set of Custom Tab Stops).
 */
@interface RKDOCXParagraphStyleWriter : RKDOCXAttributeWriter

@end
