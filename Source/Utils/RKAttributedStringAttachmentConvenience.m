//
//  RKAttributedStringAttachmentConvenience.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringAttachmentConvenience.h"

@implementation NSAttributedString (RKAttributedStringAttachmentConvenience)

+ (NSAttributedString *)attributedStringWithAttachment:(id)attachment attributeName:(NSString *)attributeName
{
    NSString *attachmentString = [NSString stringWithFormat:@"%C", NSAttachmentCharacter];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: attachment, attributeName, nil];
    
    return [[NSAttributedString alloc] initWithString: attachmentString attributes: attributes];
}

@end
