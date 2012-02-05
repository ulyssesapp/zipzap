//
//  RKSuperscriptAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSuperscriptAttributeWriter.h"
#import "RKSuperscriptAttributeWriterTest.h"

@implementation RKSuperscriptAttributeWriterTest

- (void)testSuperscriptMode
{
    RKTaggedString *taggedString;
    
    // Default mode
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKSuperscriptAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: 0] 
                                             toTaggedString:taggedString 
                                                    inRange:NSMakeRange(1,1) 
                                       withAttachmentPolicy:0
                                                  resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid stroke width");
    
    // Setting superscript
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKSuperscriptAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: 1] 
                                       toTaggedString:taggedString
                                              inRange:NSMakeRange(1,1) 
                                 withAttachmentPolicy:0 
                                                  resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\sup b\\sup0 c", @"Invalid superscript mode");
    
    // Setting subscript
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKSuperscriptAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: -1] 
                                       toTaggedString:taggedString 
                                              inRange:NSMakeRange(1,1)  
                                 withAttachmentPolicy:0  
                                            resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\sub b\\sub0 c", @"Invalid subscript mode");
}

- (void)testStrikethroughStyleCocoaIntegration
{
    [self assertRereadingAttribute:NSStrokeWidthAttributeName withIntegerValue:0];
    [self assertRereadingAttribute:NSStrokeWidthAttributeName withIntegerValue:1];
    [self assertRereadingAttribute:NSStrokeWidthAttributeName withIntegerValue:-1];
}

@end
