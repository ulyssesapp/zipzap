//
//  RKStrikethroughStyleAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStrikethroughStyleAttributeWriter.h"
#import "RKStrikethroughStyleAttributeWriterTest.h"

@implementation RKStrikethroughStyleAttributeWriterTest

- (void)testStrikethroughStyle
{
    RKTaggedString *taggedString;
    
    // Default style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKStrikethroughStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: 0] 
                                              toTaggedString:taggedString 
                                                     inRange:NSMakeRange(1,1) 
                                        withAttachmentPolicy:0 
                                                   resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid strikethrough style");
    
    // Single style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKStrikethroughStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: NSUnderlineStyleSingle] 
                                              toTaggedString:taggedString 
                                                     inRange:NSMakeRange(1,1) 
                                        withAttachmentPolicy:0 
                                                   resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\strike\\strikestyle1 b\\strike0 c", @"Invalid strikethrough style");
    
    // Double style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKStrikethroughStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: NSUnderlineStyleDouble] 
                                              toTaggedString:taggedString 
                                                     inRange:NSMakeRange(1,1) 
                                        withAttachmentPolicy:0 
                                                   resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\striked1\\strikestyle9 b\\striked0 c", @"Invalid strikethrough style");
}

- (void)testStrikethroughStyleCocoaIntegration
{
    [self assertRereadingAttribute:NSStrikethroughStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleSingle];
    [self assertRereadingAttribute:NSStrikethroughStyleAttributeName withUnsignedIntegerValue:NSUnderlineStyleDouble];
}

@end
