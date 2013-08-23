//
//  RKReferenceTest.h
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Used for external reference tests 
 @discussion External reference tests should verify whether the generated output is compatible 
 with RTF files in the TestData/ directory. These RTF files are in turn used to manually verify
 the compaitiblity of several features with other RTF readers such as MS Word, Nissus, Mellel, OpenOffice.org
 */ 
@interface SenTestCase (RKReferenceTest)

/*!
 @abstract Loads a document from the test bundle
 */
-(NSString *)loadTestDocument:(NSString *)name;

/*!
 @abstract Creates a variant of a string that is free of newlines and tabs
 */
- (NSString *)normalizeRTFString:(NSString *)rtf;

/*!
 @abstract Compares the content of two RTF files. Newlines and tabs are ignored
 */
- (void)assertGeneratedRTFString:(NSString *)stringA withExpectedString:(NSString *)stringB filename:(NSString *)filename;

/*!
 @abstract Loads a test document from TestData and compares it charwise with the given RTF output. Ignores newlines and tabs.
 */
- (void)assertRTF:(NSData *)rtf withTestDocument:(NSString *)name;

@end
