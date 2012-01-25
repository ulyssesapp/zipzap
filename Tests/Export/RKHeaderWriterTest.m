//
//  RKHeaderWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriterTest.h"
#import "RKBodyWriter.h"
#import "RKResourceManager.h"

@interface RKHeaderWriter ()
+ (NSString *)fontTableFromResourceManager:(RKResourceManager *)resources;
+ (NSString *)colorTableFromResourceManager:(RKResourceManager *)resources;
+ (NSString *)documentInfoFromDocument:(RKDocument *)document;
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;
@end

@implementation RKHeaderWriterTest

- (void)testGeneratingFontTable
{
    RKResourceManager *resources = [[RKResourceManager alloc] init];
    
    // Register some fonts
    [resources indexOfFont:[NSFont fontWithName:@"Times-Roman" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Helvetica-Oblique" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Menlo-Bold" size:8]];
    [resources indexOfFont:[NSFont fontWithName:@"Monaco" size:8]];    
    
    // Generate the header
    STAssertEqualObjects([RKHeaderWriter fontTableFromResourceManager:resources], 
                         @"{\\fonttbl"
                          "\\f0\\fnil\\fcharset0 Times;"
                          "\\f1\\fnil\\fcharset0 Helvetica;"
                          "\\f2\\fnil\\fcharset0 Menlo;"
                          "\\f3\\fnil\\fcharset0 Monaco;"
                          "}",
                         @"Invalid font table generated"
                         );
}

@end
