//
//  RKBodyWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"
#import "RKResourcePool.h"
#import "RKSectionWriter.h"
#import "RKBodyWriter.h"

@implementation RKBodyWriter

+ (NSString *)RTFBodyFromDocument:(RKDocument *)document withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSMutableString *body = [NSMutableString new];
    
    [document.sections enumerateObjectsUsingBlock:^(id section, NSUInteger index, BOOL *stop) {
        [body appendString: [RKSectionWriter RTFFromSection:section withAttachmentPolicy:attachmentPolicy resources:resources]];
        
        // Place a section separator only if we have more than one section
        if (index < document.sections.count - 1) {
            [body appendString: @"\n\\sect\\sectd"];
        }
    }];
    
    return body;
}

@end
