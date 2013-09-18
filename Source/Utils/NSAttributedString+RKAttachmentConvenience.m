//
//  NSAttributedString+RKAttachmentConvenience.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+RKAttachmentConvenience.h"

@implementation NSAttributedString (RKAttachmentConvenience)

+ (NSAttributedString *)attributedStringWithAttachment:(id)attachment attributeName:(NSString *)attributeName
{
    NSString *attachmentString = [NSString stringWithCharacters:(unichar[]){RKAttachmentCharacter} length:1];
    NSDictionary *attributes = @{attributeName: attachment};
    
    return [[NSAttributedString alloc] initWithString: attachmentString attributes: attributes];
}

@end