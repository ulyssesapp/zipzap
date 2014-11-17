//
//  RKPredefinedStyleAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStyleNameAttributeWriter.h"
#import "RKStyleNameAttributeWriterTest.h"

@interface RKStyleNameAttributeWriterTest (PrivateMethods)

- (NSMutableDictionary *)generateCharacterStyle;
- (NSMutableDictionary *)generateParagraphStyle;

- (RKResourcePool *)generateResourcePoolWithParagraphStyles;
- (RKResourcePool *)generateResourcePoolWithCharacterStyles;

@end

@implementation RKStyleNameAttributeWriterTest

- (NSMutableDictionary *)generateCharacterStyle
{
    id font = [self.class targetSpecificFontWithName:@"Helvetica-BoldOblique" size:16];
    NSNumber *strikethroughStyle = [NSNumber numberWithUnsignedInteger:RKUnderlineStyleSingle];
    NSNumber *strokeWidth = [NSNumber numberWithUnsignedInteger:12];
    NSNumber *superscriptMode = [NSNumber numberWithUnsignedInteger:1];
    NSNumber *underlineStyle = [NSNumber numberWithUnsignedInt:RKUnderlineStyleDouble];
    id backgroundColor = [self.class targetSpecificColorWithRed:1.0 green:0.0 blue:0.0];
    id foregroundColor = [self.class targetSpecificColorWithRed:0.0 green:1.0 blue:0.0];    
    id underlineColor = [self.class targetSpecificColorWithRed:1.0 green:0.0 blue:1.0];
    id strikethroughColor = [self.class targetSpecificColorWithRed:0.0 green:1.0 blue:1.0];    
    id strokeColor = [self.class targetSpecificColorWithRed:10.0 green:1.0 blue:1.0];

    #if !TARGET_OS_IPHONE
        NSShadow *shadow = [NSShadow new];
        shadow.shadowColor = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];
    #else
        RKShadow *shadow = [RKShadow new];
        shadow.shadowColor = [self.class cgRGBColorWithRed:0.0 green:1.0 blue:0.0];
    #endif
    shadow.shadowBlurRadius = 2.0f;
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys: 
             font,                  RKFontAttributeName,
             strikethroughStyle,    RKStrikethroughStyleAttributeName,
             strokeWidth,           RKStrokeWidthAttributeName,
             superscriptMode,       RKSuperscriptAttributeName,
             underlineStyle,        RKUnderlineStyleAttributeName,
             backgroundColor,       RKBackgroundColorAttributeName,
             foregroundColor,       RKForegroundColorAttributeName,
             underlineColor,        RKUnderlineColorAttributeName,
             strikethroughColor,    RKStrikethroughColorAttributeName,
             strokeColor,           RKStrokeColorAttributeName,
             shadow,                RKShadowAttributeName,
             nil 
            ];
}

- (NSMutableDictionary *)generateParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];

    paragraphStyle.alignment = RKTextAlignmentCenter;
    paragraphStyle.firstLineHeadIndent = .0f;
    paragraphStyle.headIndent = .0f;
    paragraphStyle.tailIndent = .0f;
    
    paragraphStyle.lineHeightMultiple = .0f;
    paragraphStyle.lineSpacing = .0f;
    paragraphStyle.maximumLineHeight = .0f;
    paragraphStyle.minimumLineHeight = .0f;
    
    paragraphStyle.paragraphSpacingBefore = .0f;
    paragraphStyle.paragraphSpacing = .0f;
    
    paragraphStyle.tabStops = [NSArray new];
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    NSMutableDictionary *dictionary = [self generateCharacterStyle];
    [dictionary setObject:paragraphStyle forKey:RKParagraphStyleAttributeName];

    return dictionary;
}

- (RKResourcePool *)generateResourcePoolWithParagraphStyles
{
    RKDocument *document = [RKDocument new];
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument:document];    
    
    document.paragraphStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];
    
    return resources;
}

- (RKResourcePool *)generateResourcePoolWithCharacterStyles
{
    RKDocument *document = [RKDocument new];
    RKResourcePool *resources = [[RKResourcePool alloc] initWithDocument:document];    
    
    document.characterStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];
    
    return resources;
}

- (void)testDefaultParagraphStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithParagraphStyles];
    
    [RKStyleNameAttributeWriter addTagsForAttribute:RKParagraphStyleNameAttributeName 
                                              value:nil 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
     ];
    
    XCTAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid paragraph stylesheet used");
    
}

- (void)testUndefinedParagraphStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithParagraphStyles];

    [RKStyleNameAttributeWriter addTagsForAttribute:RKParagraphStyleNameAttributeName 
                                              value:@"Undefined Style" 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
     ];
    XCTAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid paragraph stylesheet used");
}

- (void)testDefinedParagraphStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithParagraphStyles];

    [RKStyleNameAttributeWriter addTagsForAttribute:RKParagraphStyleNameAttributeName 
                                              value:@"PStyle" 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
    ];
    XCTAssertEqualObjects([taggedString flattenedRTFString], 
                         ([NSString stringWithFormat:
                         @"a"
                         "\\s%lu "
                         "b"
                         "c",
                          (unsigned long)[resources indexOfParagraphStyle:@"PStyle"]
                         ]),
                         @"Invalid paragraph stylesheet used"
                        );
}

- (void)testDefinedParagraphStyleWithoutParagraphAttribute
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithParagraphStyles];
    
    [RKStyleNameAttributeWriter addTagsForAttribute:RKParagraphStyleNameAttributeName 
                                              value:@"CStyle" 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
    ];

    XCTAssertEqualObjects([taggedString flattenedRTFString], 
                         ([NSString stringWithFormat: @"a"
                         "\\s%lu "
                         "b"
                         "c",
                          (unsigned long)[resources indexOfParagraphStyle: @"CStyle"]
                         ]), 
                         @"Invalid paragraph stylesheet used"
                         );    
}

- (void)testDefaultCharacterStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithCharacterStyles];
    
    [RKStyleNameAttributeWriter addTagsForAttribute:RKCharacterStyleNameAttributeName 
                                              value:nil 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
     ];
    XCTAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid character stylesheet used");
}

- (void)testUndefinedCharacterStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithCharacterStyles];
    
    [RKStyleNameAttributeWriter addTagsForAttribute:RKCharacterStyleNameAttributeName 
                                              value:@"Undefined style" 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
     ];
    XCTAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid character stylesheet used");
}    
    
- (void)testDefinedCharacterStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithCharacterStyles];
    
    [RKStyleNameAttributeWriter addTagsForAttribute:RKCharacterStyleNameAttributeName 
                                              value:@"CStyle" 
                                     effectiveRange:NSMakeRange(1,1) 
                                           toString:taggedString 
                                     originalString:nil 
                                   conversionPolicy:0 
                                          resources:resources
     ];
    
    XCTAssertEqualObjects([taggedString flattenedRTFString], 
                         ([NSString stringWithFormat:
                         @"a"
                         "{\\cs%lu "
                         "b"
                         "}"
                         "c", 
                          (unsigned long)[resources indexOfCharacterStyle: @"CStyle"]
                         ]),
                         @"Invalid character stylesheet used"
                         );    
}

#if !TARGET_OS_IPHONE

- (void)testCocoaIntegrationForParagraphStyles
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"aa\nbb\n" ];
    
    RKDocument *document = [[RKDocument alloc] initWithAttributedString: content];
    
    document.paragraphStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];

    [content applyPredefinedParagraphStyleAttribute:@"CStyle" document:document range:NSMakeRange(0,3)];
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(3,3)];

    [self assertReadingOfSingleSectionDocument:document onAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(3,3)];    

    for (NSUInteger position = 0; position < 6; position ++) {
        // Re-read only the styles at the positions containing characters. The newline characters might have different style settings
        if ((position == 2) || (position == 5))
            continue;
        
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSFontAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSUnderlineColorAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrikethroughColorAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeWidthAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeColorAttributeName inRange:NSMakeRange(position, 1)];
        [self assertReadingOfSingleSectionDocument:document onAttribute:NSShadowAttributeName inRange:NSMakeRange(position, 1)];
    }
}

- (void)testCocoaIntegrationForCharacterStyles
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"ab" ];
    
    RKDocument *document = [[RKDocument alloc] initWithAttributedString: content];
    
    document.characterStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                nil
                                ];

    [content applyPredefinedCharacterStyleAttribute:@"CStyle" document:document range:NSMakeRange(0,2)];
    
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0,2)];

    [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:RKFontAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:RKUnderlineStyleAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:RKUnderlineColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:RKStrikethroughStyleAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:RKStrikethroughColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeWidthAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSShadowAttributeName inRange:NSMakeRange(0,2)];
}

#endif

- (void)testStylesheetsAreCompatibleWithReferenceTest
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"cstyle default-cstyle\npstyle\npstyle cstyle pstyle\n" ];
    
    RKDocument *document = [[RKDocument alloc] initWithAttributedString: content];
    
    document.characterStyles = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                nil
                                ];
    
    document.paragraphStyles = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];    
    
    [[document.characterStyles objectForKey:@"CStyle"] setObject:[self.class targetSpecificFontWithName:@"Helvetica-BoldOblique" size:100] forKey:RKFontAttributeName];
    
    [content applyPredefinedCharacterStyleAttribute:@"CStyle" document:document range:NSMakeRange(0, 7)];
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(22, 7)];
    
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(29, 21)];    
    [content applyPredefinedCharacterStyleAttribute:@"CStyle" document:document range:NSMakeRange(36, 6)];
    
    [self assertRTF:[document wordRTF] withTestDocument:@"stylesheet"];
}

@end
