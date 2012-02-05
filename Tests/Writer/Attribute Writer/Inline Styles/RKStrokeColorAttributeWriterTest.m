//
//  RKStrokeColorAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStrokeColorAttributeWriter.h"
#import "RKStrokeColorAttributeWriterTest.h"

@implementation RKStrokeColorAttributeWriterTest

- (void)testStrokeColor
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKStrokeColorAttributeWriter addTagsForAttribute:nil 
                                       toTaggedString:taggedString 
                                              inRange:NSMakeRange(1,1) 
                                 withAttachmentPolicy:0 
                                            resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid strikethrough style");
    
    // Setting a color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKStrokeColorAttributeWriter addTagsForAttribute:[NSColor rtfColorWithRed:1.0 green:0 blue:0] 
                                       toTaggedString:taggedString 
                                              inRange:NSMakeRange(1,1) 
                                 withAttachmentPolicy:0 
                                            resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\strokec2 b\\strokec0 c", @"Invalid strikethrough style");
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor rtfColorWithRed:1.0 green:0 blue:0], @"Invalid color");
}

- (void)testStrokeColorStyleCocoaIntegration
{
    NSColor *colorA = [NSColor rtfColorWithRed:1.0 green:0.0 blue:0.0];
    NSColor *colorB = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSStrokeColorAttributeName value:colorA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSStrokeColorAttributeName value:colorB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSStrokeColorAttributeName inRange:NSMakeRange(0,3)];
}

@end
