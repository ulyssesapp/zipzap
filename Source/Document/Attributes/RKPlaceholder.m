//
//  RKPlaceholder.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPlaceholder.h"
#import "RKAttributedStringAttachmentConvenience.h"

NSString *RKPlaceholderAttributeName = @"RKPlaceholder";

@implementation NSAttributedString (RKAttributedStringPlaceholderConvenience)

+ (NSAttributedString *)attributedStringWithPlaceholder:(RKPlaceholderType)placeholder
{
    return [NSAttributedString attributedStringWithAttachment:[NSNumber numberWithInt: placeholder] attributeName:RKPlaceholderAttributeName];
}

@end
