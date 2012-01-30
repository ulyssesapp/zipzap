//
//  RKInlineStyleWriter+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKInlineStyleWriter.h"

@interface RKInlineStyleWriter (TestExtensions)

+ (void)tag:(RKTaggedString *)taggedString withFont:(NSFont *)font inRange:(NSRange)range resources:(RKResourcePool *)resources;

@end
