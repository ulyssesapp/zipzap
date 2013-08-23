//
//  RKWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"
#import "RKConversionPolicy.h"
#import "RKResourcePool.h"
#import "RKHeaderWriter.h"
#import "RKBodyWriter.h"

@interface RKWriter ()

/*!
 @abstract Writes out the contents of an RKDocument as RTF as an NSData object
 @discussion The handling of inline attachments can be switched between the NextStep (RTFD) format and the Microsoft format. It also returns a resource pool that describes all resources that have been collected through the document processing. The document will be encoded to ISO-Latin-1 as required by the RTF standard.
 */
+ (NSData *)RTFDataFromDocument:(RKDocument *)document withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool **)resourcesOut;

@end

@implementation RKWriter

+ (NSData *)wordRTFfromDocument:(RKDocument *)document
{
    return [self RTFDataFromDocument:document withConversionPolicy:RKConversionPolicyConvertAttachments|RKConversionPolicyPositionListMarkerUsingIndent resources:NULL];
}

+ (NSData *)systemRTFfromDocument:(RKDocument *)document
{
    return [self RTFDataFromDocument:document withConversionPolicy:RKConversionPolicyAddLineBreaksOnSectionBreaks resources:NULL];
}

+ (NSFileWrapper *)RTFDfromDocument:(RKDocument *)document
{
    RKResourcePool *resources;
    
    // Generate RTF document
    NSData *rtfContent = [self RTFDataFromDocument:document withConversionPolicy:(RKConversionPolicyConvertAttachments|RKConversionPolicyReferenceAttachments|RKConversionPolicyAddLineBreaksOnSectionBreaks) resources:&resources];
    NSFileWrapper *rtfFile = [[NSFileWrapper alloc] initRegularFileWithContents:rtfContent];

    // Pacakge image files
    NSMutableDictionary *packageFiles = [NSMutableDictionary dictionaryWithDictionary: resources.attachmentFileWrappers];
    
    packageFiles[@"TXT.rtf"] = rtfFile;
        
    // Generate RTFD file wrapper
    return [[NSFileWrapper alloc] initDirectoryWithFileWrappers:packageFiles ];
}

+ (NSData *)RTFDataFromDocument:(RKDocument *)document withConversionPolicy:(RKConversionPolicy)conversionPolicy resources:(RKResourcePool **)resourcesOut
{
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument: document];

    if (resourcesOut)
        *resourcesOut = resources;
    
    // Tranlsate body and header
    NSString *body = [RKBodyWriter RTFBodyFromDocument:document withConversionPolicy:conversionPolicy resources:resources];
    NSString *head = [RKHeaderWriter RTFHeaderFromDocument:document withResources:resources];
    
    // Generate document and encode it to ISO-Latin-1
    return [[NSString stringWithFormat:@"{%@\n%@\n}\n", head, body] dataUsingEncoding:NSISOLatin1StringEncoding];
}

@end
