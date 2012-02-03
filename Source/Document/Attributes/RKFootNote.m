//
//  RKFootnote.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnote.h"

NSString *RKFootnoteAttributeName = @"RKFootnote";

@implementation RKFootnote

@synthesize content;

+ (RKFootnote *)footnoteWithAttributedString:(NSAttributedString *)content
{
    return [[RKFootnote alloc] initWithAttributedString:content];
}

- (id)initWithAttributedString:(NSAttributedString *)initialContent
{
    self = [self init];
    
    if (self) {
        content = initialContent;
    }
    
    return self;
}

@end
