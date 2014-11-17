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
    
    if (self) {
        _imageAttachment = attachment;
        
        #if !TARGET_OS_IPHONE
            NSImage *image = [[NSImage alloc] initWithData:_imageAttachment.imageFile.regularFileContents];
            if (!image || NSEqualSizes(image.size, NSZeroSize))
                return nil;
        
            _image = [image CGImageForProposedRect:NULL context:context.nsPdfContext hints:NULL];
			if (!_image)
				return nil;
		
            CFRetain(_image);
        #else
            UIImage *image = [[UIImage alloc] initWithData:_imageAttachment.imageFile.regularFileContents];
            if (!image || CGSizeEqualToSize(image.size, CGSizeZero))
                return nil;
        
            _image = image.CGImage;
			if (!_image)
				return nil;
		
            CFRetain(_image);
        #endif

        if (_image) {
			RKEdgeInsets margin = self.imageAttachment.margin;
			
            _imageSize = CGSizeMake(CGImageGetWidth(_image), CGImageGetHeight(_image));
			_fullSize = CGSizeMake(_imageSize.width + margin.left + margin.right, _imageSize.height + margin.top + margin.bottom);
		}
    }
    
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
