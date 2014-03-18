//
//  RKCocoaIntegrationTestHelper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface XCTestCase (RKCocoaIntegrationTest)

/*!
 @abstract Converts the given document to RTF and re-reads it using Cocoa
 */
- (NSAttributedString *)convertAndRereadSingleSectionDocument:(RKDocument *)document;

/*!
 @abstract Converts the given attributed string to RTF and re-reads it using Cocoa
 */
- (NSAttributedString *)convertAndRereadRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes;

/*!
 @abstract Converts the given attributed string to an RTF without text attachments and re-reads it using Cocoa
 */
- (NSAttributedString *)convertAndRereadPlainRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes;

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
 @abstract Tests whether the RTF conversion of a document with a single section is identically read by Cocoa regarding a certain attributed
 */
- (void)assertReadingOfSingleSectionDocument:(RKDocument *)document onAttribute:(NSString *)attributeName inRange:(NSRange)range;

/*!
 @abstract Tests whether the RTF conversion of an attributed string is identically read by Cocoa with regarding a certain attributed
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
