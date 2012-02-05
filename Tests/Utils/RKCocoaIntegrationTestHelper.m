//
//  RKCocoaIntegrationTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKCocoaIntegrationTestHelper.h"

@implementation RKCocoaIntegrationTestHelper

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
    STAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

@end
