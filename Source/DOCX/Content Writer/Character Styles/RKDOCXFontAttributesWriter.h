//
//  RKDOCXFontAttributeWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 31.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXAttributeWriter.h"

/*!
 @abstract Generates XML elements for the given attributes of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.2.1 (Bold), §17.3.2.16 (Italics), §17.3.2.26 (Run Fonts), §17.3.2.38 (Non-Complex Script Font Size) and §17.3.2.39 (Complex Script Font Size).
 */
@interface RKDOCXFontAttributesWriter : RKDOCXAttributeWriter

@end
