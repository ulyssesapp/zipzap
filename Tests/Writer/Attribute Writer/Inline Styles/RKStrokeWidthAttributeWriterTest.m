//
//  RKStrokeWidthAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStrokeWidthAttributeWriter.h"
#import "RKStrokeWidthAttributeWriterTest.h"

@implementation RKStrokeWidthAttributeWriterTest

- (void)testStrokeWidth
{
    RKTaggedString *taggedString;
    
    // Default width
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKStrokeWidthAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: 0] 
                                       toTaggedString:taggedString 
                                              inRange:NSMakeRange(1,1) 
                                 withAttachmentPolicy:0
                                            resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid stroke width");
    
    // Setting a width
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKStrokeWidthAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: 30] 
                                       toTaggedString:taggedString 
                                              inRange:NSMakeRange(1,1) 
                                 withAttachmentPolicy:0
                                            resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\outl\\strokewidth30 b\\outl0\\strokewidth0 c", @"Invalid stroke width");
}


@end
