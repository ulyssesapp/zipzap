//
//  RKPDFImage.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

@class RKImageAttachment;

/*!
 @abstract An image inside an attributed string used for PDF rendering
 */
@interface RKPDFImage : RKPDFTextObject

/*!
 @abstract Initializes the image with a file wrapper
 @discussion Returns 'nil' if the image file is not valid
 */
- (id)initWithImageAttachment:(RKImageAttachment *)image context:(RKPDFRenderingContext *)context;

/*!
 @abstract The image attachment associated with the object.
 */
@property (nonatomic, strong, readonly) RKImageAttachment *imageAttachment;

@end
