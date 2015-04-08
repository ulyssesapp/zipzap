//
//  RKDOCXParagraphStyleWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 08.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphAttributeWriter.h"


/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.1.6 (Right to Left Paragraph Layout), §17.3.1.12 (Paragraph Indentation), §17.3.1.13 (Paragraph Alignment) and §17.3.1.33 (Spacing Between Lines and Above/Below Paragraph).
 */
@interface RKDOCXParagraphStyleWriter : RKDOCXParagraphAttributeWriter

@end
