//
//  RKPDFImage.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

/*!
 @abstract An image inside an attributed string used for PDF rendering
 */
@interface RKPDFImage : RKPDFTextObject

/*!
 @abstract Initializes the image with a file wrapper
 */
- (id)initWithFileWrapper:(NSFileWrapper *)file;

@end
