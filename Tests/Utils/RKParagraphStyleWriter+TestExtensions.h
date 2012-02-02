//
//  RKParagraphStyleWriter+TextExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKParagraphStyleWriter (TestExtensions)

+ (NSString *)openingTagFromParagraphStyle:(NSParagraphStyle *)paragraphStyle;

+ (NSString *)openingTagsForTextLists:(NSArray *)textLists
                   ofAttributedString:(NSAttributedString *)attributedString 
                              inRange:(NSRange)range 
                            resources:(RKResourcePool *)resources;

@end
