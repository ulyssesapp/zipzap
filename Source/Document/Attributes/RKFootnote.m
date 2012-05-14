//
//  RKFootnote.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootnote.h"
#import "NSAttributedString+RKAttachmentConvenience.h"

NSString *RKFootnoteAttributeName = @"RKFootnote";
NSString *RKEndnoteAttributeName = @"RKEndnote";

@implementation NSAttributedString (RKAttributedStringFootnoteConvenience)

+ (NSAttributedString *)attributedStringWithFootnote:(NSAttributedString *)footnote
{
    return [NSAttributedString attributedStringWithAttachment:footnote attributeName:RKFootnoteAttributeName];
}

+ (NSAttributedString *)attributedStringWithEndnote:(NSAttributedString *)endnote
{
    return [NSAttributedString attributedStringWithAttachment:endnote attributeName:RKEndnoteAttributeName];    
}

@end
