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

/*!
 @abstract Tests whether a certain numeric attribute is properly converted and read back by Cocoa
 */
- (void)assertRereadingAttribute:(NSString *)attributeName withUnsignedIntegerValue:(NSUInteger)value;

@end
