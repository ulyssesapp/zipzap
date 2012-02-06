//
//  RKCocoaIntegrationTestHelper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface SenTestCase (RKCocoaIntegrationTest)

/*!
 @abstract Reads a test file
 */
- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension;

/*!
 @abstract Reads a test file
 */
- (NSTextAttachment *)textAttachmentWithName:(NSString *)name withExtension:(NSString *)extension;

/*!
 @abstract Converts the given attributed string to RTF and re-reads it using Cocoa
 */
- (NSAttributedString *)convertAndRereadRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes;

/*!
 @abstract Converts the given attributed string to RTFD and re-reads it using Cocoa
 */
- (NSAttributedString *)convertAndRereadRTFD:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes;

/*!
 @abstract Tests whether two attributed strings using the same attributes inside a certain range
 */
- (void)assertEqualOnAttribute:(NSString *)attributeName 
                       inRange:(NSRange)range 
                      original:(NSAttributedString *)originalAttributedString 
                     converted:(NSAttributedString *)convertedAttributedString;

/*!
 @abstract Tests whether the RTF conversion of an attributed string is identically read by Cocoa with respect to a certain attribute.
 */
- (void)assertReadingOfAttributedString:(NSAttributedString *)attributedString onAttribute:(NSString *)attributeName inRange:(NSRange)range;

/*!
 @abstract Tests whether a certain numeric attribute is properly converted and read back by Cocoa
 */
- (void)assertRereadingAttribute:(NSString *)attributeName withNumericValue:(NSNumber *)value;

/*!
 @abstract See assertRereadingAttribute:withNumericValue:
 */
- (void)assertRereadingAttribute:(NSString *)attributeName withUnsignedIntegerValue:(NSUInteger)value;

/*!
 @abstract See assertRereadingAttribute:withNumericValue:
 */
- (void)assertRereadingAttribute:(NSString *)attributeName withIntegerValue:(NSInteger)value;


@end
