//
//  RKImageAttachment.h
//  RTFKit
//
//  Created by Friedrich Gräter on 23.09.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

extern NSString *RKImageAttachmentAttributeName;

/*!
 @abstract Container for image attachments.
 */
@interface RKImageAttachment : NSObject

/*!
 @abstract Initializes an init attachment with the given file and margins.
 */
- (id)initWithFile:(NSFileWrapper *)file margins:(NSEdgeInsets)margins;

/*!
 @abstract The NSFileWrapper containing the actual image file.
 */
@property(nonatomic, readonly) NSFileWrapper *imageFile;

/*!
 @abstract The margins of the image.
 @discussion Defaults to 0. Will be ignored on RTF export.
 */
@property(nonatomic, readonly) NSEdgeInsets margins;

@end
