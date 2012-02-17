//
//  RKPredefinedStyleAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPredefinedStyleAttributeWriter.h"
#import "RKPredefinedStyleAttributeWriterTest.h"

@implementation RKPredefinedStyleAttributeWriterTest

- (NSDictionary *)generateCharacterStyle
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
    NSColor *strokeColor = [NSColor rtfColorWithRed:0.1 green:0.2 blue:1.0];
    
    shadow.shadowBlurRadius = 2.0f;
    shadow.shadowColor = [NSColor rtfColorWithRed:0.0 green:0.1 blue:0.0];
        
    return [NSDictionary dictionaryWithObjectsAndKeys: 
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

- (NSDictionary *)generateParagraphStyle
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
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary: [self generateCharacterStyle]];
    
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
    
    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedParagraphStyleAttributeName 
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

    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedParagraphStyleAttributeName 
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

    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedParagraphStyleAttributeName 
                                                    value:@"PStyle" 
                                           effectiveRange:NSMakeRange(1,1) 
                                                 toString:taggedString 
                                           originalString:nil 
                                         attachmentPolicy:0 
                                                resources:resources
    ];
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                         "{\\s2 "
                         "b"
                         "}"
                         "c",
                         @"Invalid paragraph stylesheet used"
                        );
}

- (void)testDefinedParagraphStyleWithoutParagraphAttribute
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithParagraphStyles];
    
    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedParagraphStyleAttributeName 
                                                    value:@"CStyle" 
                                           effectiveRange:NSMakeRange(1,1) 
                                                 toString:taggedString 
                                           originalString:nil 
                                         attachmentPolicy:0 
                                                resources:resources
    ];

    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                         "{\\s1 "
                         "b"
                         "}"
                         "c", 
                         @"Invalid paragraph stylesheet used"
                         );    
}

- (void)testDefaultCharacterStyle
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    RKResourcePool *resources = [self generateResourcePoolWithCharacterStyles];
    
    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedCharacterStyleAttributeName 
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
    
    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedCharacterStyleAttributeName 
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
    
    [RKPredefinedStyleAttributeWriter addTagsForAttribute:RKPredefinedCharacterStyleAttributeName 
                                                    value:@"CStyle" 
                                           effectiveRange:NSMakeRange(1,1) 
                                                 toString:taggedString 
                                           originalString:nil 
                                         attachmentPolicy:0 
                                                resources:resources
     ];
    
    STAssertEqualObjects([taggedString flattenedRTFString], 
                         @"a"
                         "{\\*\\cs1 "
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

    // Set two different styles on different paragraphs
    [content applyPredefinedParagraphStyleAttribute:@"CStyle" document:document range:NSMakeRange(0,2)];
    [content applyPredefinedParagraphStyleAttribute:@"PStyle" document:document range:NSMakeRange(2,2)];

    [self assertReadingOfSingleSectionDocument:document onAttribute:NSBackgroundColorAttributeName inRange:NSMakeRange(0,2)];
}

@end
