//
//  RKCocoaIntegrationTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface XCTestCase (RKCocoaIntegrationTestPrivateMethods)

/*!
 @abstract Collects all attributes of an attributed string with a certain name and passes it to a dictionary
 @discussion The dictionary maps from a string "LOCATION-LENGTH" to the attribute value
 */
- (NSDictionary *)collectAttribute:(NSString*)attributeName fromAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range;

@end

@implementation XCTestCase (RKCocoaIntegrationTest)

- (NSAttributedString *)convertAndRereadSingleSectionDocument:(RKDocument *)document
{
    NSData *rtf = [document wordRTF];

    return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:nil];
}

- (NSAttributedString *)convertAndRereadPlainRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [[RKDocument alloc] initWithAttributedString:attributedString];
    document.pageSize = NSMakeSize(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);   
    
    NSData *rtf = [document systemRTF];
    
    return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:documentAttributes];
}

- (NSAttributedString *)convertAndRereadRTF:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [[RKDocument alloc] initWithAttributedString:attributedString];
    document.pageSize = NSMakeSize(1100, 1100);
    document.pageInsets = RKPageInsetsMake(50, 50, 50, 50);
    
    NSData *rtf = [document wordRTF];

    return [[NSAttributedString alloc] initWithRTF:rtf documentAttributes:documentAttributes];
}

- (NSAttributedString *)convertAndRereadRTFD:(NSAttributedString *)attributedString documentAttributes:(NSDictionary **)documentAttributes
{
    RKDocument *document = [[RKDocument alloc] initWithAttributedString:attributedString];
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
    XCTAssertEqualObjects([originalAttributesMap allKeys], [convertedAttributesMap allKeys], @"Attribute ranges differ");
    
    // Compare attributes
    [originalAttributesMap enumerateKeysAndObjectsUsingBlock:^(NSDictionary *key, id originalAttributeValue, BOOL *stop) {
        id convertedAttributeValue = [convertedAttributesMap objectForKey: key];
        
        XCTAssertNotNil(convertedAttributeValue, @"Missing attribute");
        
        if ([convertedAttributeValue isKindOfClass: [NSColor class]] && [originalAttributeValue isKindOfClass: [NSColor class]]) {
            NSColor *convertedColor = [NSColor rtfColorFromColor: convertedAttributeValue];
            NSColor *originalColor = [NSColor rtfColorFromColor: originalAttributeValue];
            
            XCTAssertEqualObjects(convertedColor, originalColor, @"Attributes differ");
        }
        else if ([convertedAttributeValue isKindOfClass: [NSShadow class]] && [originalAttributeValue isKindOfClass: [NSShadow class]]) {
            NSShadow *convertedShadow = convertedAttributeValue;
            NSShadow *originalShadow = originalAttributeValue;
            
            // The text system adds an alpha value to shadows
            convertedShadow.shadowColor = [NSColor rtfColorFromColor:convertedShadow.shadowColor];
            
            XCTAssertEqualObjects(originalShadow, convertedShadow, @"Attributes differ");
        }
        else if ([convertedAttributeValue isKindOfClass: [NSParagraphStyle class]] && [originalAttributeValue isKindOfClass: [NSParagraphStyle class]]) {
            NSMutableParagraphStyle *convertedStyle = [convertedAttributeValue mutableCopy];
            NSMutableParagraphStyle *originalStyle = [originalAttributeValue mutableCopy];
			
			if (!convertedStyle.textBlocks)
				convertedStyle.textBlocks = @[];
			if (!originalStyle.textBlocks)
				originalStyle.textBlocks = @[];
			if (!convertedStyle.textLists)
				convertedStyle.textLists = @[];
			if (!originalStyle.textLists)
				originalStyle.textLists = @[];
			
            XCTAssertEqualObjects([convertedStyle description], [originalStyle description], @"Attributes differ");
        }
        else if (originalAttributeValue != nil) {        
            XCTAssertEqualObjects(originalAttributeValue, convertedAttributeValue, @"Attributes differ");
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
        NSString *rangeDictionaryKey = [NSString stringWithFormat:@"%lu-%lu", range.location, range.length];
        
        if (attributeValue)        
            [attributesMap setObject:attributeValue forKey:rangeDictionaryKey];
    }];
    
    return attributesMap;
}

@end
