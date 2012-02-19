//
//  RKCocoaIntegrationTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKCocoaIntegrationTest.h"

@interface SenTestCase (RKCocoaIntegrationTestPrivateMethods)

/*!
 @abstract Collects all attributes of an attributed string with a certain name and passes it to a dictionary
 @discussion The dictionary maps from a string "LOCATION-LENGTH" to the attribute value
 */
- (NSDictionary *)collectAttribute:(NSString*)attributeName fromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range;

@end

@implementation SenTestCase (RKCocoaIntegrationTest)

- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:extension subdirectory:@"Test Data/resources"];
    NSFileWrapper *wrapper;
    
    STAssertNotNil(url, @"Cannot build URL");
    
    NSError *error;
    wrapper = [[NSFileWrapper alloc] initWithURL:url options:NSFileWrapperReadingImmediate error:&error];
    STAssertNotNil(wrapper, @"Load failed with error: %@", error);
    
    return wrapper;
}

- (NSTextAttachment *)textAttachmentWithName:(NSString *)name withExtension:(NSString *)extension
{
	return [[NSTextAttachment alloc] initWithFileWrapper: [self testFileWithName:name withExtension:extension]];
}

- (NSAttributedString *)convertAndRereadSingleSectionDocument:(RKDocument *)document
{
    NSData *rtf = [document RTF];
    
    return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:nil];
}

- (NSAttributedString *)convertAndRereadPlainRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [RKDocument documentWithAttributedString:attributedString];
    document.pageSize = NSMakeSize(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);   
    
    NSData *rtf = [document plainRTF];
    
    return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:documentAttributes];
}

- (NSAttributedString *)convertAndRereadRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [RKDocument documentWithAttributedString:attributedString];
    document.pageSize = NSMakeSize(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);
    
    NSData *rtf = [document RTF];
    
   return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:documentAttributes];
}

- (NSAttributedString *)convertAndRereadRTFD:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [RKDocument documentWithAttributedString:attributedString];
    document.pageSize = NSMakeSize(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);
    
    NSFileWrapper *rtf = [document RTFD];
    
    return [[NSAttributedString alloc] initWithRTFDFileWrapper:rtf documentAttributes:documentAttributes];
}

- (void)assertEqualOnAttribute:(NSString *)attributeName 
                       inRange:(NSRange)range 
                      original:(NSAttributedString *)originalAttributedString 
                     converted:(NSAttributedString *)convertedAttributedString
{
    // Collect attributes
    NSDictionary *originalAttributesMap = [self collectAttribute:attributeName fromAttributedString:originalAttributedString inRange:range];
    NSDictionary *convertedAttributesMap = [self collectAttribute:attributeName fromAttributedString:convertedAttributedString inRange:range];    
    
    // Ranges of attributes must be equal
    STAssertEqualObjects([originalAttributesMap allKeys], [convertedAttributesMap allKeys], @"Attribute ranges differ");
    
    // Compare attributes
    [originalAttributesMap enumerateKeysAndObjectsUsingBlock:^(NSDictionary *key, id originalAttributeValue, BOOL *stop) {
        id convertedAttributeValue = [convertedAttributesMap objectForKey: key];
        
        STAssertNotNil(convertedAttributeValue, @"Missing attribute");
        
        if ([convertedAttributeValue isKindOfClass: [NSColor class]] && [originalAttributeValue isKindOfClass: [NSColor class]]) {
            NSColor *convertedColor = [NSColor rtfColorFromColor: convertedAttributeValue];
            NSColor *originalColor = [NSColor rtfColorFromColor: originalAttributeValue];
            
            STAssertEqualObjects(convertedColor, originalColor, @"Attributes differ");
        }
        else if ([convertedAttributeValue isKindOfClass: [NSShadow class]] && [originalAttributeValue isKindOfClass: [NSShadow class]]) {
            NSShadow *convertedShadow = convertedAttributeValue;
            NSShadow *originalShadow = originalAttributeValue;
            
            // The text system adds an alpha value to shadows
            convertedShadow.shadowColor = [NSColor rtfColorFromColor:convertedShadow.shadowColor];
            
            STAssertEqualObjects(originalShadow, convertedShadow, @"Attributes differ");
        }
        else if ([convertedAttributeValue isKindOfClass: [NSParagraphStyle class]] && [originalAttributeValue isKindOfClass: [NSParagraphStyle class]]) {
            NSParagraphStyle *convertedStyle = convertedAttributeValue;
            NSParagraphStyle *originalStyle = originalAttributeValue;
            
            STAssertEqualObjects([convertedStyle description], [originalStyle description], @"Attributes differ");
        }
        else if (originalAttributeValue != nil) {        
            STAssertEqualObjects(originalAttributeValue, convertedAttributeValue, @"Attributes differ");
        }
    }];
}

- (void)assertReadingOfSingleSectionDocument:(RKDocument *)document onAttribute:(NSString *)attributeName inRange:(NSRange)range
{
    NSAttributedString *converted = [self convertAndRereadSingleSectionDocument:document];
    
    [self assertEqualOnAttribute:attributeName inRange:range original:[[document.sections objectAtIndex:0] content] converted:converted];
}

- (void)assertReadingOfAttributedString:(NSAttributedString *)attributedString onAttribute:(NSString *)attributeName inRange:(NSRange)range
{
    NSAttributedString *converted = [self convertAndRereadRTF:attributedString documentAttributes:NULL ];
    
    [self assertEqualOnAttribute:attributeName inRange:range original:attributedString converted:converted];
}

- (void)assertRereadingAttribute:(NSString *)attributeName withNumericValue:(NSNumber *)value
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"abc"];
    
    [attributedString addAttribute:attributeName value:value range:NSMakeRange(0,1)];
    
    [self assertReadingOfAttributedString:attributedString onAttribute:attributeName inRange:NSMakeRange(0,1)];
}

- (void)assertRereadingAttribute:(NSString *)attributeName withUnsignedIntegerValue:(NSUInteger)value
{
    [self assertRereadingAttribute:attributeName withNumericValue:[NSNumber numberWithUnsignedInteger:value]];
}

- (void)assertRereadingAttribute:(NSString *)attributeName withIntegerValue:(NSInteger)value
{
    [self assertRereadingAttribute:attributeName withNumericValue:[NSNumber numberWithInteger:value]];
}

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

@end
