//
//  RKParagraphStyleWriter+TextExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKParagraphStyleWriter (TestExtensions)

+ (NSString *)styleTagFromParagraphStyle:(id)paragraphStyle ofAttributedString:(NSAttributedString *)attributedString range:(NSRange)range resources:(RKResourcePool *)resources;

@end
