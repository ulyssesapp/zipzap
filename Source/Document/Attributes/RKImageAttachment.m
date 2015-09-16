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

- (id)initWithFile:(NSFileWrapper *)file title:(NSString *)title description:(NSString *)descr margin:(RKEdgeInsets)margin
{
	self = [super init];
	
	if (self) {
		_imageFile = file;
		_title = title ?: @"";
		_descr = descr ?: @"";
		_margin = margin;
	}
	
	return self;
}

@end
