//
//  RKWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"
#import "RKResourceManager.h"

@interface RKWriter ()

/*!
 @abstract Writes out the contents of an RKDocument as RTF into a string
 @discussion The handling of inline attachments can be switched between the NextStep (RTFD) format and the Microsoft format
 */
+ (NSString *)RTFStringFromDocument:(RKDocument *)document usingRTFDAttachments:(BOOL)rtfdAttachments;

/*!
 @abstract Generates the body content of a RTF document
 @discussion All resources collected during the operation are passed as an output argument
 */
+ (NSString *)RTFBodyFromDocument:(RKDocument *)document usingRTFDAttachments:(BOOL)rtfdAttachments resources:(RKResourceManager *__autoreleasing *)resources;

/*!
 @abstract Generates the header content of a RTF document based on a set of filtered resources (e.g. fonts, colors)
 */
+ (NSString *)RTFHeaderFromDocument:(RKDocument *)document withResources:(RKResourceManager *)resources;

/*!
 @abstract Generates the font table using a resource manager
 */
+ (NSString *)fontTableFromResourceManager:(RKResourceManager *)resources;

/*!
 @abstract Generates the color table using a resource manager
 */
+ (NSString *)colorTableFromResourceManager:(RKResourceManager *)resources;

/*!
 @abstract Generates the document informations from a document
 */
+ (NSString *)documentInfoFromDocument:(RKDocument *)document;

/*!
 @abstract Generates the document layout settings from a document
 */
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;

@end

@implementation RKWriter

+ (NSData *)RTFfromDocument:(RKDocument *)document
{
    return [[RKWriter RTFStringFromDocument:document usingRTFDAttachments:NO] dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSString *)RTFStringFromDocument:(RKDocument *)document usingRTFDAttachments:(BOOL)rtfdAttachments
{
    RKResourceManager *resources;
    NSString *head, *body;

    body = [RKWriter RTFBodyFromDocument:document usingRTFDAttachments:rtfdAttachments resources:&resources];
    head = [RKWriter RTFHeaderFromDocument:document withResources:resources];

    return [NSString stringWithFormat:@"{%@\n%@}\n", head, body];
}

+ (NSString *)RTFBodyFromDocument:(RKDocument *)document usingRTFDAttachments:(BOOL)rtfdAttachments resources:(RKResourceManager *__autoreleasing *)resources
{
    *resources = [[RKResourceManager alloc] init];
    
    return @"";
}

+ (NSString *)RTFHeaderFromDocument:(RKDocument *)document withResources:(RKResourceManager *)resources
{
    return [NSString stringWithFormat:@"\rtf1\ansi\ansicpg1252%@%@%@%@",
            [RKWriter fontTableFromResourceManager:resources],
            [RKWriter colorTableFromResourceManager:resources],
            [RKWriter documentInfoFromDocument:document],
            [RKWriter documentFormatFromDocument:document]
           ];
}

@end
