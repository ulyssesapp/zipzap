//
//  RKDOCXTabStopWriter.h
//  RTFKit
//
//  Created by Lucas Hauswald on 09.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXParagraphAttributeWriter.h"


/*!
 @abstract Generates XML elements to translate the custom tab stop settings and the default tab interval of an attributed string.
 @discussion See ISO 29500-1:2012: §17.3.1.38 (Set of Custom Tab Stops) and §17.15.1.25 (Distance Between Automatic Stops).
 */
@interface RKDOCXTabStopWriter : RKDOCXParagraphAttributeWriter

@end
