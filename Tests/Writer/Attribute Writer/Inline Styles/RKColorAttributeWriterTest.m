//
//  RKColorAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKColorAttributeWriter.h"
#import "RKColorAttributeWriterTest.h"

@interface RKColorAttributeWriterTest ()

/*!
 @abstract Asserts whether a color style was successfully translated to a defined color and the default color
 */
- (void)assertTranslationOfColorStyle:(NSString *)colorStyleName withColorTag:(NSString *)definedColorTag withDefaultColorTag:(NSString *)defaultColorTag;

/*!
 @abstract Asserts whether a color style can be translated and re-read by the Cocoa text system
 */
- (void)assertColorStyleCocoaIntegration:(NSString *)styleName;

@end

@implementation RKColorAttributeWriterTest

- (void)assertTranslationOfColorStyle:(NSString *)colorStyleName withColorTag:(NSString *)definedColorTag withDefaultColorTag:(NSString *)defaultColorTag
{
    NSColor *color = [NSColor rtfColorWithRed:1 green:0 blue:0];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Tagging defined color
    [RKColorAttributeWriter addTagsForAttribute:colorStyleName value:color effectiveRange:NSMakeRange(1,2) toString:taggedString originalString:nil attachmentPolicy:0 resources:resources];
    
    // Tagging default color
    [RKColorAttributeWriter addTagsForAttribute:colorStyleName value:nil effectiveRange:NSMakeRange(3,1) toString:taggedString originalString:nil attachmentPolicy:0 resources:resources];
    
    STAssertEqualObjects([taggedString flattenedRTFString],
                         ([NSString stringWithFormat:
                            @"a"
                            // Defined color
                            "%@ "
                            "bc"
                            // Default color
                            "%@ "
                            "d",
                          definedColorTag,
                          defaultColorTag
                         ]),
                         @"Invalid color style"
                         );
    
    // Test resource manager
    NSArray *colors = [resources colors];
    STAssertEquals([colors count], (NSUInteger)3, @"Invalid colors count");
    STAssertEqualObjects([colors objectAtIndex:2], [NSColor rtfColorWithRed:1.0 green:0 blue:0], @"Invalid color");
}

- (void)assertColorStyleCocoaIntegration:(NSString *)styleName
{
    NSColor *colorA = [NSColor rtfColorWithRed:1.0 green:0.0 blue:0.0];
    NSColor *colorB = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" abc "];
    
    [attributedString addAttribute:styleName value:colorA range:NSMakeRange(1, 1)];
    [attributedString addAttribute:styleName value:colorB range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:styleName inRange:NSMakeRange(1,3)];
}

- (void)testColorStyles
{
    [self assertTranslationOfColorStyle:NSBackgroundColorAttributeName withColorTag:@"\\cb2" withDefaultColorTag:@"\\cb1"];
    [self assertColorStyleCocoaIntegration:NSBackgroundColorAttributeName];

    [self assertTranslationOfColorStyle:NSForegroundColorAttributeName withColorTag:@"\\cf2" withDefaultColorTag:@"\\cf0"];
    [self assertColorStyleCocoaIntegration:NSForegroundColorAttributeName];

    [self assertTranslationOfColorStyle:NSUnderlineColorAttributeName withColorTag:@"\\ulc2" withDefaultColorTag:@"\\ulc0"];
    [self assertColorStyleCocoaIntegration:NSUnderlineColorAttributeName];

    [self assertTranslationOfColorStyle:NSStrikethroughColorAttributeName withColorTag:@"\\strikec2" withDefaultColorTag:@"\\strikec0"];
    [self assertColorStyleCocoaIntegration:NSStrikethroughColorAttributeName];

    [self assertTranslationOfColorStyle:NSStrokeColorAttributeName withColorTag:@"\\strokec2" withDefaultColorTag:@"\\strokec0"];
    [self assertColorStyleCocoaIntegration:NSStrokeColorAttributeName];
}

@end
