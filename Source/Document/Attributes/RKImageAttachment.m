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

- (id)initWithFile:(NSFileWrapper *)file margin:(RKEdgeInsets)margin
{
	self = [super init];
	
	if (self) {
		_imageFile = file;
		_margin = margin;
	}
	
	return self;
}

@end
