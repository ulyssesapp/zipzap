//
//  RKBodyWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument.h"
#import "RKResourceManager.h"
#import "RKBodyWriter.h"

@implementation RKBodyWriter

+ (NSString *)RTFBodyFromDocument:(RKDocument *)document usingRTFDAttachments:(BOOL)rtfdAttachments resources:(RKResourceManager **)resources
{
    *resources = [[RKResourceManager alloc] init];
    
    return @"";
}

@end
