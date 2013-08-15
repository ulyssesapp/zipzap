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
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)@"Verdana-BoldItalic", 16, NULL);
    RKTaggedString *string = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Tagging defined font
    [RKFontAttributeWriter addTagsForAttribute:RKFontAttributeName value:(__bridge id)font effectiveRange:NSMakeRange(1,2) toString:string originalString:nil conversionPolicy:0 resources:resources];

    // Tagging default font
    [RKFontAttributeWriter addTagsForAttribute:RKFontAttributeName value:nil effectiveRange:NSMakeRange(3,1) toString:string originalString:nil conversionPolicy:0 resources:resources];
    
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
    STAssertEqualObjects([fontFamilies objectAtIndex:0], @"Verdana", @"Invalid font family");
    STAssertEqualObjects([fontFamilies objectAtIndex:1], @"Helvetica", @"Invalid font family");  
}

#if !TARGET_OS_IPHONE
- (void)testFontStyleCocoaIntegration
{
    CTFontRef fontA = CTFontCreateWithName((__bridge CFStringRef)@"Helvetica-BoldOblique", 18, NULL);
    CTFontRef fontB = CTFontCreateWithName((__bridge CFStringRef)@"GillSans-BoldItalic", 18, NULL);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:RKFontAttributeName value:(__bridge_transfer id)fontA range:NSMakeRange(0, 1)];
    [attributedString addAttribute:RKFontAttributeName value:(__bridge_transfer id)fontB range:NSMakeRange(1, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:RKFontAttributeName inRange:NSMakeRange(0,3)];
}
#endif

@end
