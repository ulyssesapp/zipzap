//
//  RKPDFBackgroundColorRenderer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextRenderer.h"

/*!
 @abstract The attribute used to describe the background color in a core text representation
 @discussion References a CGColorRef
 */
extern NSString *RKPDFBackgroundColorAttributeName;

/*!
 @abstract Adds a background color on a text area after rendering
 */
@interface RKPDFBackgroundColorRenderer : RKPDFTextRenderer

@end
