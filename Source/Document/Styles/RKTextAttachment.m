//
//  RKTextAttachment.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "RKTextAttachment.h"

@implementation RKTextAttachment

- (id)initWithFileWrapper:(NSFileWrapper *)initialFileWrapper
{
    self = [self init];
    
    if (self) {
        _fileWrapper = initialFileWrapper;
    }
    
    return self;
}

@end

#endif
