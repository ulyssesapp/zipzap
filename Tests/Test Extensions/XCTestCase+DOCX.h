//
//  XCTestCase+DOCX.h
//  RTFKit
//
//  Created by Lucas Hauswald on 30.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

/*!
 @abstract Used for external reference tests
 @discussion External reference tests should verify whether the generated output is compatible
 with DOCX files in the TestData/ directory. These DOCX files are in turn used to manually verify
 the compaitiblity of several features with other DOCX readers such as MS Word and Pages.
 */
@interface XCTestCase (RKDOCXTest)

/*!
 @abstract Compares the content of two DOCX files.
 */
- (void)assertGeneratedDOCXData:(NSData *)generated withExpectedData:(NSData *)expected filename:(NSString *)filename;

/*!
 @abstract Loads a test document from TestData and compares it filewise with the given DOCX output.
 */
- (void)assertDOCX:(NSData *)docx withTestDocument:(NSString *)name;

@end