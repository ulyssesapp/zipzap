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

#import "NSDictionary+FlagSerialization.h"

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
NSMutableDictionary *NSAttributedStringPersistableFlags;
NSMutableDictionary *NSAttributedStringPersistableEnums;

+ (void)load
{
    @autoreleasepool {
        NSAttributedStringPersistableAttributeTypes = [NSMutableDictionary new];
        NSAttributedStringPersistableFlags = [NSMutableDictionary new];
        NSAttributedStringPersistableEnums = [NSMutableDictionary new];
        
        NSAttributedStringPersistableAttributeTypes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            NSFont.class,                       NSFontAttributeName,
            NSParagraphStyle.class,             NSParagraphStyleAttributeName,
            NSColor.class,                      NSForegroundColorAttributeName,
            NSNumber.class,                     NSUnderlineStyleAttributeName,
            NSNumber.class,                     NSSuperscriptAttributeName,
            NSColor.class,                      NSBackgroundColorAttributeName,     
            NSTextAttachment.class,             NSAttachmentAttributeName,          
            NSNumber.class,                     NSLigatureAttributeName,            
            NSNumber.class,                     NSBaselineOffsetAttributeName,      
            NSNumber.class,                     NSKernAttributeName,                
            NSURL.class,                        NSLinkAttributeName,                
            NSNumber.class,                     NSStrokeWidthAttributeName,         
            NSColor.class,                      NSStrokeColorAttributeName,         
            NSColor.class,                      NSUnderlineColorAttributeName,      
            NSNumber.class,                     NSStrikethroughStyleAttributeName,  
            NSColor.class,                      NSStrikethroughColorAttributeName,  
            NSShadow.class,                     NSShadowAttributeName,              
            NSNumber.class,                     NSObliquenessAttributeName,         
            NSNumber.class,                     NSExpansionAttributeName,           
            NSNumber.class,                     NSWritingDirectionAttributeName,    
            NSNumber.class,                     NSVerticalGlyphFormAttributeName,   
            RKListItem.class,                   RKTextListItemAttributeName,        
            NSAttributedString.class,           RKFootnoteAttributeName,            
            NSAttributedString.class,           RKEndnoteAttributeName,             
            NSNumber.class,                     RKPlaceholderAttributeName,         
            NSString.class,                     RKCharacterStyleNameAttributeName,  
            NSString.class,                     RKParagraphStyleNameAttributeName,
            nil
        ];
        
        // Flags that can be persisted
        NSDictionary *underlineStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithUnsignedInteger: NSUnderlineStyleNone],            @"none",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlineStyleSingle],          @"single",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlineStyleThick],           @"thick",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlineStyleDouble],          @"double",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlinePatternDot],           @"dot",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlinePatternDash],          @"dash",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlinePatternDashDot],       @"dashDot",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlinePatternDashDotDot],    @"dashDotDot",
                                         [NSNumber numberWithUnsignedInteger: NSUnderlineByWordMask],           @"underlineByWord",
                                         nil];

        NSAttributedStringPersistableFlags = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               underlineStyles, NSUnderlineStyleAttributeName,
                                               underlineStyles, NSStrikethroughStyleAttributeName,
                                              nil];
        
        // Enums that can be persisted
        NSDictionary *superscriptStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger: 0],          @"none",
                                           [NSNumber numberWithInteger: 1],          @"superscript",
                                           [NSNumber numberWithInteger: -1],         @"subscript",
                                           nil];
        
        NSDictionary *ligaturStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInteger: 0],          @"none",
                                           [NSNumber numberWithInteger: 1],          @"standard",
                                           [NSNumber numberWithInteger: 2],          @"all",
                                          nil];

        NSDictionary *writingDirection = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInteger: 0],          @"leftToRightEmbedding",
                                          [NSNumber numberWithInteger: 1],          @"rightToLeftEmbedding",
                                          [NSNumber numberWithInteger: 2],          @"leftToRightOverride",
                                          [NSNumber numberWithInteger: 3],          @"rigthToLeftOverride",
                                         nil];
        
        NSAttributedStringPersistableEnums = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              superscriptStyles, NSSuperscriptAttributeName,
                                              ligaturStyles, NSLigatureAttributeName,
                                              writingDirection, NSWritingDirectionAttributeName,
                                             nil];
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

+ (NSDictionary *)attributeDictionaryFromRTFKitPropertyListRepresentation:(id)serializedAttributes usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSDictionary *persistableAttributeTypes = self.persistableAttributeTypes;
    NSMutableDictionary *deserializedAttributes = [NSMutableDictionary new];
    
    [serializedAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, id<RKPersistence> serializedAttributeValue, BOOL *stop) {
        // Get handler class for attribute
        Class handlerClass = [persistableAttributeTypes objectForKey: attributeName];
        NSParameterAssert([handlerClass conformsToProtocol: @protocol(RKPersistence)]);
        
        id attributeValue = nil;
        
        // Translate enum, if possible
        NSDictionary *enumDescriptor = [NSAttributedStringPersistableEnums objectForKey: attributeName];
        if (enumDescriptor && [serializedAttributeValue isKindOfClass: NSString.class])
            attributeValue = [NSNumber numberWithInteger: [enumDescriptor signedEnumValueFromString:(NSString *)serializedAttributeValue error:error]];
        
        // Translation, if flag value
        NSDictionary *flagDescriptor = [NSAttributedStringPersistableFlags objectForKey: attributeName];
        if (flagDescriptor && [serializedAttributeValue isKindOfClass: NSArray.class])
            attributeValue = [NSNumber numberWithUnsignedInteger: [flagDescriptor flagsFromArray:(NSArray *)serializedAttributeValue error:error]];
        
        // Translate other attribute value
        if (!attributeValue)
            attributeValue = [handlerClass instanceWithRTFKitPropertyListRepresentation:serializedAttributeValue usingContext:context error:error];
        
        if (!attributeValue) {
            *stop = YES;
            return;
        }
        
        // Setup attributed string
        [deserializedAttributes setObject:attributeValue forKey:attributeName];
    }];
    
    return deserializedAttributes;
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

+ (id)RTFKitPropertyListRepresentationForAttributeDictionary:(NSDictionary *)attributes usingContext:(RKPersistenceContext *)context
{
    NSMutableDictionary *translatedAttributes = [NSMutableDictionary new];
    NSDictionary *persistableAttributeTypes = self.persistableAttributeTypes;
    
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

        id serializedAttributeValue = nil;
        
        // Translation, if enum value
        NSDictionary *enumDescriptor = [NSAttributedStringPersistableEnums objectForKey: attributeKey];
        if (enumDescriptor)
            serializedAttributeValue = [enumDescriptor stringFromSignedEnumValue: [attributeValue integerValue]];
        
        // Translation, if flag value
        NSDictionary *flagDescriptor = [NSAttributedStringPersistableFlags objectForKey: attributeKey];
        if (flagDescriptor)
            serializedAttributeValue = [flagDescriptor arrayFromFlags: [attributeValue unsignedIntegerValue]];
        
        // Translate attribute value, if neither enum nor flag
        if (!flagDescriptor && !flagDescriptor) {
            NSParameterAssert ([attributeValue conformsToProtocol: @protocol(RKPersistence)]);
               
            serializedAttributeValue = [attributeValue RTFKitPropertyListRepresentationUsingContext: context];
        }

        if (serializedAttributeValue)
            [translatedAttributes setObject:serializedAttributeValue forKey:attributeKey];
    
    }];
    
    return translatedAttributes;
}

@end


/*!
 @abstract Backend methods for serialization
 */
@implementation NSAttributedString (RKPersistenceBackend)

#pragma mark - Deserialization methods

+ (NSAttributedString *)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
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
        NSDictionary *serializedAttributes = attributesForRange[RKPersistenceAttributeValuesKey];
        
        NSRange attributeRange = NSMakeRange([rangeDescriptor[RKPersistenceRangeLocationKey] unsignedIntegerValue], [rangeDescriptor[RKPersistenceRangeLengthKey] unsignedIntegerValue]);
        
        NSDictionary *deserializedAttributes = [self.class attributeDictionaryFromRTFKitPropertyListRepresentation:serializedAttributes usingContext:context error:error];
        [attributedString addAttributes:deserializedAttributes range:attributeRange];
    }
    
    return attributedString;
}



#pragma mark - Serialization methods

- (NSDictionary *)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    NSMutableArray *attributesForRanges = [NSMutableArray new];
    
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
        // Translate attributes in range
        NSMutableDictionary *translatedAttributes = [self.class RTFKitPropertyListRepresentationForAttributeDictionary:attributes usingContext:context];
        
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
