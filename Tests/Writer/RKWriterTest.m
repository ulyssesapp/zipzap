//
//  RKWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriterTest.h"

@implementation RKWriterTest

- (void)testGeneratingEmptyRTFDocument
{
    RKDocument *document = [[RKDocument alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    NSData *converted = [document wordRTF];
    
    [self assertRTF: converted withTestDocument: @"empty"];
}

- (void)testGeneratingSimpleRTFDocument
{
    RKDocument *document = [[RKDocument alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"abcdefä \\ { }"]];
    NSData *converted = [document wordRTF];

    [self assertRTF: converted withTestDocument: @"simple"];
}

@end
