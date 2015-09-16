//
//  RKImageAttachment.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.09.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

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
 @abstract Initializes an init attachment with the given file, title, description and margin.
 */
- (id)initWithFile:(NSFileWrapper *)file title:(NSString *)title description:(NSString *)descr margin:(RKEdgeInsets)margin;

/*!
 @abstract The NSFileWrapper containing the actual image file.
 */
@property (nonatomic, readonly) NSFileWrapper *imageFile;

/*!
 @abstract The title of the image.
 */
@property (nonatomic, readonly) NSString *title;

/*!
 @abstract The description of the image.
 */
@property (nonatomic, readonly) NSString *descr;

/*!
 @abstract The margin of the image.
 @discussion Defaults to 0. Image margin is only supported by Word.
 */
@property (nonatomic, readonly) RKEdgeInsets margin;

@end
