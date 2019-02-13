//
//  RKPDFImage.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFImage.h"

#import "RKImageAttachment.h"
#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFUtilities.h"
#import "RKDocument+PDFUtilities.h"


@interface RKPDFImage ()
{
	// The size of the image as loaded from disk
    CGSize _imageSize;
	
	// The full size of the image (including its margin)
	CGSize _fullSize;
	
	// The image loaded from disk
    CGImageRef _image;
}

@end

@implementation RKPDFImage

- (id)initWithImageAttachment:(RKImageAttachment *)attachment context:(RKPDFRenderingContext *)context
{
    self = [self init];
    
	_imageAttachment = attachment;
	if (!attachment.image || CGSizeEqualToSize(attachment.size, CGSizeZero))
		return nil;
	
	#if !TARGET_OS_IPHONE
		_image = [attachment.image CGImageForProposedRect:NULL context:context.nsPdfContext hints:NULL];
	#else
		_image = attachment.image.CGImage;
	#endif

	CFRetain(_image);

	if (!_image)
		return nil;

	RKEdgeInsets margin = self.imageAttachment.margin;
		
	_imageSize = attachment.size;
	_fullSize = CGSizeMake(_imageSize.width + margin.left + margin.right, _imageSize.height + margin.top + margin.bottom);
		
    return self;
}

- (void)dealloc
{
    if (_image)
        CFRelease(_image);
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context rect:(CGRect)rect
{
    CGSize actualSize = [self scaledSizeForMaximumSize: CGSizeMake(rect.size.width, _imageSize.height)];
    RKEdgeInsets margin = self.imageAttachment.margin;
	
    CGContextDrawImage(context.pdfContext, CGRectMake(rect.origin.x + margin.left, rect.origin.y + margin.bottom, actualSize.width, actualSize.height), _image);
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)index frameSize:(CGSize)frameSize
{
    CGSize actualSize = [self scaledSizeForMaximumSize: frameSize];
    RKEdgeInsets margin = self.imageAttachment.margin;
	
    return [NSAttributedString stringWithSpacingForWidth:(actualSize.width + margin.left + margin.right) attributes:[attributedString attributesAtIndex:index effectiveRange:NULL]];
}

- (CGSize)scaledSizeForMaximumSize:(CGSize)frameSize
{
    CGFloat scale = 1;
    
	// Scale without margin
	RKEdgeInsets margin = self.imageAttachment.margin;
	frameSize.width = (frameSize.width - margin.left - margin.right) ?: 0;
	frameSize.height = (frameSize.height - margin.top - margin.bottom) ?: 0;
	
    if (_imageSize.width > frameSize.width)
        scale = frameSize.width / _imageSize.width;
    
    if ((_imageSize.height * scale) > frameSize.height)
        scale = frameSize.height / _imageSize.height;

    return CGSizeMake(_imageSize.width * scale, _imageSize.height * scale);
}

- (CGFloat)preferredHeightForMaximumSize:(CGSize)frameSize
{
	RKEdgeInsets margin = self.imageAttachment.margin;
	return [self scaledSizeForMaximumSize: frameSize].height + margin.top + margin.bottom;
}

@end
