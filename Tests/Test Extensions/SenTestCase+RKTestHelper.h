//
//  SenTestCase+RKTestHelper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKImageAttachment;

@interface SenTestCase (RKTestHelper)

/*!
 @abstract Reads a test file
 */
- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension;

/*!
 @abstract Reads a test file
 */
- (RKImageAttachment *)imageAttachmentWithName:(NSString *)name withExtension:(NSString *)extension margin:(NSEdgeInsets)margin;

@end
