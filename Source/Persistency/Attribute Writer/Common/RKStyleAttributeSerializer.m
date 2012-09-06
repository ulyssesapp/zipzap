//
//  RKStyleAttributeSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKStyleAttributeSerializer.h"

#import "NSDictionary+FlagSerialization.h"

@implementation RKStyleAttributeSerializer

NSDictionary *RKStyleAttributeSerializerUnderlineStyles;
NSDictionary *RKStyleAttributeSerializerSuperscriptStyles;
NSDictionary *RKStyleAttributeSerializerLigatureStyles;
NSDictionary *RKStyleAttributeSerializerPlaceholderStyles;

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKUnderlineStyleAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKStrikethroughStyleAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKLigatureAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKPlaceholderAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKSuperscriptAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKStrokeWidthAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKBaselineOffsetAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKKernAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKBaselineOffsetAttributeName];        
        
        // Setup serialization descriptions for styles
        RKStyleAttributeSerializerUnderlineStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlineStyleNone],            @"none",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlineStyleSingle],          @"single",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlineStyleThick],           @"thick",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlineStyleDouble],          @"double",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlinePatternDot],           @"dot",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlinePatternDash],          @"dash",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlinePatternDashDot],       @"dashDot",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlinePatternDashDotDot],    @"dashDotDot",
                                                     [NSNumber numberWithUnsignedInteger: RKUnderlineByWordMask],           @"underlineByWord",
                                                    nil];
        
        RKStyleAttributeSerializerSuperscriptStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInteger: 0],          @"none",
                                                       [NSNumber numberWithInteger: 1],          @"superscript",
                                                       [NSNumber numberWithInteger: -1],         @"subscript",
                                                      nil];
        
        RKStyleAttributeSerializerLigatureStyles= [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithInteger: 0],          @"none",
                                                   [NSNumber numberWithInteger: 1],          @"standard",
                                                   [NSNumber numberWithInteger: 2],          @"all",
                                                  nil];
        
        RKStyleAttributeSerializerPlaceholderStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInteger: RKPlaceholderPageNumber],    @"pageNumber",
                                                       [NSNumber numberWithInteger: RKPlaceholderSectionNumber], @"sectionNumber",
                                                      nil];
    }
}

+ (NSNumber *)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if ([attributeName isEqual: RKUnderlineStyleAttributeName])
        return [NSNumber numberWithUnsignedInteger: [RKStyleAttributeSerializerUnderlineStyles flagsFromArray:propertyList error:error]];

    if ([attributeName isEqual: RKStrikethroughStyleAttributeName])
        return [NSNumber numberWithUnsignedInteger: [RKStyleAttributeSerializerUnderlineStyles flagsFromArray:propertyList error:error]];

    if ([attributeName isEqual: RKSuperscriptAttributeName])
        return [NSNumber numberWithInteger: [RKStyleAttributeSerializerSuperscriptStyles signedEnumValueFromString:propertyList error:error]];
    
    if ([attributeName isEqual: RKLigatureAttributeName])
        return [NSNumber numberWithInteger: [RKStyleAttributeSerializerLigatureStyles signedEnumValueFromString:propertyList error:error]];

    if ([attributeName isEqual: RKPlaceholderAttributeName])
        return [NSNumber numberWithInteger: [RKStyleAttributeSerializerPlaceholderStyles signedEnumValueFromString:propertyList error:error]];
    
    if ([attributeName isEqual: RKStrokeWidthAttributeName] || [attributeName isEqual: RKBaselineOffsetAttributeName] || [attributeName isEqual: RKKernAttributeName] || [attributeName isEqual: RKStrokeWidthAttributeName])
        return propertyList;
    
    NSAssert(false, @"Invalid attribute deserialized");
    return nil;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(NSNumber *)attributeValue context:(RKPersistenceContext *)context
{
    if ([attributeName isEqual: RKUnderlineStyleAttributeName])
        return [RKStyleAttributeSerializerUnderlineStyles arrayFromFlags:attributeValue.unsignedIntegerValue];

    if ([attributeName isEqual: RKStrikethroughStyleAttributeName])
        return [RKStyleAttributeSerializerUnderlineStyles arrayFromFlags:attributeValue.unsignedIntegerValue];
    
    if ([attributeName isEqual: RKSuperscriptAttributeName])
        return [RKStyleAttributeSerializerSuperscriptStyles stringFromSignedEnumValue:attributeValue.integerValue];
    
    if ([attributeName isEqual: RKLigatureAttributeName])
        return [RKStyleAttributeSerializerLigatureStyles stringFromSignedEnumValue:attributeValue.integerValue];
    
    if ([attributeName isEqual: RKPlaceholderAttributeName])
        return [RKStyleAttributeSerializerPlaceholderStyles stringFromSignedEnumValue:attributeValue.integerValue];
    
    if ([attributeName isEqual: RKBaselineOffsetAttributeName] || [attributeName isEqual: RKKernAttributeName] || [attributeName isEqual: RKStrokeWidthAttributeName])
        return attributeValue;
    
    NSAssert(false, @"Invalid attribute deserialized");
    return nil;
}

@end
