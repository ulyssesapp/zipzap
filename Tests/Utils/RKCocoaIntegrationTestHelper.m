//
//  RKCocoaIntegrationTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKCocoaIntegrationTestHelper.h"

@implementation RKCocoaIntegrationTestHelper

- (NSDictionary *)collectAttributesFromAttributedString:(NSAttributedString *)attributedString withName:(NSString *)attributeName
{
    NSMutableDictionary *attributesMap;
    
    [attributedString enumerateAttribute:attributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(id attributeValue, NSRange range, BOOL *stop) {
        NSDictionary *rangeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithUnsignedInteger: range.location], @"location", 
                                         [NSNumber numberWithUnsignedInteger: range.length], @"length", 
                                         nil
                                         ];
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

- (void)assertReadingOfAttributedString:(NSAttributedString *)attributedString onAttribute:(NSString *)attributeName
{
    NSAttributedString *converted = [self convertAndRereadRTF:attributedString documentAttributes:NULL];
    
    // Collect attributes
    NSDictionary *attributesMap = [self collectAttributesFromAttributedString:attributedString withName:attributeName];
    NSDictionary *convertedAttributesMap = [self collectAttributesFromAttributedString:converted withName:attributeName];    

    // Same count?
    STAssertEquals(attributesMap.count, convertedAttributesMap.count, @"Different count of attributes");
    
    // Compare attributes
    [convertedAttributesMap enumerateKeysAndObjectsUsingBlock:^(NSDictionary *key, id convertedAttributeValue, BOOL *stop) {
        id originalAttributeValue = [attributesMap objectForKey: key];
      
        if ([convertedAttributeValue isKindOfClass:[NSColor class]] && [originalAttributeValue isKindOfClass:[NSColor class]]) {
            NSColor *convertedColor = [NSColor rtfColorFromColor: convertedAttributeValue];
            NSColor *originalColor = [NSColor rtfColorFromColor: originalAttributeValue];
            
            STAssertEqualObjects(convertedColor, originalColor, @"Attributes differ");
        }
         else {        
            STAssertEqualObjects(originalAttributeValue, convertedAttributeValue, @"Attributes differ");
        }
    }];
}

@end
