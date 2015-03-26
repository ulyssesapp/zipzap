//
//  RKDOCXWriterTest.h
//  RTFKit
//
//  Created by Lucas Hauswald on 25.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

@interface RKDOCXWriterTest : XCTestCase

- (void)assertDOCX:(NSData *)docx withTestDocument:(NSString *)name;

- (void)assertGeneratedDOCXData:(NSData *)generated withExpectedData:(NSData *)expected filename:(NSString *)filename;

@end
