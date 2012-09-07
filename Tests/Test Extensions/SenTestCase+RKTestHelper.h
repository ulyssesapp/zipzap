//
//  SenTestCase+RKTestHelper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface SenTestCase (RKTestHelper)

/*!
 @abstract Reads a test file
 */
- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension;

/*!
 @abstract Reads a test file
 */
- (id)textAttachmentWithName:(NSString *)name withExtension:(NSString *)extension;

@end
