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
    [RKFontAttributeWriter addTagsForAttribute:NSFontAttributeName value:font effectiveRange:NSMakeRange(1,2) toString:string originalString:nil attachmentPolicy:0 resources:resources];

    // Tagging default font
    [RKFontAttributeWriter addTagsForAttribute:NSFontAttributeName value:nil effectiveRange:NSMakeRange(3,1) toString:string originalString:nil attachmentPolicy:0 resources:resources];
    
    STAssertEqualObjects([string flattenedRTFString],
                         @"a"
                         // Defined font
                         "\\f0 "
                         "\\fs32\\fsmilli16000 "
                         "\\b "
                         "\\i "
                         "bc"
                         "\\b0 "
                         "\\i0 "
                         // Default font
                         "\\f1 "
                         "\\fs24\\fsmilli12000 "
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
    NSFont *fontB = [NSFont fontWithName:@"Menlo-BoldItalic" size:10.12];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:NSFontAttributeName value:fontA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:fontB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:NSFontAttributeName inRange:NSMakeRange(0,3)];
}


@end
