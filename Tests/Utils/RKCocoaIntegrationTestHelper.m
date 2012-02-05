//
//  RKCocoaIntegrationTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKCocoaIntegrationTestHelper.h"

@implementation RKCocoaIntegrationTestHelper

- (NSDictionary *)collectAttribute:(NSString*)attributeName fromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range
{
    NSMutableDictionary *attributesMap = [NSMutableDictionary new];
    
    [attributedString enumerateAttribute:attributeName inRange:range options:0 usingBlock:^(id attributeValue, NSRange range, BOOL *stop) {
        NSDictionary *rangeDictionary = [NSString stringWithFormat:@"%u-%u", range.location, range.length];

        if (attributeValue)        
            [attributesMap setObject:attributeValue forKey:rangeDictionary];
    }];
    
    return attributesMap;
}

- (NSAttributedString *)convertAndRereadRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [RKDocument documentWithAttributedString:attributedString];
    NSData *rtf = [document RTF];
    
   return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:documentAttributes];
}

- (void)assertReadingOfAttributedString:(NSAttributedString *)attributedString onAttribute:(NSString *)attributeName inRange:(NSRange)range
{
    NSAttributedString *converted = [self convertAndRereadRTF:attributedString documentAttributes:NULL];
    
    // Collect attributes
    NSDictionary *attributesMap = [self collectAttribute:attributeName fromAttributedString:attributedString inRange:range];
    NSDictionary *convertedAttributesMap = [self collectAttribute:attributeName fromAttributedString:converted inRange:range];    

    // Compare attributes
    [convertedAttributesMap enumerateKeysAndObjectsUsingBlock:^(NSDictionary *key, id convertedAttributeValue, BOOL *stop) {
        id originalAttributeValue = [attributesMap objectForKey: key];
      
        STAssertNotNil(originalAttributeValue, @"Missing attribute");
        
        if ([convertedAttributeValue isKindOfClass:[NSColor class]] && [originalAttributeValue isKindOfClass:[NSColor class]]) {
            NSColor *convertedColor = [NSColor rtfColorFromColor: convertedAttributeValue];
            NSColor *originalColor = [NSColor rtfColorFromColor: originalAttributeValue];
            
            STAssertEqualObjects(convertedColor, originalColor, @"Attributes differ");
        }
        else if ([convertedAttributeValue isKindOfClass:[NSShadow class]] && [originalAttributeValue isKindOfClass:[NSShadow class]]) {
            NSShadow *convertedShadow = convertedAttributeValue;
            NSShadow *originalShadow = originalAttributeValue;
            
            // The text system adds an alpha value to shadows
            convertedShadow.shadowColor = [NSColor rtfColorFromColor:convertedShadow.shadowColor];
            
            STAssertEqualObjects(originalShadow, convertedShadow, @"Attributes differ");
        }
         else if (originalAttributeValue != nil) {        
            STAssertEqualObjects(originalAttributeValue, convertedAttributeValue, @"Attributes differ");
        }
    }];
}

@end
