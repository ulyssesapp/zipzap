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

#if !TARGET_OS_IPHONE
/*!
 @abstract Asserts whether a color style can be translated and re-read by the Cocoa text system
 */
- (void)assertColorStyleCocoaIntegration:(NSString *)styleName;
#endif

@end

@implementation RKColorAttributeWriterTest

- (void)assertTranslationOfColorStyle:(NSString *)colorStyleName withColorTag:(NSString *)definedColorTag withDefaultColorTag:(NSString *)defaultColorTag
{
    id color = [self.class targetSpecificColorWithRed:1.0f green:.0f blue:.0f];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abcd"];
    RKResourcePool *resources = [RKResourcePool new];
    
    // Tagging defined color
    [RKColorAttributeWriter addTagsForAttribute:colorStyleName value:color effectiveRange:NSMakeRange(1,2) toString:taggedString originalString:nil conversionPolicy:0 resources:resources];
    
    // Tagging default color
    [RKColorAttributeWriter addTagsForAttribute:colorStyleName value:nil effectiveRange:NSMakeRange(3,1) toString:taggedString originalString:nil conversionPolicy:0 resources:resources];
    
    XCTAssertEqualObjects([taggedString flattenedRTFString],
                         ([NSString stringWithFormat:
                            @"a"
                            // Defined color
                            "%@ "
                            "bc"
                            // Default color
                            "%@"
                            "d",
                          definedColorTag,
                          defaultColorTag
                         ]),
                         @"Invalid color style"
                         );
    
    // Test resource manager
    NSArray *colors = [resources colors];
    XCTAssertEqual([colors count], (NSUInteger)3, @"Invalid colors count");
}

- (void)testColorStyles
{
    [self assertTranslationOfColorStyle:RKBackgroundColorAttributeName withColorTag:@"\\cb2" withDefaultColorTag:@"\\cb1 "];
    [self assertTranslationOfColorStyle:RKForegroundColorAttributeName withColorTag:@"\\cf2" withDefaultColorTag:@"\\cf0 "];
    [self assertTranslationOfColorStyle:RKUnderlineColorAttributeName withColorTag:@"\\ulc2" withDefaultColorTag:@"\\ulc0 "];
    [self assertTranslationOfColorStyle:RKStrikethroughColorAttributeName withColorTag:@"\\strikec2" withDefaultColorTag:@"\\strikec0 "];
    [self assertTranslationOfColorStyle:RKStrokeColorAttributeName withColorTag:@"\\strokec2" withDefaultColorTag:@"\\strokec0 "];
}

#if !TARGET_OS_IPHONE
- (void)assertColorStyleCocoaIntegration:(NSString *)styleName
{
    id colorA = [self.class targetSpecificColorWithRed:1.0 green:0.0 blue:0.0];
    id colorB = [self.class targetSpecificColorWithRed:0.0 green:1.0 blue:0.0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@" abc "];
    
    [attributedString addAttribute:styleName value:colorA range:NSMakeRange(1, 1)];
    [attributedString addAttribute:styleName value:colorB range:NSMakeRange(2, 2)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:styleName inRange:NSMakeRange(1,3)];
}

- (void)testColorStylesCocoaIntegration
{
    [self assertColorStyleCocoaIntegration:NSBackgroundColorAttributeName];
    [self assertColorStyleCocoaIntegration:NSForegroundColorAttributeName];
    [self assertColorStyleCocoaIntegration:RKUnderlineColorAttributeName];
    [self assertColorStyleCocoaIntegration:RKStrikethroughColorAttributeName];
    [self assertColorStyleCocoaIntegration:NSStrokeColorAttributeName];
  
}
#endif

@end
