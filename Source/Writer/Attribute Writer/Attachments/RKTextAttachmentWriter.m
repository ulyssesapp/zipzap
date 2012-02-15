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
    [RKAttributedStringWriter registerWriter:self forAttribute:NSAttachmentAttributeName priority:RKAttributedStringWriterPriorityTextAttachmentLevel];
}

+ (void)addTagsForAttribute:(NSString *)attributeName 
                      value:(NSTextAttachment *)textAttachment
             effectiveRange:(NSRange)range 
                   toString:(RKTaggedString *)taggedString 
             originalString:(NSAttributedString *)attributedString 
           attachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                  resources:(RKResourcePool *)resources
{
    if (textAttachment) {
        NSFileWrapper *fileWrapper = textAttachment.fileWrapper;
        
        switch (attachmentPolicy) {
            case RKAttachmentPolicyEmbed:
                [self addTagsForEmbeddedFile:fileWrapper toTaggedString:taggedString inRange:range resources:resources];
                break;
            
            case RKAttachmentPolicyReference:
                [self addTagsForReferencedFile:fileWrapper toTaggedString:taggedString inRange:range resources:resources];
                break;
                
            case RKAttachmentPolicyIgnore:
                break;            
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
    // Add prefix
    [taggedString registerTag:@"{\\pict\\picscalex100\\picscaley100\\pngblip\n" forPosition:range.location];

    // Convert content only, if it is a regular file
    if (!fileWrapper.isRegularFile)
        return;
    
    NSData *originalImage = [fileWrapper regularFileContents];
    NSData *convertedImage = [[NSBitmapImageRep imageRepWithData:originalImage] representationUsingType:NSPNGFileType properties:nil ];
    
    // Add content
    [taggedString registerTag:[convertedImage stringWithRTFHexEncoding] forPosition:range.location];
    
    // Add suffix
    [taggedString registerTag:@"\n}" forPosition:range.location];
}

+ (void)addTagsForReferencedFile:(NSFileWrapper *)fileWrapper
                  toTaggedString:(RKTaggedString *)taggedString 
                         inRange:(NSRange)range
                       resources:(RKResourcePool *)resources
{
    NSString *filename = [resources registerFileWrapper:fileWrapper];
    
    // Register the tag
    // Note: the 0xAC byte is required by the RTFD definition
    [taggedString registerTag:[NSString stringWithFormat:@"{{\\NeXTGraphic %@ \\width0 \\height0}¬}", filename] forPosition:range.location];
}

@end
