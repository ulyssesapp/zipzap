//
//  RKWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriter.h"
#import "RKResourceManager.h"
#import "RKHeaderWriter.h"
#import "RKBodyWriter.h"

@interface RKWriter ()

/*!
 @abstract Writes out the contents of an RKDocument as RTF into a string
 @discussion The handling of inline attachments can be switched between the NextStep (RTFD) format and the Microsoft format
 */
+ (NSString *)RTFStringFromDocument:(RKDocument *)document usingRTFDAttachments:(BOOL)rtfdAttachments;

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

    body = [RKBodyWriter RTFBodyFromDocument:document usingRTFDAttachments:rtfdAttachments resources:&resources];
    head = [RKHeaderWriter RTFHeaderFromDocument:document withResources:resources];

    return [NSString stringWithFormat:@"{%@\n%@}\n", head, body];
}

+ (NSFileWrapper *)RTFDfromDocument:(RKDocument *)document
{
    NSAssert(false, @"Not implemented");
    return nil;
}

@end
