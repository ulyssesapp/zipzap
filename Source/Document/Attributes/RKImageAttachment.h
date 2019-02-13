//
//  RKImageAttachment.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.09.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import "RKImage.h"

/*!
 @abstract Attribute name for placing images within an attributed string passed to RTFKit.
 */
extern NSString *RKImageAttachmentAttributeName;

/*!
 @abstract Container for image attachments.
 @discussion Referenced by RKImageAttachmentAttributeName inside attributed strings.
 */
@interface RKImageAttachment : NSObject

/*!
 @abstract Initializes an image attachment with the given file, title, description and margin.
 @discussion The given size can be incomplete. If all dimensions are set to 0, the image's original size is used. If a single dimension is set to 0, it is derived from the other dimension maintaining the original aspect ratio.
 */
- (instancetype)initWithFile:(NSFileWrapper *)file title:(NSString *)title description:(NSString *)descr margin:(RKEdgeInsets)margin size:(NSSize)size;

/*!
 @abstract The NSFileWrapper containing the actual image file.
 */
@property(nonatomic, readonly) NSFileWrapper *imageFile;

/*!
 @abstract The image read from the file wrapper.
 */
@property(nonatomic, readonly) RKImage *image;

/*!
 @abstract The title of the image.
 */
@property(nonatomic, readonly) NSString *title;

/*!
 @abstract The description of the image.
 */
@property(nonatomic, readonly) NSString *descr;

/*!
 @abstract The margin of the image.
 @discussion Defaults to 0. Image margin is only supported by Word.
 */
@property(nonatomic, readonly) RKEdgeInsets margin;

/*!
 @abstract The size of the image in points.
 */
@property(nonatomic, readonly) NSSize size;

@end
