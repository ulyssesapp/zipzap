//
//  RKImageAttachmentWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKImageAttachmentWriter.h"
#import "RKImageAttachment.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"
#import "RKWriter.h"
#import "RKConversion.h"

@implementation RKImageAttachmentWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKImageAttachmentAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
    }
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(RKImageAttachment *)textAttachment
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources
{
    if (textAttachment) {
        NSAssert([textAttachment isKindOfClass: RKImageAttachment.class], @"Expecting NSTextAttachment");
		
        // Convert images only, if allowed
		if (conversionPolicy & RKConversionPolicyConvertAttachments) {
			NSFileWrapper *fileWrapper = [textAttachment imageFile];
			
			if (conversionPolicy & RKConversionPolicyReferenceAttachments)
				// Convert reference attachments for RTFD
				 [self addTagsForReferencedFile:fileWrapper toTaggedString:taggedString inRange:range resources:resources];
			else
				// Create inline attachments for Word-RTF
				[self addTagsForEmbeddedAttachment:textAttachment toTaggedString:taggedString inRange:range resources:resources];
		}
        
        // Select attachment charracter for removal in any case
        [taggedString removeRange:range];
    }
}

+ (void)addTagsForEmbeddedAttachment:(RKImageAttachment *)attachment
					  toTaggedString:(RKTaggedString *)taggedString
							 inRange:(NSRange)range
						   resources:(RKResourcePool *)resources
{
    // Convert content only, if it is a regular file
    if (!attachment.imageFile.isRegularFile)
        return;

    // Encode image
    NSData *originalImage = [attachment.imageFile regularFileContents];
	CGSize imageSize = NSMakeSize(0, 0);
    
#if !TARGET_OS_IPHONE
	NSBitmapImageRep *representation = [NSBitmapImageRep imageRepWithData: originalImage];
    NSData *convertedImage = [representation representationUsingType:NSPNGFileType properties:nil ];
	imageSize = representation.size;
#else
    UIImage *image = [UIImage imageWithData: originalImage];
    NSData *convertedImage = UIImagePNGRepresentation(image);
	imageSize = image.size;
#endif
    
    NSString *encodedImage = [convertedImage stringWithRTFHexEncoding];
    if (!encodedImage)
        return;
    
    // Add prefix with crop values (negative values mean: margin; height/width required for cropping)
	NSString *imageTag = [NSString stringWithFormat: @"{\\pict\\picscalex100\\picscaley100\\piccropt%li\\piccropl%li\\piccropb%li\\piccropr%li\\picwgoal%lu\\pichgoal%lu\\pngblip\n", (NSInteger)RKPointsToTwips(-attachment.margins.top), (NSInteger)RKPointsToTwips(-attachment.margins.left), (NSInteger)RKPointsToTwips(-attachment.margins.bottom), (NSInteger)RKPointsToTwips(-attachment.margins.right), (NSUInteger)RKPointsToTwips(imageSize.width), (NSUInteger)RKPointsToTwips(imageSize.height)];
    [taggedString registerTag:imageTag forPosition:range.location];
    
    // Add content
    [taggedString registerTag:encodedImage forPosition:range.location];
    
    // Add suffix
    [taggedString registerTag:@"\n}" forPosition:range.location];
}

+ (void)addTagsForReferencedFile:(NSFileWrapper *)fileWrapper
                  toTaggedString:(RKTaggedString *)taggedString 
                         inRange:(NSRange)range
                       resources:(RKResourcePool *)resources
{
    // Ignore empty files or files without a file name
    if (!fileWrapper || !fileWrapper.filename || !fileWrapper.preferredFilename)
        return;
    
    NSString *filename = [resources registerFileWrapper: fileWrapper];
    
    // Register the tag
    // Note: the 0xAC byte is required by the RTFD definition
    [taggedString registerTag:[NSString stringWithFormat:@"{{\\NeXTGraphic %@ \\width0 \\height0}¬}", filename] forPosition:range.location];
}

@end
