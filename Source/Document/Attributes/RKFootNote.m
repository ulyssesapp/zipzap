//
//  RKFootNote.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootNote.h"

NSString *RKFootNoteAttributeName = @"RKFootNote";

@implementation RKFootNote

@synthesize content;

+ (RKFootNote *)footNoteWithAttributedString:(NSAttributedString *)content
{
    return [[RKFootNote alloc] initWithAttributedString:content];
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
