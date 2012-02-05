//
//  RKShadowAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKShadowAttributeWriter.h"
#import "RKShadowAttributeWriterTest.h"

@implementation RKShadowAttributeWriterTest

- (void)testShadow
{
    RKTaggedString *taggedString;
    RKResourcePool *resources = [RKResourcePool new];    
    NSShadow *shadow = [NSShadow new];
    
    [shadow setShadowColor:[NSColor rtfColorWithRed:1.0 green:0 blue:0]];
    [shadow setShadowOffset:NSMakeSize(2.0, 3.0)];
    [shadow setShadowBlurRadius:4.0];
    
    // Default shadow
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKShadowAttributeWriter addTagsForAttribute:nil 
                               toTaggedString:taggedString 
                                      inRange:NSMakeRange(1,1) 
                         withAttachmentPolicy:0
                                    resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid stroke width");
    
    // Setting a shadow
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKShadowAttributeWriter addTagsForAttribute:shadow 
                               toTaggedString:taggedString 
                                      inRange:NSMakeRange(1,1) 
                         withAttachmentPolicy:0     
                                    resources:resources];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\shad\\shadx40\\shady60\\shadr80\\shadc2 b\\shad0 c", @"Invalid shadow");
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor rtfColorWithRed:1.0 green:0 blue:0], @"Invalid color");
}

- (void)testShadowStyleCocoaIntegration
{
    NSShadow *shadowA = [NSShadow new];
    
    [shadowA setShadowColor:[NSColor rtfColorWithRed:1.0 green:0 blue:0]];
    [shadowA setShadowOffset:NSMakeSize(2.0, 3.0)];
    [shadowA setShadowBlurRadius:4.0];

    NSShadow *shadowB = [NSShadow new];
    
    [shadowB setShadowColor:[NSColor rtfColorWithRed:1.0 green:0 blue:0]];
    [shadowB setShadowOffset:NSMakeSize(2.0, 3.0)];
    [shadowB setShadowBlurRadius:4.0];    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSShadowAttributeName value:shadowA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSShadowAttributeName value:shadowB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSShadowAttributeName inRange:NSMakeRange(0,3)];
}

@end
