//
//  RKPDFImage.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFImage.h"

#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFUtilities.h"
#import "RKDocument+PDFUtilities.h"


@interface RKPDFImage ()
{
    NSFileWrapper *_fileWrapper;
    CGSize _imageSize;
    CGImageRef _image;
}

/*!
 @abstract Calculates the actual size that can be used by the image inside a frame of a certain size
 */
- (CGSize)scaledSizeForSize:(CGSize)frameSize;

@end

@implementation RKPDFImage

@synthesize fileWrapper=_fileWrapper;

- (id)initWithFileWrapper:(NSFileWrapper *)file context:(RKPDFRenderingContext *)context
{
    self = [self init];
    
    if (self) {
        _fileWrapper = file;
        
        #if TARGET_OS_MAC
            NSImage *image = [[NSImage alloc] initWithData:self.fileWrapper.regularFileContents];
            if (!image)
                return nil;
        
            _image = [image CGImageForProposedRect:NULL context:context.nsPdfContext hints:NULL];
            CFRetain(_image);

            _imageSize = CGSizeMake(CGImageGetWidth(_image), CGImageGetHeight(_image));
        #endif
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
    CGSize actualSize = [self scaledSizeForSize: rect.size];
    
    CGContextDrawImage(context.pdfContext, CGRectMake(rect.origin.x, rect.origin.y, actualSize.width, actualSize.height), _image);
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex frameSize:(CGSize)frameSize
{
    CGSize actualSize = [self scaledSizeForSize: frameSize];
    
    return [NSAttributedString spacingWithHeight:actualSize.height width:actualSize.width];
}

- (CGSize)scaledSizeForSize:(CGSize)frameSize
{
    CGFloat scale = 1;
    
    if (_imageSize.width > frameSize.width)
        scale = frameSize.width / _imageSize.width;
    
    if ((_imageSize.height * scale) > frameSize.height)
        scale = frameSize.height / _imageSize.height;

    return CGSizeMake(_imageSize.width * scale, _imageSize.height * scale);
}

@end
