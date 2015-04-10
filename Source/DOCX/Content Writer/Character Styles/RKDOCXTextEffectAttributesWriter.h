//
//  RKDOCXTextEffectsWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 07.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributeWriter.h"


/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.2.6 (Run Content Color), §17.3.2.23 (Display Character Outline), §17.3.2.31 (Shadow), §17.3.2.37/§17.3.2.9 (Single Strikethrough/Double Strikethrough), §17.3.2.40 (Underline) and §17.3.2.42 (Subscript/Superscript Text).
 */
@interface RKDOCXTextEffectAttributesWriter : RKDOCXAttributeWriter

@end
