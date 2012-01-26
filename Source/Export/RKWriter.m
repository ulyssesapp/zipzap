//
//  RKWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"
#import "RKResourcePool.h"
#import "RKHeaderWriter.h"
#import "RKBodyWriter.h"

@interface RKWriter ()

/*!
 @abstract Writes out the contents of an RKDocument as RTF into a string
 @discussion The handling of inline attachments can be switched between the NextStep (RTFD) format and the Microsoft format
 */
+ (NSString *)RTFStringFromDocument:(RKDocument *)document withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy;

@end

@implementation RKWriter

+ (NSData *)RTFfromDocument:(RKDocument *)document
{
    return [[self RTFStringFromDocument:document withAttachmentPolicy:RKEmbedAttachedFiles] dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSData *)PlainRTFfromDocument:(RKDocument *)document
{
    return [[self RTFStringFromDocument:document withAttachmentPolicy:RKIgnoreAttachedFiles] dataUsingEncoding:NSASCIIStringEncoding];
}

+ (NSFileWrapper *)RTFDfromDocument:(RKDocument *)document
{
    NSAssert(false, @"Not implemented");
    return nil;
}

+ (NSString *)RTFStringFromDocument:(RKDocument *)document withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy
{
    RKResourcePool *resources = [[RKResourcePool alloc] init];

    NSString *body = [RKBodyWriter RTFBodyFromDocument:document withAttachmentPolicy:attachmentPolicy resources:resources];
    NSString *head = [RKHeaderWriter RTFHeaderFromDocument:document withResources:resources];

    return [NSString stringWithFormat:@"{%@\n%@\n}\n", head, body];
}

@end
