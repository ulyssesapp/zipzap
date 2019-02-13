//
//  RKImageAttachment.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.09.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import "RKImageAttachment.h"

NSString *RKImageAttachmentAttributeName		= @"RKImageAttachment";

@implementation RKImageAttachment

- (id)initWithFile:(NSFileWrapper *)file title:(NSString *)title description:(NSString *)descr margin:(RKEdgeInsets)margin size:(NSSize)proposedSize
{
	self = [super init];
	
	if (self) {
		_imageFile = file;
		_image = [[RKImage alloc] initWithData: _imageFile.regularFileContents];
		_title = title;
		_descr = descr;
		_margin = margin;
		
		NSSize actualImageSize = _image.size;
		CGFloat ratio = actualImageSize.height / actualImageSize.width;
		
		if (proposedSize.width && !proposedSize.height)
			_size = NSMakeSize(proposedSize.width, proposedSize.width * ratio);
		
		else if (proposedSize.height && !proposedSize.width)
			_size = NSMakeSize(proposedSize.height * (1.0  / ratio), proposedSize.height);
		
		else if (proposedSize.height && proposedSize.width)
			_size = proposedSize;
		
		else
			_size = actualImageSize;
	}
	
	return self;
}

@end
