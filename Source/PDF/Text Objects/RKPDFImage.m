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
	
	// The full size of the image (including its margins)
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
            UIImage *image = [[UIImage alloc] initWithData:self.fileWrapper.regularFileContents];
            if (!image || CGSizeEqualToSize(image.size, CGSizeZero))
                return nil;
        
            _image = image.CGImage;
			if (!_image)
				return nil;
		
            CFRetain(_image);
        #endif

        if (_image) {
			NSEdgeInsets margins = self.imageAttachment.margins;
			
            _imageSize = CGSizeMake(CGImageGetWidth(_image), CGImageGetHeight(_image));
			_fullSize = CGSizeMake(_imageSize.width + margins.left + margins.right, _imageSize.height + margins.top + margins.bottom);
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
    NSEdgeInsets margins = self.imageAttachment.margins;
	
    CGContextDrawImage(context.pdfContext, CGRectMake(rect.origin.x + margins.left, rect.origin.y + margins.bottom, actualSize.width, actualSize.height), _image);
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex frameSize:(CGSize)frameSize
{
    CGSize actualSize = [self scaledSizeForMaximumSize: frameSize];
    NSEdgeInsets margins = self.imageAttachment.margins;
	
    return [NSAttributedString stringWithSpacingForWidth:(actualSize.width + margins.left + margins.right)];
}

- (CGSize)scaledSizeForMaximumSize:(CGSize)frameSize
{
    CGFloat scale = 1;
    
	// Scale without margins
	NSEdgeInsets margins = self.imageAttachment.margins;
	frameSize.width = (frameSize.width - margins.left - margins.right) ?: 0;
	frameSize.height = (frameSize.height - margins.top - margins.bottom) ?: 0;
	
    if (_imageSize.width > frameSize.width)
        scale = frameSize.width / _imageSize.width;
    
    if ((_imageSize.height * scale) > frameSize.height)
        scale = frameSize.height / _imageSize.height;

    return CGSizeMake(_imageSize.width * scale, _imageSize.height * scale);
}

- (CGFloat)preferredHeightForMaximumSize:(CGSize)frameSize
{
	NSEdgeInsets margins = self.imageAttachment.margins;
	return [self scaledSizeForMaximumSize: frameSize].height + margins.top + margins.bottom;
}

@end
