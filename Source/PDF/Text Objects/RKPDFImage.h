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
 @discussion Returns 'nil' if the image file is not valid
 */
- (id)initWithFileWrapper:(NSFileWrapper *)file context:(RKPDFRenderingContext *)context;

/*!
 @abstract The file wrapper associated with the object
 */
@property (nonatomic, strong, readonly) NSFileWrapper *fileWrapper;

@end
