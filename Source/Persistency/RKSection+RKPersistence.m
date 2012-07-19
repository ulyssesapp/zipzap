//
//  RKSection+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 16.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection+RKPersistence.h"

#import "NSDictionary+FlagSerialization.h"

// Identifiers used by serialization
NSString *RKPersistenceNumberOfColumnsKey       = @"numberOfColumns";
NSString *RKPersistenceIndexOfFirstPage         = @"indexOfFirstPage";
NSString *RKPersistencePageNumberingStyle       = @"pageNumberingStyle";
NSString *RKPersistenceColumnSpacing            = @"columnSpacing";

NSString *RKPersistenceContentKey               = @"content";
NSString *RKPersistenceHeaderKey                = @"header";
NSString *RKPersistenceFooterKey                = @"footer";

NSString *RKPersistencePageMaskAllSuffix        = @"All";
NSString *RKPersistencePageMaskFirstSuffix      = @"First";
NSString *RKPersistencePageMaskLeftSuffix       = @"Left";
NSString *RKPersistencePageMaskRightSuffix      = @"Right";

@interface RKSection (RKPersistencePrivateMethods)

/*!
 @abstract Provides a serializable selector for a page selection mask using a certain prefix (e.g. header or footer)
 */
+ (NSString *)serializableSelectorForMask:(RKPageSelectionMask)mask usingPrefix:(NSString *)prefix;

@end

@implementation RKSection (RKPersistence)

- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error
{
    self = [self init];
    
    if (self) {
        // Deserializes standard properties
        if ([propertyList objectForKey: RKPersistenceNumberOfColumnsKey])
            self.numberOfColumns = [[propertyList objectForKey: RKPersistenceNumberOfColumnsKey] unsignedIntegerValue];

        if ([propertyList objectForKey: RKPersistenceIndexOfFirstPage])
            self.indexOfFirstPage = [[propertyList objectForKey: RKPersistenceIndexOfFirstPage] unsignedIntegerValue];
        
        if ([propertyList objectForKey: RKPersistencePageNumberingStyle])
            self.pageNumberingStyle = [[self.class serializationTableForPageNumberingStyle] unsignedEnumValueFromString:[propertyList objectForKey: RKPersistencePageNumberingStyle] error:error];

        if ([propertyList objectForKey: RKPersistenceColumnSpacing])
            self.columnSpacing = [propertyList[RKPersistenceColumnSpacing] floatValue];
        
        // Deserialize content string
        if ([propertyList objectForKey: RKPersistenceContentKey])
            self.content = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:propertyList[RKPersistenceContentKey] error:error];

        // Deserialize header and footer
        [self setupPageObjectsFromPropertyList:propertyList usingPrefix:RKPersistenceHeaderKey error:error block:^(RKPageSelectionMask selector, NSAttributedString *pageObject) {
            [self setHeader:pageObject forPages:selector];
        }];
        [self setupPageObjectsFromPropertyList:propertyList usingPrefix:RKPersistenceFooterKey error:error block:^(RKPageSelectionMask selector, NSAttributedString *pageObject) {
            [self setFooter:pageObject forPages:selector];
        }];
    }

    return self;
}

- (void)setupPageObjectsFromPropertyList:(NSDictionary *)propertyList usingPrefix:(NSString *)prefix error:(NSError **)error block:(void(^)(RKPageSelectionMask selector, NSAttributedString *pageObject))block
{
    // Do we have the same mask for all pages?
    NSDictionary *allPageSerialized = [propertyList objectForKey: [self.class serializableSelectorForMask:RKPageSelectorAll usingPrefix:prefix]];
    if (allPageSerialized) {
        // Yes: De-serialize the all mask
        NSAttributedString *pageObject = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:allPageSerialized error:error];
        if (pageObject)
            block(RKPageSelectorAll, pageObject);
    
        return;
    }

    // Deserialize further masks
    RKPageSelectionMask masks[3] = {RKPageSelectionFirst, RKPageSelectionLeft, RKPageSelectionRight};
    
    for (NSUInteger maskIndex = 0; maskIndex < 3; maskIndex ++) {
        NSDictionary *serializedPageObject = [propertyList objectForKey: [self.class serializableSelectorForMask:masks[maskIndex] usingPrefix:prefix]];
        if (!serializedPageObject)
            continue;
        
        NSAttributedString *pageObject = [[NSAttributedString alloc] initWithRTFKitPropertyListRepresentation:serializedPageObject error:error];
        if (pageObject)
            block(masks[maskIndex], pageObject);
    }
}

- (id)RTFKitPropertyListRepresentation
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    [propertyList setObject:[NSNumber numberWithUnsignedInteger: self.numberOfColumns] forKey:RKPersistenceNumberOfColumnsKey];
    [propertyList setObject:[NSNumber numberWithUnsignedInteger: self.indexOfFirstPage] forKey:RKPersistenceIndexOfFirstPage];
    [propertyList setObject:[[self.class serializationTableForPageNumberingStyle] stringFromUnsignedEnumValue: self.pageNumberingStyle] forKey:RKPersistencePageNumberingStyle];
    [propertyList setObject:[NSNumber numberWithFloat: self.columnSpacing] forKey:RKPersistenceColumnSpacing];

    // Serialize content
    if (self.content)
        [propertyList setObject:self.content.RTFKitPropertyListRepresentation forKey:RKPersistenceContentKey];
    
    // Serialize headers and footers
    [self enumerateHeadersUsingBlock:^(RKPageSelectionMask pageSelector, NSAttributedString *header) {
        [propertyList setObject:header.RTFKitPropertyListRepresentation forKey:[self.class serializableSelectorForMask:pageSelector usingPrefix:RKPersistenceHeaderKey]];
    }];

    [self enumerateFootersUsingBlock:^(RKPageSelectionMask pageSelector, NSAttributedString *footer) {
        [propertyList setObject:footer.RTFKitPropertyListRepresentation forKey:[self.class serializableSelectorForMask:pageSelector usingPrefix:RKPersistenceFooterKey]];
    }];

    return propertyList;
}


#pragma mark - Identifier for serialization

+ (NSString *)serializableSelectorForMask:(RKPageSelectionMask)mask usingPrefix:(NSString *)prefix
{
    NSString *suffix;
    
    switch (mask) {
        case RKPageSelectorAll:
            suffix = RKPersistencePageMaskAllSuffix;
            break;
            
        case RKPageSelectionFirst:
            suffix = RKPersistencePageMaskFirstSuffix;
            break;
            
        case RKPageSelectionLeft:
            suffix = RKPersistencePageMaskLeftSuffix;
            break;
            
        case RKPageSelectionRight:
            suffix = RKPersistencePageMaskRightSuffix;
            break;
            
        default:
            NSParameterAssert(false);
    }
    
    return [NSString stringWithFormat:@"%@%@", prefix, suffix];
}


+ (NSDictionary *)serializationTableForPageNumberingStyle
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
