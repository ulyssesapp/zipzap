//
//  NSParagraphStyle+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSParagraphStyle+RKPersistence.h"
#import "NSTextTab+RKPersistence.h"
#import "NSDictionary+FlagSerialization.h"

NSString *NSParagraphStyleAlignmentPersistenceKey                       = @"alignment";
NSString *NSParagraphStyleFirstLineHeadIndentPersistenceKey             = @"firstLineHeadIndent";
NSString *NSParagraphStyleHeadIndentPersistenceKey                      = @"headIndent";
NSString *NSParagraphStyleTailIndentPersistenceKey                      = @"tailIndent";
NSString *NSParagraphStyleTabStopsPersistenceKey                        = @"tabStops";
NSString *NSParagraphStyleDefaultTabIntervalPersistenceKey              = @"defaultTabInterval";
NSString *NSParagraphStyleLineHeightMultiplePersistenceKey              = @"lineHeightMulitple";
NSString *NSParagraphStyleMaximumLineHeightPersistenceKey               = @"maximumLineHeight";
NSString *NSParagraphStyleMinimumLineHeightPersistenceKey               = @"minimumLineHeight";
NSString *NSParagraphStyleLineSpacingPersistenceKey                     = @"lineSpacing";
NSString *NSParagraphStyleParagraphSpacingPersistenceKey                = @"paragraphSpacing";
NSString *NSParagraphStyleParagraphSpacingBeforePersistenceKey          = @"paragraphSpacingBefore";
NSString *NSParagraphStyleLineBreakModePersistenceKey                   = @"lineBreakMode";
NSString *NSParagraphStyleHyphenationFactorPersistenceKey               = @"hyphenationFactor";
NSString *NSParagraphStyleTighteningFactorForTruncationPersistenceKey   = @"tighteningFactorForTruncation";
NSString *NSParagraphStyleBaseWritingDirectionPersistenceKey            = @"baseWritingDirection";

NSDictionary *NSParagraphStyleAlignmentEnumDescription;
NSDictionary *NSParagraphStyleTabAlignmentEnumDescription;
NSDictionary *NSParagraphStyleLineBreakModeEnumDescription;
NSDictionary *NSParagraphStyleBaseWritingDescriptionEnumDescription;

@implementation NSParagraphStyle (RKPersistence)

+ (void)load
{
    @autoreleasepool {
        NSParagraphStyleAlignmentEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithUnsignedInteger: NSLeftTextAlignment],          @"left",
                                                    [NSNumber numberWithUnsignedInteger: NSRightTextAlignment],         @"right",
                                                    [NSNumber numberWithUnsignedInteger: NSCenterTextAlignment],        @"center",
                                                    [NSNumber numberWithUnsignedInteger: NSJustifiedTextAlignment],     @"justified",
                                                    [NSNumber numberWithUnsignedInteger: NSNaturalTextAlignment],       @"natural",
                                                   nil];
        
        NSParagraphStyleLineBreakModeEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByWordWrapping],        @"wordWrap",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByCharWrapping],        @"charWrap",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByClipping],            @"clipping",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByTruncatingHead],      @"truncateHead",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByTruncatingTail],      @"truncateTail",
                                                        [NSNumber numberWithUnsignedInteger: NSLineBreakByTruncatingMiddle],    @"truncateMiddle",
                                                        nil];

        NSParagraphStyleBaseWritingDescriptionEnumDescription = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger: NSWritingDirectionNatural],          @"natural",
                                                                 [NSNumber numberWithInteger: NSWritingDirectionLeftToRight],      @"leftToRight",
                                                                 [NSNumber numberWithInteger: NSWritingDirectionRightToLeft],      @"RightToLeft",
                                                                nil];
    }
    
}

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    if ([propertyList objectForKey: NSParagraphStyleAlignmentPersistenceKey])
        paragraphStyle.alignment = [NSParagraphStyleAlignmentEnumDescription unsignedEnumValueFromString: [propertyList objectForKey: NSParagraphStyleAlignmentPersistenceKey] error:error];
    
    if ([propertyList objectForKey: NSParagraphStyleFirstLineHeadIndentPersistenceKey])
        paragraphStyle.firstLineHeadIndent = [[propertyList objectForKey: NSParagraphStyleFirstLineHeadIndentPersistenceKey] floatValue];

    if ([propertyList objectForKey: NSParagraphStyleHeadIndentPersistenceKey])
        paragraphStyle.headIndent = [[propertyList objectForKey: NSParagraphStyleHeadIndentPersistenceKey] floatValue];

    if ([propertyList objectForKey: NSParagraphStyleHeadIndentPersistenceKey])
        paragraphStyle.tailIndent = [[propertyList objectForKey: NSParagraphStyleTailIndentPersistenceKey] floatValue];
  
    if ([propertyList objectForKey: NSParagraphStyleDefaultTabIntervalPersistenceKey])
        paragraphStyle.defaultTabInterval = [[propertyList objectForKey: NSParagraphStyleDefaultTabIntervalPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleLineHeightMultiplePersistenceKey])
        paragraphStyle.lineHeightMultiple = [[propertyList objectForKey: NSParagraphStyleLineHeightMultiplePersistenceKey] floatValue];

    if ([propertyList objectForKey: NSParagraphStyleMaximumLineHeightPersistenceKey])
        paragraphStyle.maximumLineHeight = [[propertyList objectForKey: NSParagraphStyleMaximumLineHeightPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleMinimumLineHeightPersistenceKey])
        paragraphStyle.minimumLineHeight = [[propertyList objectForKey: NSParagraphStyleMinimumLineHeightPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleLineSpacingPersistenceKey])
        paragraphStyle.lineSpacing = [[propertyList objectForKey: NSParagraphStyleLineSpacingPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleParagraphSpacingPersistenceKey])
        paragraphStyle.paragraphSpacing = [[propertyList objectForKey: NSParagraphStyleParagraphSpacingPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleParagraphSpacingBeforePersistenceKey])
        paragraphStyle.paragraphSpacingBefore = [[propertyList objectForKey: NSParagraphStyleParagraphSpacingBeforePersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleLineBreakModePersistenceKey])
        paragraphStyle.lineBreakMode = [NSParagraphStyleLineBreakModeEnumDescription unsignedEnumValueFromString: [propertyList objectForKey: NSParagraphStyleLineBreakModePersistenceKey] error:error];
    
    if ([propertyList objectForKey: NSParagraphStyleHyphenationFactorPersistenceKey])
        paragraphStyle.hyphenationFactor = [[propertyList objectForKey: NSParagraphStyleHyphenationFactorPersistenceKey] floatValue];
    
    if ([propertyList objectForKey: NSParagraphStyleBaseWritingDirectionPersistenceKey])
        paragraphStyle.baseWritingDirection = [NSParagraphStyleBaseWritingDescriptionEnumDescription signedEnumValueFromString: [propertyList objectForKey: NSParagraphStyleBaseWritingDirectionPersistenceKey] error:error];
    
    // Deserialize tab stops
    NSMutableArray *deserializedTabStops = [NSMutableArray new];
    
    for (id serializedTabStop in [propertyList objectForKey: NSParagraphStyleTabStopsPersistenceKey]) {
        NSTextTab *tabStop = (NSTextTab *)[NSTextTab instanceWithRTFKitPropertyListRepresentation:serializedTabStop usingContext:context error:error];
        
        if (!tabStop)
            return nil;
        
        [deserializedTabStops addObject: tabStop];
    }
    
    paragraphStyle.tabStops = deserializedTabStops;

    return paragraphStyle;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    // Serialize tab stops
    NSMutableArray *serializedTabStops = [NSMutableArray new];
    
    for (NSTextTab *tabStop in self.tabStops)
        [serializedTabStops addObject: [tabStop RTFKitPropertyListRepresentationUsingContext: context]];
    
    // Serialize other attributes
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSParagraphStyleAlignmentEnumDescription stringFromUnsignedEnumValue: self.alignment],  NSParagraphStyleAlignmentPersistenceKey,
            [NSNumber numberWithFloat: self.firstLineHeadIndent], NSParagraphStyleFirstLineHeadIndentPersistenceKey,
            [NSNumber numberWithFloat: self.headIndent], NSParagraphStyleHeadIndentPersistenceKey,
            [NSNumber numberWithFloat: self.tailIndent], NSParagraphStyleTailIndentPersistenceKey,
            serializedTabStops, NSParagraphStyleTabStopsPersistenceKey,
            [NSNumber numberWithFloat: self.defaultTabInterval], NSParagraphStyleDefaultTabIntervalPersistenceKey,               
            [NSNumber numberWithFloat: self.lineHeightMultiple], NSParagraphStyleLineHeightMultiplePersistenceKey,               
            [NSNumber numberWithFloat: self.maximumLineHeight], NSParagraphStyleMaximumLineHeightPersistenceKey,                
            [NSNumber numberWithFloat: self.minimumLineHeight], NSParagraphStyleMinimumLineHeightPersistenceKey,                
            [NSNumber numberWithFloat: self.lineSpacing], NSParagraphStyleLineSpacingPersistenceKey,                      
            [NSNumber numberWithFloat: self.paragraphSpacing], NSParagraphStyleParagraphSpacingPersistenceKey,
            [NSNumber numberWithFloat: self.paragraphSpacingBefore],  NSParagraphStyleParagraphSpacingBeforePersistenceKey,           
            [NSParagraphStyleLineBreakModeEnumDescription stringFromUnsignedEnumValue: self.lineBreakMode], NSParagraphStyleLineBreakModePersistenceKey,
            [NSNumber numberWithFloat: self.hyphenationFactor], NSParagraphStyleHyphenationFactorPersistenceKey,                
            [NSParagraphStyleBaseWritingDescriptionEnumDescription stringFromSignedEnumValue: self.baseWritingDirection], NSParagraphStyleBaseWritingDirectionPersistenceKey,
           nil];
}

@end
