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
    NSFont *font = [NSFont fontWithName:@"Helvetica-BoldOblique" size:16];
    NSShadow *shadow = [NSShadow new];
    NSNumber *strikethroughStyle = [NSNumber numberWithUnsignedInteger:NSUnderlineStyleSingle];
    NSNumber *strokeWidth = [NSNumber numberWithUnsignedInteger:12];
    NSNumber *superscriptMode = [NSNumber numberWithUnsignedInteger:1];
    NSNumber *underlineStyle = [NSNumber numberWithUnsignedInt:NSUnderlineStyleDouble];
    NSColor *backgroundColor = [NSColor rtfColorWithRed:1.0 green:0.0 blue:0.0];
    NSColor *foregroundColor = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];    
    NSColor *underlineColor = [NSColor rtfColorWithRed:1.0 green:0.0 blue:1.0];
    NSColor *strikethroughColor = [NSColor rtfColorWithRed:0.0 green:1.0 blue:1.0];    
    NSColor *strokeColor = [NSColor rtfColorWithRed:10.0 green:1.0 blue:1.0];
    
    shadow.shadowBlurRadius = 2.0f;
    shadow.shadowOffset = NSMakeSize(0.0f, 0.0f);
    shadow.shadowColor = [NSColor rtfColorWithRed:0.0 green:1.0 blue:0.0];
        
    return [NSMutableDictionary dictionaryWithObjectsAndKeys: 
             font,                  NSFontAttributeName,
             shadow,                NSShadowAttributeName,
             strikethroughStyle,    NSStrikethroughStyleAttributeName,
             strokeWidth,           NSStrokeWidthAttributeName,
             superscriptMode,       NSSuperscriptAttributeName,
             underlineStyle,        NSUnderlineStyleAttributeName,
             backgroundColor,       NSBackgroundColorAttributeName,
             foregroundColor,       NSForegroundColorAttributeName,
             underlineColor,        NSUnderlineColorAttributeName,
             strikethroughColor,    NSStrikethroughColorAttributeName,
             strokeColor,           NSStrokeColorAttributeName,
             nil 
            ];
}

- (NSMutableDictionary *)generateParagraphStyle
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];    

    paragraphStyle.alignment = NSCenterTextAlignment;
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
    [dictionary setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];

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
                                   attachmentPolicy:0 
                                          resources:resources
     ];
    
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid paragraph stylesheet used");
    
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
                                   attachmentPolicy:0 
                                          resources:resources
     ];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid paragraph stylesheet used");
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
                                   attachmentPolicy:0 
                                          resources:resources
    ];
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                         "\\s2 "
                         "b"
                         "c",
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
                                   attachmentPolicy:0 
                                          resources:resources
    ];

    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                         "\\s1 "
                         "b"
                         "c", 
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
                                   attachmentPolicy:0 
                                          resources:resources
     ];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid character stylesheet used");
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
                                   attachmentPolicy:0 
                                          resources:resources
     ];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid character stylesheet used");
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
                                   attachmentPolicy:0 
                                          resources:resources
     ];
    
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                         "{\\cs1 "
                         "b"
                         "}"
                         "c", 
                         @"Invalid character stylesheet used"
                         );    
}

- (void)testCocoaIntegrationForParagraphStyles
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"a\nb\n" ];
    
    RKDocument *document = [RKDocument documentWithAttributedString: content];
    
    document.paragraphStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];

    [content applyPredefinedParagraphStyleAttribute:@"CStyle" document:document range:NSMakeRange(0,2)];
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(2,2)];

    [self assertReadingOfSingleSectionDocument:document onAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(2,2)];    

    [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSFontAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSUnderlineColorAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrikethroughColorAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeWidthAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeColorAttributeName inRange:NSMakeRange(0,4)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSShadowAttributeName inRange:NSMakeRange(0,4)];
}

- (void)testCocoaIntegrationForCharacterStyles
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"ab" ];
    
    RKDocument *document = [RKDocument documentWithAttributedString: content];
    
    document.characterStyles = [NSDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                nil
                                ];

    [content applyPredefinedCharacterStyleAttribute:@"CStyle" document:document range:NSMakeRange(0,2)];
    
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0,2)];

    [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSFontAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSUnderlineStyleAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSUnderlineColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrikethroughStyleAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrikethroughColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeWidthAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSStrokeColorAttributeName inRange:NSMakeRange(0,2)];
    [self assertReadingOfSingleSectionDocument:document onAttribute:NSShadowAttributeName inRange:NSMakeRange(0,2)];
}

- (void)testStylesheetsAreCompatibleWithReferenceTest
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"cstyle default-cstyle\npstyle\npstyle cstyle pstyle\n" ];
    
    RKDocument *document = [RKDocument documentWithAttributedString: content];
    
    document.characterStyles = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [self generateCharacterStyle], @"CStyle",
                                nil
                                ];
    
    document.paragraphStyles = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                [self generateParagraphStyle], @"PStyle",
                                nil
                                ];    
    
    [[document.characterStyles objectForKey:@"CStyle"] setObject:[NSFont fontWithName:@"Helvetica-BoldOblique" size:100] forKey:NSFontAttributeName];
    
    [content applyPredefinedCharacterStyleAttribute:@"CStyle" document:document range:NSMakeRange(0, 7)];
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(22, 7)];
    
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(29, 21)];    
    [content applyPredefinedCharacterStyleAttribute:@"CStyle" document:document range:NSMakeRange(36, 6)];
    
    [self assertRTF:[document RTF] withTestDocument:@"stylesheet"];
}

@end
