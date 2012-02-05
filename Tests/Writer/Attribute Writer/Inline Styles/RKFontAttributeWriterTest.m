//
//  RKFontAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFontAttributeWriter.h"
#import "RKFontAttributeWriterTest.h"

@implementation RKFontAttributeWriterTest

- (void)testTagFontStyle
{
    NSFont *font = [NSFont fontWithName:@"Times-BoldItalic" size:16];
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Tagging defined font
    [RKFontAttributeWriter addTagsForAttribute:font toTaggedString:string inRange:NSMakeRange(1,2) withAttachmentPolicy:0 resources:resources];

    // Tagging default font
    [RKFontAttributeWriter addTagsForAttribute:nil toTaggedString:string inRange:NSMakeRange(3,1) withAttachmentPolicy:0 resources:resources];
    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                         // Defined font
                         "\\f0 "
                         "\\fs32 "
                         "\\b "
                         "\\i "
                         "bc"
                         "\\i0 "
                         "\\b0 "
                         // Default font
                         "\\f1 "
                         "\\fs24 "
                         "d",
                         @"Invalid font style"
                         );
    
    // Test resource manager
    NSArray *fontFamilies = [resources fontFamilyNames];
    STAssertEquals([fontFamilies count], (NSUInteger)2, @"Invalid font family count");
    STAssertEqualObjects([fontFamilies objectAtIndex:0], @"Times-Roman", @"Invalid font family");
    STAssertEqualObjects([fontFamilies objectAtIndex:1], @"Helvetica", @"Invalid font family");  
}

- (void)testFontStyleCocoaIntegration
{
    NSFont *fontA = [NSFont fontWithName:@"Helvetica-BoldOblique" size:18];
    NSFont *fontB = [NSFont fontWithName:@"Menlo-BoldItalic" size:10];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSFontAttributeName value:fontA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:fontB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSFontAttributeName inRange:NSMakeRange(0,3)];
}


@end
