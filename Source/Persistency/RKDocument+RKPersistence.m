//
//  RKDocument+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKDocument+RKPersistence.h"

#import "RKPersistenceContext.h"
#import "RKSection+RKPersistence.h"

#import "NSAttributedString+RKPersistence.h"
#import "NSDictionary+FlagSerialization.h"

// Identifiers for serialization
NSString *RKPersistencySectionsKey                      = @"sections";
NSString *RKPersistencyMetadataKey                      = @"metadata";
NSString *RKPersistencyHyphenationEnabledKey            = @"hyphenationEnabled";
NSString *RKPersistencyDocumentLocaleKey				= @"localeKey";
NSString *RKPersistencyPageWidthKey                     = @"pageWidth";
NSString *RKPersistencyPageHeightKey                    = @"pageHeight";
NSString *RKPersistencyHeaderSpacingKey                 = @"headerSpacing";
NSString *RKPersistencyFooterSpacingKey                 = @"footerSpacing";
NSString *RKPersistencyPageInsetsTopKey                 = @"pageInsetsTop";
NSString *RKPersistencyPageInsetsBottomKey              = @"pageInsetsBottom";
NSString *RKPersistencyPageInsetsLeftKey                = @"pageInsetsLeft";
NSString *RKPersistencyPageInsetsRightKey               = @"pageInsetsRight";
NSString *RKPersistencyPageOrientationKey               = @"pageOrientation";
NSString *RKPersistencyFootnotePlacementKey             = @"footnotePlacement";
NSString *RKPersistencyEndnotePlacementKey              = @"endnotePlacement";
NSString *RKPersistencyFootnoteEnumerationStyleKey      = @"footnoteEnumerationStyle";
NSString *RKPersistencyEndnoteEnumerationStyleKey       = @"endnoteEnumerationStyle";
NSString *RKPersistencyFootnoteEnumerationPolicyKey     = @"footnoteEnumerationPolicy";
NSString *RKPersistencyEndnoteEnumerationPolicyKey      = @"endnoteEnumerationPolicy";
NSString *RKPersistencyParagraphStylesKey               = @"paragraphStyles";
NSString *RKPersistencyCharacterStylesKey               = @"characterStyles";
NSString *RKPersistencySectionNumberingStyleKey         = @"sectionNumberingStyle";

@interface RKDocument (RKPersistencePrivateMethods)

/*!
 @abstract Deserializes a style from a property list using a certain key
 */
+ (NSDictionary *)deserializeStylesFromPropertyList:(NSDictionary *)propertyList usingKey:(NSString *)key error:(NSError **)error;

@end

@implementation RKDocument (RKPersistence)

- (id)initWithRTFKitPropertyListRepresentation:(NSDictionary *)propertyList error:(NSError **)error
{
    self = [self init];
    
    if (self) {
        if ([propertyList objectForKey: RKPersistencyHyphenationEnabledKey])
            self.hyphenationEnabled = [[propertyList objectForKey: RKPersistencyHyphenationEnabledKey] boolValue];
        
		if ([propertyList objectForKey: RKPersistencyDocumentLocaleKey])
			self.locale = [[NSLocale alloc] initWithLocaleIdentifier: [propertyList objectForKey: RKPersistencyDocumentLocaleKey]];
		
        if ([propertyList objectForKey: RKPersistencyPageWidthKey])
            self.pageSize = CGSizeMake([[propertyList objectForKey: RKPersistencyPageWidthKey] floatValue], [[propertyList objectForKey: RKPersistencyPageHeightKey] floatValue]);
        
        if ([propertyList objectForKey: RKPersistencyHeaderSpacingKey])
            self.headerSpacing = [[propertyList objectForKey: RKPersistencyHeaderSpacingKey] floatValue];
        
        if ([propertyList objectForKey: RKPersistencyFooterSpacingKey])
            self.footerSpacing = [[propertyList objectForKey: RKPersistencyFooterSpacingKey] floatValue];

        if ([propertyList objectForKey: RKPersistencyPageInsetsTopKey])
            self.pageInsets = RKPageInsetsMake([[propertyList objectForKey: RKPersistencyPageInsetsTopKey] floatValue],
                                             [[propertyList objectForKey: RKPersistencyPageInsetsLeftKey] floatValue],
                                             [[propertyList objectForKey: RKPersistencyPageInsetsRightKey] floatValue],
                                             [[propertyList objectForKey: RKPersistencyPageInsetsBottomKey] floatValue]
                                            );
        
        if ([propertyList objectForKey: RKPersistencyPageOrientationKey])
            self.pageOrientation = [[self.class serializationTableForPageOrientation] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyPageOrientationKey] error:NULL];
        
        if ([propertyList objectForKey: RKPersistencyFootnotePlacementKey])
            self.footnotePlacement = [[self.class serializationTableForFootnotePlacement] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyFootnotePlacementKey] error:NULL];

        if ([propertyList objectForKey: RKPersistencyEndnotePlacementKey])
            self.endnotePlacement = [[self.class serializationTableForEndnotePlacement] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyEndnotePlacementKey] error:NULL];
        
        if ([propertyList objectForKey: RKPersistencyFootnoteEnumerationStyleKey])
            self.footnoteEnumerationStyle = [[self.class serializationTableForFootnoteEnumerationStyle] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyFootnoteEnumerationStyleKey] error:NULL];

        if ([propertyList objectForKey: RKPersistencyEndnoteEnumerationStyleKey])
            self.endnoteEnumerationStyle = [[self.class serializationTableForFootnoteEnumerationStyle] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyEndnoteEnumerationStyleKey] error:NULL];

        if ([propertyList objectForKey: RKPersistencyFootnoteEnumerationPolicyKey])
            self.footnoteEnumerationPolicy = [[self.class serializationTableForFootnoteEnumerationPolicy] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyFootnoteEnumerationPolicyKey] error:NULL];

        if ([propertyList objectForKey: RKPersistencyEndnoteEnumerationPolicyKey])
            self.endnoteEnumerationPolicy = [[self.class serializationTableForFootnoteEnumerationPolicy] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencyEndnoteEnumerationPolicyKey] error:NULL];

        if ([propertyList objectForKey: RKPersistencySectionNumberingStyleKey])
            self.sectionNumberingStyle = [[self.class serializationTableForFootnoteEnumerationPolicy] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencySectionNumberingStyleKey] error:NULL];
        
        // De-serialize meta data, if any
        if ([[propertyList objectForKey: RKPersistencyMetadataKey] isKindOfClass: NSDictionary.class])
            self.metadata = [propertyList objectForKey: RKPersistencyMetadataKey];
        
        // Deserialize paragraph styles
        NSError *localError;
        self.paragraphStyles = [self.class deserializeStylesFromPropertyList:propertyList usingKey:RKPersistencyParagraphStylesKey error:&localError];
        if (localError) {
            if (error) *error = localError;
            return nil;
        }

        // Deserialize character styles
        self.characterStyles = [self.class deserializeStylesFromPropertyList:propertyList usingKey:RKPersistencyCharacterStylesKey error:&localError];
        if (localError) {
            if (error) *error = localError;
            return nil;
        }
        
        // Deserialize sections, if any
        NSArray *serializedSections = [propertyList objectForKey: RKPersistencySectionsKey];
        NSMutableArray *sections = [NSMutableArray new];
        
        for (id serializedSection in serializedSections) {
            RKSection *section = [[RKSection alloc] initWithRTFKitPropertyListRepresentation:serializedSection error:error];
            if (!section)
                return nil;
            
            [sections addObject: section];
        }
        
        self.sections = sections;
    }
    
    return self;
}

- (id)RTFKitPropertyListRepresentation
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    propertyList[RKPersistencyHyphenationEnabledKey] = [NSNumber numberWithBool: self.hyphenationEnabled];
	propertyList[RKPersistencyDocumentLocaleKey] = self.locale.localeIdentifier;
    propertyList[RKPersistencyPageWidthKey] = [NSNumber numberWithFloat: self.pageSize.width];
    propertyList[RKPersistencyPageHeightKey] = [NSNumber numberWithFloat: self.pageSize.height];
    propertyList[RKPersistencyHeaderSpacingKey] = [NSNumber numberWithFloat: self.headerSpacing];
    propertyList[RKPersistencyFooterSpacingKey] = [NSNumber numberWithFloat: self.footerSpacing];
    propertyList[RKPersistencyPageInsetsTopKey] = [NSNumber numberWithFloat: self.pageInsets.top];
    propertyList[RKPersistencyPageInsetsBottomKey] = [NSNumber numberWithFloat: self.pageInsets.bottom];
    propertyList[RKPersistencyPageInsetsLeftKey] = [NSNumber numberWithFloat: self.pageInsets.left];
    propertyList[RKPersistencyPageInsetsRightKey] = [NSNumber numberWithFloat: self.pageInsets.right];
    propertyList[RKPersistencyPageOrientationKey] = [[self.class serializationTableForPageOrientation] stringFromUnsignedEnumValue: self.pageOrientation];
    propertyList[RKPersistencyFootnotePlacementKey] = [[self.class serializationTableForFootnotePlacement] stringFromUnsignedEnumValue: self.footnotePlacement];
    propertyList[RKPersistencyEndnotePlacementKey] = [[self.class serializationTableForEndnotePlacement] stringFromUnsignedEnumValue: self.endnotePlacement];
    propertyList[RKPersistencyFootnoteEnumerationStyleKey] = [[self.class serializationTableForFootnoteEnumerationStyle] stringFromUnsignedEnumValue: self.footnoteEnumerationStyle];
    propertyList[RKPersistencyEndnoteEnumerationStyleKey] = [[self.class serializationTableForFootnoteEnumerationStyle] stringFromUnsignedEnumValue: self.endnoteEnumerationStyle];
    propertyList[RKPersistencyFootnoteEnumerationPolicyKey] =[[self.class serializationTableForFootnoteEnumerationPolicy] stringFromUnsignedEnumValue: self.footnoteEnumerationPolicy];
    propertyList[RKPersistencyEndnoteEnumerationPolicyKey] =  [[self.class serializationTableForFootnoteEnumerationPolicy] stringFromUnsignedEnumValue: self.endnoteEnumerationPolicy];
    propertyList[RKPersistencySectionNumberingStyleKey] = [[self.class serializationTableForSectionNumberingStyle] stringFromSignedEnumValue: self.sectionNumberingStyle];

    // Serialize metadata, if any
    if (self.metadata)
        propertyList[RKPersistencyMetadataKey] = self.metadata;
        
    // Serialize styles
    propertyList[RKPersistencyParagraphStylesKey] = [self.class serializeStylesFromDictionary:self.paragraphStyles];
    propertyList[RKPersistencyCharacterStylesKey] = [self.class serializeStylesFromDictionary:self.characterStyles];

    // Serialize sections
    NSMutableArray *serializedSections = [NSMutableArray new];
    
    for (RKSection *section in self.sections) {
        [serializedSections addObject: section.RTFKitPropertyListRepresentation];
    }
    
    propertyList[RKPersistencySectionsKey] = serializedSections;

    return propertyList;
}


#pragma mark - Serialization of styles

+ (NSDictionary *)deserializeStylesFromPropertyList:(NSDictionary *)propertyList usingKey:(NSString *)key error:(NSError **)error
{
    NSMutableDictionary *styles = [NSMutableDictionary new];
    RKPersistenceContext *dummyContext = [RKPersistenceContext new];
    
    [[propertyList objectForKey: key] enumerateKeysAndObjectsUsingBlock:^(NSString *styleName, NSDictionary *attributes, BOOL *stop) {
        NSDictionary *deserializedAttributes = [NSAttributedString attributeDictionaryFromRTFKitPropertyListRepresentation:attributes usingContext:dummyContext error:error];
        if (!deserializedAttributes) {
            *stop = YES;
            return;
        }
        
        [styles setObject:deserializedAttributes forKey:styleName];
    }];
    
    return styles;
}

+ (NSDictionary *)serializeStylesFromDictionary:(NSDictionary *)styles
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    RKPersistenceContext *dummyContext = [RKPersistenceContext new];
    
    [styles enumerateKeysAndObjectsUsingBlock:^(NSString *styleName, NSDictionary *attributes, BOOL *stop) {
        NSDictionary *serializedAttributes = [NSAttributedString RTFKitPropertyListRepresentationForAttributeDictionary:attributes usingContext:dummyContext];
        if (!serializedAttributes) {
            *stop = YES;
            return;
        }
        
        [propertyList setObject:serializedAttributes forKey:styleName];
    }];
    
    return propertyList;
}

#pragma mark - Flags for serialization

+ (NSDictionary *)serializationTableForFootnotePlacement
{
    static NSDictionary * serializationTable;
    serializationTable = serializationTable ?:
        [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithUnsignedInteger: RKFootnotePlacementSamePage],        @"samePage",
                    [NSNumber numberWithUnsignedInteger: RKFootnotePlacementSectionEnd],      @"sectionEnd",
                    [NSNumber numberWithUnsignedInteger: RKFootnotePlacementDocumentEnd],     @"documentEnd",
                    nil
        ];
    
    return serializationTable;
}

+ (NSDictionary *)serializationTableForEndnotePlacement
{
    static NSDictionary * serializationTable;
    serializationTable = serializationTable ?:
        [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithUnsignedInteger: RKEndnotePlacementDocumentEnd],     @"documentEnd",
                    [NSNumber numberWithUnsignedInteger: RKEndnotePlacementSectionEnd],      @"sectionEnd",
                    nil
         ];
    
    return serializationTable;
}

+ (NSDictionary *)serializationTableForPageOrientation
{
    static NSDictionary * serializationTable;
    serializationTable = serializationTable ?:
    [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithUnsignedInteger: RKPageOrientationPortrait],     @"portrait",
         [NSNumber numberWithUnsignedInteger: RKPageOrientationLandscape],    @"landscape",
         nil
     ];
    
    return serializationTable;
}

+ (NSDictionary *)serializationTableForFootnoteEnumerationStyle
{
    static NSDictionary * serializationTable;
    serializationTable = serializationTable ?:
    [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationDecimal],                @"decimal",
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationAlphabeticLowerCase],    @"alphabeticLowerCase",
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationAlphabeticUpperCase],    @"alphabeticUpperCase",
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationRomanLowerCase],         @"romanLowerCase",
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationRomanUpperCase],         @"romanUpperCase",
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationChicagoManual],          @"chicagoManual",
         nil
     ];
    
    return serializationTable;
}

+ (NSDictionary *)serializationTableForFootnoteEnumerationPolicy
{
    static NSDictionary * serializationTable;
    serializationTable = serializationTable ?:
    [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationPerPage],            @"perPage",
         [NSNumber numberWithUnsignedInteger: RKFootnoteEnumerationPerSection],         @"perSection",
         [NSNumber numberWithUnsignedInteger: RKFootnoteContinuousEnumeration],         @"continuous",
         nil
     ];
    
    return serializationTable;
}

+ (NSDictionary *)serializationTableForSectionNumberingStyle
{
    static NSDictionary * serializationTable;
    serializationTable = serializationTable ?:
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithUnsignedInteger: RKPageNumberingDecimal],              @"decimal",
     [NSNumber numberWithUnsignedInteger: RKPageNumberingRomanLowerCase],       @"romanLowerCase",
     [NSNumber numberWithUnsignedInteger: RKPageNumberingRomanUpperCase],       @"romanUpperCase",
     [NSNumber numberWithUnsignedInteger: RKPageNumberingAlphabeticLowerCase],  @"alphabeticLowerCase",
     [NSNumber numberWithUnsignedInteger: RKPageNumberingAlphabeticUpperCase],  @"alphabeticUpperCase",
     nil
     ];
    
    return serializationTable;
}

@end
