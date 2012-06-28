//
//  NSAttributedString+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSAttributedString+RKPersistence.h"
#import "NSAttributedString+RKPersistenceBackend.h"
#import "RKPersistenceContext.h"

/*!
 @abstract Keys used for persistency
 */
NSString *RKPersistenceStringContentKey = @"string";
NSString *RKPersistenceAttributeRangesKey = @"attributeRanges";
NSString *RKPersistenceContextKey = @"context";

NSString *RKPersistenceAttributeRangeKey = @"attributeRange";
NSString *RKPersistenceAttributeValuesKey = @"attributeValues";

NSString *RKPersistenceRangeLocationKey = @"location";
NSString *RKPersistenceRangeLengthKey = @"length";

@interface NSAttributedString (RKPersistencePrivateMethods)

/*!
 @abstract Creates a new attributed string usign a property and a context.
 */
+ (NSAttributedString *)attributedStringWithPropertyList:(NSDictionary *)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error;

@end

@implementation NSAttributedString (RKPersistence)

NSMutableDictionary *NSAttributedStringPersistableAttributeTypes;

+ (void)load
{
    @autoreleasepool {
        NSAttributedStringPersistableAttributeTypes = [NSMutableDictionary new];
        [NSAttributedStringPersistableAttributeTypes addEntriesFromDictionary:
         @{
            NSFontAttributeName:                NSFont.class,
            NSParagraphStyleAttributeName:      NSParagraphStyle.class,
            NSForegroundColorAttributeName:     NSColor.class,
            NSUnderlineStyleAttributeName:      NSNumber.class,
            NSSuperscriptAttributeName:         NSNumber.class,
            NSBackgroundColorAttributeName:     NSColor.class,
            NSAttachmentAttributeName:          NSTextAttachment.class,
            NSLigatureAttributeName:            NSNumber.class,
            NSBaselineOffsetAttributeName:      NSNumber.class,
            NSKernAttributeName:                NSNumber.class,
            NSLinkAttributeName:                NSURL.class,
            NSStrokeWidthAttributeName:         NSNumber.class,
            NSStrokeColorAttributeName:         NSColor.class,
            NSUnderlineColorAttributeName:      NSColor.class,
            NSStrikethroughStyleAttributeName:  NSNumber.class,
            NSStrikethroughColorAttributeName:  NSColor.class,
            NSShadowAttributeName:              NSShadow.class,
            NSObliquenessAttributeName:         NSNumber.class,
            NSExpansionAttributeName:           NSNumber.class,
            NSWritingDirectionAttributeName:    NSNumber.class,
            NSVerticalGlyphFormAttributeName:   NSNumber.class,
            RKTextListItemAttributeName:        RKListItem.class,
            RKFootnoteAttributeName:            NSAttributedString.class,
            RKEndnoteAttributeName:             NSAttributedString.class,
            RKPlaceholderAttributeName:         NSNumber.class,
            RKCharacterStyleNameAttributeName:  NSString.class,
            RKParagraphStyleNameAttributeName:  NSString.class
         }
        ];
    }
}

+ (NSDictionary *)persistableAttributeTypes
{
    return NSAttributedStringPersistableAttributeTypes;
}

+ (void)registerNumericAttributeForPersistence:(NSString *)attributeName
{
    NSParameterAssert(![NSAttributedStringPersistableAttributeTypes objectForKey: attributeName]);
    
    [NSAttributedStringPersistableAttributeTypes setObject:NSNumber.class forKey:attributeName];
}

+ (void)registerStringAttributeForPersistence:(NSString *)attributeName
{
    NSParameterAssert(![NSAttributedStringPersistableAttributeTypes objectForKey: attributeName]);
    
    [NSAttributedStringPersistableAttributeTypes setObject:NSString.class forKey:attributeName];
}



#pragma mark - Deserialization

- (id)initWithRTFKitPropertyListRepresentation:(id)propertyList error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    // De-serialize context from property list
    RKPersistenceContext *context = [[RKPersistenceContext alloc] initWithPropertyListRepresentation:propertyList[RKPersistenceContextKey] error:error];
    if (!context)
        return nil;
    
    // De-serialize attributed string with context
    NSAttributedString *prototype = (NSAttributedString *)[self.class instanceWithRTFKitPropertyListRepresentation:propertyList usingContext:context error:error];
    if (!prototype)
        return nil;
    
    // Setup concrete attributed string with prototype
    return [self initWithAttributedString: prototype];
}



#pragma mark - Serialization

- (id)RTFKitPropertyListRepresentation
{
    // Serialize attributed string
    RKPersistenceContext *context = [RKPersistenceContext new];
    NSMutableDictionary *propertyListRepresentation = [[self RTFKitPropertyListRepresentationUsingContext: context] mutableCopy];
    
    // Add context
    [propertyListRepresentation setObject:[context propertyListRepresentation] forKey:RKPersistenceContextKey];

    return propertyListRepresentation;
}

@end


/*!
 @abstract Backend methods for serialization
 */
@implementation NSAttributedString (RKPersistenceBackend)

#pragma mark - Deserialization methods

+ (NSAttributedString *)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSDictionary *persistableAttributeTypes = self.persistableAttributeTypes;
    
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    // Get data from property list
    NSString *deserializedString = propertyList[RKPersistenceStringContentKey];
    NSArray *attributesForRanges = propertyList[RKPersistenceAttributeRangesKey];
    
    // Create attributed string
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: deserializedString];
    
    // Setup attributes
    for (NSDictionary *attributesForRange in attributesForRanges)
    {
        NSDictionary *rangeDescriptor = attributesForRange[RKPersistenceAttributeRangeKey];
        NSDictionary *attributes = attributesForRange[RKPersistenceAttributeValuesKey];
        
        NSRange attributeRange = NSMakeRange([rangeDescriptor[RKPersistenceRangeLocationKey] unsignedIntegerValue], [rangeDescriptor[RKPersistenceRangeLengthKey] unsignedIntegerValue]);
        
        [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id<RKPersistence> serializedAttributeValue, BOOL *stop) {
            // Get handler class for attribute
            Class handlerClass = [persistableAttributeTypes objectForKey: attributeName];
            NSParameterAssert([handlerClass conformsToProtocol: @protocol(RKPersistence)]);
            
            // Translate attribute value
            id attributeValue = [handlerClass instanceWithRTFKitPropertyListRepresentation:serializedAttributeValue usingContext:context error:error];
            if (!attributeValue) {
                *stop = YES;
                return;
            }
            
            // Setup attributed string
            [attributedString addAttribute:attributeName value:attributeValue range:attributeRange];
        }];
    }
    
    return attributedString;
}



#pragma mark - Serialization methods

- (NSDictionary *)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    NSDictionary *persistableAttributeTypes = self.class.persistableAttributeTypes;
    NSMutableArray *attributesForRanges = [NSMutableArray new];
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
        // Translate attributes in range
        NSMutableDictionary *translatedAttributes = [NSMutableDictionary new];
        
        [attributes enumerateKeysAndObjectsUsingBlock:^(NSString *attributeKey, id attributeValue, BOOL *stop) {
            // Ignore nil values
            if (!attributeValue)
                return;
            
            // Ignore not supported attributes
            if (![persistableAttributeTypes objectForKey: attributeKey])
                return;
            
            // Only accept valid types
            // There is one special case hardcoded here: NSLinkAttributeName may be NSString or NSURL.
            NSParameterAssert([attributeValue isKindOfClass: [persistableAttributeTypes objectForKey: attributeKey]] || ([attributeKey isEqual: NSLinkAttributeName] && [attributeValue isKindOfClass: NSString.class]));
            
            // Translate the attribute value
            NSParameterAssert ([attributeValue conformsToProtocol: @protocol(RKPersistence)]);
            
            id serializedAttributeValue = [attributeValue RTFKitPropertyListRepresentationUsingContext: context];
            [translatedAttributes setObject:serializedAttributeValue forKey:attributeKey];
        }];
        
        // Create descriptor for attributes in range
        NSDictionary *attributeRange = @{ RKPersistenceRangeLocationKey: @(range.location), RKPersistenceRangeLengthKey: @(range.length) };
        
        // Persist only ranges that actually contain attributes
        if (translatedAttributes.count) {
            NSDictionary *attributesForRange = @{ RKPersistenceAttributeRangeKey: attributeRange, RKPersistenceAttributeValuesKey: translatedAttributes };
            [attributesForRanges addObject: attributesForRange];
        }
    }];
    
    // Create property list
    return @{
        RKPersistenceStringContentKey:      self.string,
        RKPersistenceAttributeRangesKey:    attributesForRanges
    };
}

@end
