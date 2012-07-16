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


@interface RKPDFImage ()
{
    NSFileWrapper *_fileWrapper;
    CGSize _imageSize;
    CGImageRef _image;
}

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
            _image = [image CGImageForProposedRect:NULL context:context.nsPdfContext hints:NULL];
        #else
            #warning Not supported!
        #endif
        
        _imageSize = CGSizeMake(CGImageGetWidth(_image), CGImageGetHeight(_image));
    }
    
    return self;
}

- (void)dealloc
{
//    CFRelease(_image);
}

- (void)renderUsingContext:(RKPDFRenderingContext *)context rect:(CGRect)rect
{
    CGContextDrawImage(context.pdfContext, CGRectMake(rect.origin.x, rect.origin.y, _imageSize.width, _imageSize.height), _image);
}

- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex
{
    return [NSAttributedString spacingWithHeight:_imageSize.height width:_imageSize.width];
}

@end
