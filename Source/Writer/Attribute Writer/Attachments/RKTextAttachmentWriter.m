//
//  RKTextAttachmentWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKTextAttachmentWriter.h"
#import "RKTaggedString.h"
#import "RKResourcePool.h"
#import "RKWriter.h"
#import "RKConversion.h"

@interface RKTextAttachmentWriter ()
/*!
 @abstract Generates the tags for an embedded picture file
 @discussion If the image file is not a PNG, it will be converted if possible
 */
+ (void)addTagsForEmbeddedFile:(NSFileWrapper *)fileWrapper
                toTaggedString:(RKTaggedString *)taggedString 
                       inRange:(NSRange)range
                     resources:(RKResourcePool *)resources;

/*!
 @abstract Generates the tags for an referenced file
 @discussion The reference file will not be converted. It is possible to reference arbitrary files.
 */
+ (void)addTagsForReferencedFile:(NSFileWrapper *)fileWrapper
                  toTaggedString:(RKTaggedString *)taggedString 
                         inRange:(NSRange)range
                       resources:(RKResourcePool *)resources;

@end

@implementation RKTextAttachmentWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKAttachmentAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
    }
}

+ (void)addTagsForAttribute:(NSString *)attributeName
                      value:(id)textAttachment
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           conversionPolicy:(RKConversionPolicy)conversionPolicy 
                  resources:(RKResourcePool *)resources
{
    if (textAttachment) {
        #if !TARGET_OS_IPHONE
            NSAssert([textAttachment isKindOfClass: NSTextAttachment.class], @"Expecting NSTextAttachment");
        #else
            NSAssert([textAttachment isKindOfClass: RKTextAttachment.class], @"Expecting NSTextAttachment");
        #endif        
        
        // Convert images only, if allowed
		if (conversionPolicy & RKConversionPolicyConvertAttachments) {
			NSFileWrapper *fileWrapper = [textAttachment fileWrapper];
			
			if (conversionPolicy & RKConversionPolicyReferenceAttachments)
				// Convert reference attachments for RTFD
				 [self addTagsForReferencedFile:fileWrapper toTaggedString:taggedString inRange:range resources:resources];
			else
				// Create inline attachments for Word-RTF
				[self addTagsForEmbeddedFile:fileWrapper toTaggedString:taggedString inRange:range resources:resources];
		}
        
        // Select attachment charracter for removal in any case
        [taggedString removeRange:range];
    }
}

+ (void)addTagsForEmbeddedFile:(NSFileWrapper *)fileWrapper
                toTaggedString:(RKTaggedString *)taggedString 
                       inRange:(NSRange)range
                     resources:(RKResourcePool *)resources
{
    // Convert content only, if it is a regular file
    if (!fileWrapper.isRegularFile)
        return;

    // Encode image
    NSData *originalImage = [fileWrapper regularFileContents];
    
#if !TARGET_OS_IPHONE
    NSData *convertedImage = [[NSBitmapImageRep imageRepWithData: originalImage] representationUsingType:NSPNGFileType properties:nil ];
#else
    UIImage *image = [UIImage imageWithData: originalImage];
    NSData *convertedImage = UIImagePNGRepresentation(image);
#endif
    
    NSString *encodedImage = [convertedImage stringWithRTFHexEncoding];
    if (!encodedImage)
        return;
    
    // Add prefix
    [taggedString registerTag:@"{\\pict\\picscalex100\\picscaley100\\pngblip\n" forPosition:range.location];
    
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
