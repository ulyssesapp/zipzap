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

NSMutableDictionary *RKStyleAttributeSerializerFlagStyles;
NSMutableDictionary *RKStyleAttributeSerializerEnumerationStyles;
NSMutableArray *RKStyleAttributeSerializerNumericStyles;

+ (void)load
{
    @autoreleasepool {
		// Register flat numeric attributes
        [self registerNumericAttributeWithName: RKStrokeWidthAttributeName];
        [self registerNumericAttributeWithName: RKBaselineOffsetAttributeName];
        [self registerNumericAttributeWithName: RKKernAttributeName];
        [self registerNumericAttributeWithName: RKObliquenessAttributeName];
		
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKStrokeWidthAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKBaselineOffsetAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKKernAttributeName];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKObliquenessAttributeName];        
        
        // Serialization of underline styles
        NSDictionary *underlineStyles = [NSDictionary dictionaryWithObjectsAndKeys:
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

        [self registerAttributeWithName:RKUnderlineStyleAttributeName usingEnumeration:underlineStyles];
		[NSAttributedString registerAttributeSerializer:self forAttribute:RKUnderlineStyleAttributeName];

        [self registerAttributeWithName:RKStrikethroughStyleAttributeName usingEnumeration:underlineStyles];		
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKStrikethroughStyleAttributeName];
		
		// Serialization of superscript styles        
        NSDictionary *superscriptStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInteger: 0],          @"none",
                                                       [NSNumber numberWithInteger: 1],          @"superscript",
                                                       [NSNumber numberWithInteger: -1],         @"subscript",
                                                      nil];
		
		[self registerAttributeWithName:RKSuperscriptAttributeName usingEnumeration:superscriptStyles];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKSuperscriptAttributeName];
        
		// Serialization of ligature styles
        NSDictionary *ligatureStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithInteger: 0],          @"none",
                                                   [NSNumber numberWithInteger: 1],          @"standard",
                                                   [NSNumber numberWithInteger: 2],          @"all",
                                                  nil];

		[self registerAttributeWithName:RKLigatureAttributeName usingEnumeration:ligatureStyles];		
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKLigatureAttributeName];
        
		// Serialization of placeholer styles
        NSDictionary *placeholderStyles = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       [NSNumber numberWithInteger: RKPlaceholderPageNumber],    @"pageNumber",
                                                       [NSNumber numberWithInteger: RKPlaceholderSectionNumber], @"sectionNumber",
                                                      nil];
		[self registerAttributeWithName:RKPlaceholderAttributeName usingEnumeration:placeholderStyles];
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKPlaceholderAttributeName];
		
    }
}

+ (void)registerAttributeWithName:(NSString *)attributeName usingFlags:(NSDictionary *)flagStyles
{
	if (!RKStyleAttributeSerializerFlagStyles)
		RKStyleAttributeSerializerFlagStyles = [NSMutableDictionary new];
	
	[RKStyleAttributeSerializerFlagStyles setObject:flagStyles forKey:attributeName];
}

+ (void)registerAttributeWithName:(NSString *)attributeName usingEnumeration:(NSDictionary *)enumerationStyles
{
	if (!RKStyleAttributeSerializerEnumerationStyles)
		RKStyleAttributeSerializerEnumerationStyles = [NSMutableDictionary new];
	
	[RKStyleAttributeSerializerEnumerationStyles setObject:enumerationStyles forKey:attributeName];	
}

+ (void)registerNumericAttributeWithName:(NSString *)attributeName
{
	if (!RKStyleAttributeSerializerNumericStyles)
		RKStyleAttributeSerializerNumericStyles = [NSMutableArray new];
	
	[RKStyleAttributeSerializerNumericStyles addObject: attributeName];
}

+ (NSNumber *)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
	// Is it a flag attribute?
	NSDictionary *flags = [RKStyleAttributeSerializerFlagStyles objectForKey: attributeName];
	if (flags) 
		return [NSNumber numberWithUnsignedInteger: [flags flagsFromArray:propertyList error:error]];

	// Is it an enumeration attribute?
	NSDictionary *enumerations = [RKStyleAttributeSerializerEnumerationStyles objectForKey: attributeName];
	if (enumerations)
		return [NSNumber numberWithInteger: [enumerations signedEnumValueFromString:propertyList error:error]];

	
	// Is it a flat numeric attribute?
	if ([RKStyleAttributeSerializerNumericStyles containsObject: attributeName])
		return propertyList;

	// Attribute not found
    NSAssert(false, @"Invalid attribute deserialized");
    return nil;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(NSNumber *)attributeValue context:(RKPersistenceContext *)context
{
	// Is it a flag attribute?
	NSDictionary *flags = [RKStyleAttributeSerializerFlagStyles objectForKey: attributeName];
	if (flags)
		return [flags arrayFromFlags: attributeValue.unsignedIntegerValue];
	
	// Is it an enumeration attribute?
	NSDictionary *enumeration = [RKStyleAttributeSerializerEnumerationStyles objectForKey: attributeName];
	if (enumeration)
		return [enumeration stringFromSignedEnumValue: attributeValue.integerValue];
	
	// Is it a flat numeric attribute?
	if ([RKStyleAttributeSerializerNumericStyles containsObject: attributeName])
		return attributeValue;
	
	// Attribute not found
    NSAssert(false, @"Invalid attribute deserialized");
    return nil;
}

@end
