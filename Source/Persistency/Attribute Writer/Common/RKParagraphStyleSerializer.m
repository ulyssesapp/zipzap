//
//  RKParagraphStyleSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKParagraphStyleSerializer.h"

#import "RKParagraphStyleWrapper.h"
#import "RKTextTabWrapper.h"

#import "NSDictionary+FlagSerialization.h"

@implementation RKParagraphStyleSerializer

// Serialization keys for paragraph styles
NSString *RKParagraphStyleAlignmentPersistenceKey                       = @"alignment";
NSString *RKParagraphStyleFirstLineHeadIndentPersistenceKey             = @"firstLineHeadIndent";
NSString *RKParagraphStyleHeadIndentPersistenceKey                      = @"headIndent";
NSString *RKParagraphStyleTailIndentPersistenceKey                      = @"tailIndent";
NSString *RKParagraphStyleTabStopsPersistenceKey                        = @"tabStops";
NSString *RKParagraphStyleDefaultTabIntervalPersistenceKey              = @"defaultTabInterval";
NSString *RKParagraphStyleLineHeightMultiplePersistenceKey              = @"lineHeightMultiple";
NSString *RKParagraphStyleMaximumLineHeightPersistenceKey               = @"maximumLineHeight";
NSString *RKParagraphStyleMinimumLineHeightPersistenceKey               = @"minimumLineHeight";
NSString *RKParagraphStyleLineSpacingPersistenceKey                     = @"lineSpacing";
NSString *RKParagraphStyleParagraphSpacingPersistenceKey                = @"paragraphSpacing";
NSString *RKParagraphStyleParagraphSpacingBeforePersistenceKey          = @"paragraphSpacingBefore";
NSString *RKParagraphStyleLineBreakModePersistenceKey                   = @"lineBreakMode";
NSString *RKParagraphStyleHyphenationFactorPersistenceKey               = @"hyphenationFactor";
NSString *RKParagraphStyleTighteningFactorForTruncationPersistenceKey   = @"tighteningFactorForTruncation";
NSString *RKParagraphStyleBaseWritingDirectionPersistenceKey            = @"baseWritingDirection";

NSDictionary *RKParagraphStyleAlignmentEnumDescription;
NSDictionary *RKParagraphStyleTabAlignmentEnumDescription;
NSDictionary *RKParagraphStyleLineBreakModeEnumDescription;
NSDictionary *RKParagraphStyleBaseWritingDescriptionEnumDescription;

// Serialization keys for text tabs
NSString *RKTextTabAlignmentPersistenceKey                              =   @"alignment";
NSString *RKTextTabLocationPersistenceKey                               =   @"location";

NSDictionary *RKTextTabAlignmentEnumDescription;

+ (void)load
{
    @autoreleasepool {
        RKParagraphStyleAlignmentEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithUnsignedInteger: kCTTextAlignmentLeft],         @"left",
                                                    [NSNumber numberWithUnsignedInteger: kCTTextAlignmentRight],        @"right",
                                                    [NSNumber numberWithUnsignedInteger: kCTTextAlignmentCenter],       @"center",
                                                    [NSNumber numberWithUnsignedInteger: kCTTextAlignmentJustified],	@"justified",
                                                    [NSNumber numberWithUnsignedInteger: kCTTextAlignmentNatural],		@"natural",
                                                    nil];
        
        RKParagraphStyleLineBreakModeEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByWordWrapping],        @"wordWrap",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByCharWrapping],        @"charWrap",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByClipping],            @"clipping",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByTruncatingHead],      @"truncateHead",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByTruncatingTail],      @"truncateTail",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByTruncatingMiddle],    @"truncateMiddle",
                                                        nil];
        
        RKParagraphStyleBaseWritingDescriptionEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger: NSWritingDirectionNatural],          @"natural",
                                                                 [NSNumber numberWithInteger: NSWritingDirectionLeftToRight],      @"leftToRight",
                                                                 [NSNumber numberWithInteger: NSWritingDirectionRightToLeft],      @"rightToLeft",
                                                                 nil];
        
        RKTextTabAlignmentEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithUnsignedInteger: kCTTextAlignmentLeft],        @"left",
                                             [NSNumber numberWithUnsignedInteger: kCTTextAlignmentRight],       @"right",
                                             [NSNumber numberWithUnsignedInteger: kCTTextAlignmentCenter],      @"center",
                                             nil];
        
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKParagraphStyleAttributeName];
    }
    
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if (![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    RKParagraphStyleWrapper *paragraphStyle = [RKParagraphStyleWrapper newDefaultParagraphStyle];
    
    if ([propertyList objectForKey: RKParagraphStyleAlignmentPersistenceKey])
        paragraphStyle.textAlignment = [RKParagraphStyleAlignmentEnumDescription unsignedEnumValueFromString: [propertyList objectForKey: RKParagraphStyleAlignmentPersistenceKey] error:error];
    
    if ([propertyList objectForKey: RKParagraphStyleFirstLineHeadIndentPersistenceKey])
        paragraphStyle.firstLineHeadIndent = [[propertyList objectForKey: RKParagraphStyleFirstLineHeadIndentPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleHeadIndentPersistenceKey])
        paragraphStyle.headIndent = [[propertyList objectForKey: RKParagraphStyleHeadIndentPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleTailIndentPersistenceKey])
        paragraphStyle.tailIndent = [[propertyList objectForKey: RKParagraphStyleTailIndentPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleDefaultTabIntervalPersistenceKey])
        paragraphStyle.defaultTabInterval = [[propertyList objectForKey: RKParagraphStyleDefaultTabIntervalPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleLineHeightMultiplePersistenceKey])
        paragraphStyle.lineHeightMultiple = [[propertyList objectForKey: RKParagraphStyleLineHeightMultiplePersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleMaximumLineHeightPersistenceKey])
        paragraphStyle.maximumLineHeight = [[propertyList objectForKey: RKParagraphStyleMaximumLineHeightPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleMinimumLineHeightPersistenceKey])
        paragraphStyle.minimumLineHeight = [[propertyList objectForKey: RKParagraphStyleMinimumLineHeightPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleLineSpacingPersistenceKey])
        paragraphStyle.lineSpacing = [[propertyList objectForKey: RKParagraphStyleLineSpacingPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleParagraphSpacingPersistenceKey])
        paragraphStyle.paragraphSpacing = [[propertyList objectForKey: RKParagraphStyleParagraphSpacingPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleParagraphSpacingBeforePersistenceKey])
        paragraphStyle.paragraphSpacingBefore = [[propertyList objectForKey: RKParagraphStyleParagraphSpacingBeforePersistenceKey] floatValue];

    if ([propertyList objectForKey: RKParagraphStyleLineBreakModePersistenceKey])
        paragraphStyle.lineBreakMode = [RKParagraphStyleLineBreakModeEnumDescription unsignedEnumValueFromString: [propertyList objectForKey: RKParagraphStyleLineBreakModePersistenceKey] error:error];
    
    if ([propertyList objectForKey: RKParagraphStyleHyphenationFactorPersistenceKey])
        paragraphStyle.hyphenationFactor = [[propertyList objectForKey: RKParagraphStyleHyphenationFactorPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: RKParagraphStyleBaseWritingDirectionPersistenceKey])
        paragraphStyle.baseWritingDirection = [RKParagraphStyleBaseWritingDescriptionEnumDescription signedEnumValueFromString: [propertyList objectForKey: RKParagraphStyleBaseWritingDirectionPersistenceKey] error:error];
    
    // Deserialize tab stops
    NSMutableArray *deserializedTabStops = [NSMutableArray new];
    
    for (NSDictionary *serializedTabStop in [propertyList objectForKey: RKParagraphStyleTabStopsPersistenceKey]) {
        RKTextTabWrapper *tabStop = (RKTextTabWrapper *)[RKTextTabWrapper new];

        if ([serializedTabStop objectForKey: RKTextTabAlignmentPersistenceKey])
            tabStop.tabAlignment = [RKTextTabAlignmentEnumDescription unsignedEnumValueFromString: [serializedTabStop objectForKey: RKTextTabAlignmentPersistenceKey] error:error];

        if ([serializedTabStop objectForKey: RKTextTabLocationPersistenceKey])
            tabStop.location = [[serializedTabStop objectForKey: RKTextTabLocationPersistenceKey] floatValue];
            
        [deserializedTabStops addObject: tabStop];
    }
    
    paragraphStyle.tabStops = deserializedTabStops;
    
	return paragraphStyle.newNSParagraphStyle;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    RKParagraphStyleWrapper *paragraphStyle;
    
    paragraphStyle = [[RKParagraphStyleWrapper alloc] initWithNSParagraphStyle: attributeValue];
	
    // Serialize tab stops
    NSMutableArray *serializedTabStops = [NSMutableArray new];
    
    for (RKTextTabWrapper *tabStop in paragraphStyle.tabStops) {
        NSMutableDictionary *serializedTabStop = [NSMutableDictionary new];
        
        [serializedTabStop setObject:[RKTextTabAlignmentEnumDescription stringFromUnsignedEnumValue: tabStop.tabAlignment] forKey:RKTextTabAlignmentPersistenceKey];
        [serializedTabStop setObject:[NSNumber numberWithFloat: tabStop.location] forKey:RKTextTabLocationPersistenceKey];
        
        [serializedTabStops addObject: serializedTabStop];
    }
    
    // Serialize other attributes
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [RKParagraphStyleAlignmentEnumDescription stringFromUnsignedEnumValue: paragraphStyle.textAlignment],  RKParagraphStyleAlignmentPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.firstLineHeadIndent], RKParagraphStyleFirstLineHeadIndentPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.headIndent], RKParagraphStyleHeadIndentPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.tailIndent], RKParagraphStyleTailIndentPersistenceKey,
            serializedTabStops, RKParagraphStyleTabStopsPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.defaultTabInterval], RKParagraphStyleDefaultTabIntervalPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.lineHeightMultiple], RKParagraphStyleLineHeightMultiplePersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.maximumLineHeight], RKParagraphStyleMaximumLineHeightPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.minimumLineHeight], RKParagraphStyleMinimumLineHeightPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.lineSpacing], RKParagraphStyleLineSpacingPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.paragraphSpacing], RKParagraphStyleParagraphSpacingPersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.paragraphSpacingBefore],  RKParagraphStyleParagraphSpacingBeforePersistenceKey,
            [RKParagraphStyleLineBreakModeEnumDescription stringFromUnsignedEnumValue: paragraphStyle.lineBreakMode], RKParagraphStyleLineBreakModePersistenceKey,
            [NSNumber numberWithFloat: paragraphStyle.hyphenationFactor], RKParagraphStyleHyphenationFactorPersistenceKey,
            [RKParagraphStyleBaseWritingDescriptionEnumDescription stringFromSignedEnumValue: paragraphStyle.baseWritingDirection], RKParagraphStyleBaseWritingDirectionPersistenceKey,
            nil];
}

@end
