//
//  RKPDFWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFWriterTest.h"

#import "RKPDFWriter.h"
#import "RKDocument.h"
#import "RKDocument+RKPersistence.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>

@implementation RKPDFWriterTest

- (NSData *)pngDataForPDFData:(NSData *)pdfData
{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)pdfData);
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithProvider(dataProvider);
    NSUInteger pageCount = CGPDFDocumentGetNumberOfPages(pdfDocument);
    
    // Calculate bitmap size
    CGSize bitmapSize = CGSizeMake(0, 0);
    
    for (NSUInteger pageIndex = 0; pageIndex < pageCount; pageIndex ++) {
        CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocument, pageIndex + 1);
        CGRect pageBox = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
        
        bitmapSize.height = bitmapSize.height < pageBox.size.height ? pageBox.size.height : bitmapSize.height;
        bitmapSize.width += pageBox.size.width += 10;
    }
    
    // Render PDF to bitmap
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, bitmapSize.width, bitmapSize.height, 8, 4 * bitmapSize.width, CGColorSpaceCreateDeviceRGB(), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGFloat currentBitmapPos = 0;
    
	CGColorRef whiteColor = CGColorCreate(CGColorSpaceCreateDeviceGray(), (CGFloat[]){1, 1});
	
    for (NSUInteger pageIndex = 0; pageIndex < pageCount; pageIndex ++) {
        CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDocument, pageIndex + 1);
        CGRect pageBox = CGPDFPageGetBoxRect(pdfPage, kCGPDFMediaBox);
        
        CGContextSaveGState(bitmapContext);
        
        // Move coordinates to page offset
        CGContextTranslateCTM(bitmapContext, currentBitmapPos, 0);

        // Draw white background
        CGContextSetFillColorWithColor(bitmapContext, whiteColor);
        CGContextFillRect(bitmapContext, pageBox);
        
        // Draw pdf page
        CGContextDrawPDFPage(bitmapContext, pdfPage);

        CGContextRestoreGState(bitmapContext);

        currentBitmapPos += pageBox.size.width + 10;
    }
    
    // Create data object from context
    CGContextFlush(bitmapContext);
    CGImageRef image = CGBitmapContextCreateImage(bitmapContext);

    NSMutableData *pngData = [NSMutableData new];
    
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)pngData, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(imageDestination, image, NULL);
    CGImageDestinationFinalize(imageDestination);

    // Release all core foundation objects
    CFRelease(imageDestination);
    CFRelease(image);
    CFRelease(bitmapContext);
    CFRelease(dataProvider);
    CFRelease(pdfDocument);
    CFRelease(whiteColor);
    
    return pngData;
}

- (NSURL *)writeVerificationDataForFilename:(NSString *)filename usingPDFData:(NSData *)pdfData pngData:(NSData *)pngData expectedPngData:(NSData *)expectedPngData
{
    NSURL *temporaryDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    temporaryDirectoryURL = [temporaryDirectoryURL URLByAppendingPathComponent: @"rtfkit-pdf-test-verification"];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:temporaryDirectoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
    
    NSURL *generatedPDFFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat: @"%@.pdf", filename]];
    NSURL *generatedPNGFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat: @"%@.png", filename]];
    NSURL *expectedPNGFileURL = [temporaryDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat: @"%@.expected.png", filename]];
    
    NSFileWrapper *generatedPDFFile = [[NSFileWrapper alloc] initRegularFileWithContents: pdfData];
    [generatedPDFFile writeToURL:generatedPDFFileURL options:0 originalContentsURL:nil error:NULL];
    
    NSFileWrapper *generatedPNGFile = [[NSFileWrapper alloc] initRegularFileWithContents: pngData];
    [generatedPNGFile writeToURL:generatedPNGFileURL options:0 originalContentsURL:nil error:NULL];

	if (expectedPngData) {
		NSFileWrapper *expectedPNGFile = [[NSFileWrapper alloc] initRegularFileWithContents: expectedPngData];
		[expectedPNGFile writeToURL:expectedPNGFileURL options:0 originalContentsURL:nil error:NULL];
	}
	
    return generatedPDFFileURL;
}

- (void)testPDFRendering
{
	NSURL *expectedURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"expected" withExtension:nil subdirectory:@"Test Data/pdf"];
	NSURL *originalURL = [[NSBundle bundleForClass: [self class]] URLForResource:@"source" withExtension:nil subdirectory:@"Test Data/pdf"];
    
    NSFileWrapper *originalFiles = [[NSFileWrapper alloc] initWithURL:originalURL options:0 error:nil];
    NSFileWrapper *expectedFiles = [[NSFileWrapper alloc] initWithURL:expectedURL options:0 error:nil];
    
    [originalFiles.fileWrappers enumerateKeysAndObjectsUsingBlock:^(NSString *originalFilename, NSFileWrapper *originalFile, BOOL *stop) {
        // Create PDF and PNG from serialized RTF
        NSDictionary *originalFilePlist = [NSPropertyListSerialization propertyListWithData:originalFile.regularFileContents options:0 format:NULL error:nil];
        RKDocument *document = [[RKDocument alloc] initWithRTFKitPropertyListRepresentation:originalFilePlist error:nil];
        
        NSData *generatedPDFData = [RKPDFWriter PDFFromDocument:document options:RKPDFWriterShowMaximumFrameBounds|RKPDFWriterShowVisibleFrameBounds];
        NSData *generatedPNGData = [self pngDataForPDFData: generatedPDFData];
        
        // Convert expected data to bitmap
        NSFileWrapper *expectedPDFFile = [expectedFiles.fileWrappers objectForKey: [NSString stringWithFormat: @"%@.pdf", originalFilename]];
        NSData *expectedPNGData = nil;
        
        if (expectedPDFFile)
            expectedPNGData = [self pngDataForPDFData: expectedPDFFile.regularFileContents];

        // Write expected data to temporary folder (used to verify tests manually)
        NSURL *verificationURL = [self writeVerificationDataForFilename:originalFilename usingPDFData:generatedPDFData pngData:generatedPNGData expectedPngData:expectedPNGData];
				
        // Compare both files
        XCTAssertTrue([generatedPNGData isEqualToData: expectedPNGData], @"Expected and generated bitmap data differ: %@. See generated data at %@.", originalFilename, verificationURL);
    }];
}

@end
