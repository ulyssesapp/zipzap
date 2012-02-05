//
//  RKUnderlineColorAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKUnderlineColorAttributeWriter.h"
#import "RKUnderlineColorAttributeWriterTest.h"

@implementation RKUnderlineColorAttributeWriterTest

- (void)testUnderlineColor
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];
    
    // Default color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineColorAttributeWriter addTagsForAttribute:nil 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid underline style");
    
    // Setting a color
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineColorAttributeWriter addTagsForAttribute:[NSColor rtfColorWithRed:1.0 green:0 blue:0] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulc2 b\\ulc0 c", @"Invalid underline style");
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor rtfColorWithRed:1.0 green:0 blue:0], @"Invalid color");
}

- (void)testUnderlineColorStyleCocoaIntegration
{
    NSColor *colorA = [NSColor rtfColorWithRed:1.0 green:0.0 blue:0.0];
    NSColor *colorB = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSUnderlineColorAttributeName value:colorA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSUnderlineColorAttributeName value:colorB range:NSMakeRange(1, 1)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSUnderlineColorAttributeName];
}

@end
