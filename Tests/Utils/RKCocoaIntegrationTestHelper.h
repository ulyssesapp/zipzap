//
//  RKCocoaIntegrationTestHelper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface RKCocoaIntegrationTestHelper : SenTestCase

- (NSAttributedString *)convertAndRereadRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes;

/*!
 @abstract Tests whether the RTF conversion of an attributed string is identically read by Cocoa with respect to a certain attribute.
 */
- (void)assertReadingOfAttributedString:(NSAttributedString *)attributedString onAttribute:(NSString *)attributeName inRange:(NSRange)range;

@end
