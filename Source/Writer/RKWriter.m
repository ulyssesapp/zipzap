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
+ (NSString *)RTFStringFromDocument:(RKDocument *)document withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end

@implementation RKWriter

+ (NSData *)RTFfromDocument:(RKDocument *)document
{
    RKResourcePool *resources = [RKResourcePool new];
    
    return [[self RTFStringFromDocument:document withAttachmentPolicy:RKAttachmentPolicyEmbed resources:resources] dataUsingEncoding:NSISOLatin1StringEncoding];
}

+ (NSData *)plainRTFfromDocument:(RKDocument *)document
{
    RKResourcePool *resources = [RKResourcePool new];
    
    return [[self RTFStringFromDocument:document withAttachmentPolicy:RKAttachmentPolicyIgnore resources:resources] dataUsingEncoding:NSISOLatin1StringEncoding];
}

+ (NSFileWrapper *)RTFDfromDocument:(RKDocument *)document
{
    RKResourcePool *resources = [RKResourcePool new];
    
    NSFileWrapper *rtfFile = [[NSFileWrapper alloc] initRegularFileWithContents:
        [[self RTFStringFromDocument:document withAttachmentPolicy:RKAttachmentPolicyReference resources:resources] dataUsingEncoding:NSISOLatin1StringEncoding]
    ];

    NSMutableDictionary *packageFiles = [resources imageFileDictionary];    
    
    [packageFiles setObject:rtfFile forKey:@"TXT.rtf"];
        
    return [[NSFileWrapper alloc] initDirectoryWithFileWrappers:packageFiles ];
}

+ (NSString *)RTFStringFromDocument:(RKDocument *)document withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSString *body = [RKBodyWriter RTFBodyFromDocument:document withAttachmentPolicy:attachmentPolicy resources:resources];
    NSString *head = [RKHeaderWriter RTFHeaderFromDocument:document withResources:resources];

    return [NSString stringWithFormat:@"{%@\n%@\n}\n", head, body];
}

@end
