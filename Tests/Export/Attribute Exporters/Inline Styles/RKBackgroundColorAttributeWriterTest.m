//
//  RKBackgroundColorAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKBackgroundColorAttributeWriter.h"
#import "RKBackgroundColorAttributeWriterTest.h"

@implementation RKBackgroundColorAttributeWriterTest

- (void)testBackgroundColorStyle
{
    NSColor *color = [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:0.5];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Tagging defined color
    [RKBackgroundColorAttributeWriter addTagsForAttribute:color toTaggedString:string inRange:NSMakeRange(1,2) withAttachmentPolicy:0 resources:resources];
    
    // Tagging default color
    [RKBackgroundColorAttributeWriter addTagsForAttribute:nil toTaggedString:string inRange:NSMakeRange(3,1) withAttachmentPolicy:0 resources:resources];
    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                         // Defined color
                         "\\cb2 "
                         "bc"
                         // Default color
                         "\\cb1 "
                         "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor colorWithSRGBRed:1.0 green:0 blue:0 alpha:1], @"Invalid color");
}

@end
