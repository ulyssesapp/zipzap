//
//  NSParagraphStyle+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSParagraphStyle+RKPersistence.h"
#import "NSTextTab+RKPersistence.h"

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

@implementation NSParagraphStyle (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    paragraphStyle.alignment = [propertyList[NSParagraphStyleAlignmentPersistenceKey] unsignedIntegerValue];
    paragraphStyle.firstLineHeadIndent = [propertyList[NSParagraphStyleFirstLineHeadIndentPersistenceKey] floatValue];
    paragraphStyle.headIndent = [propertyList[NSParagraphStyleHeadIndentPersistenceKey] floatValue];
    paragraphStyle.tailIndent = [propertyList[NSParagraphStyleTailIndentPersistenceKey] floatValue];
    paragraphStyle.defaultTabInterval = [propertyList[NSParagraphStyleDefaultTabIntervalPersistenceKey] floatValue];
    paragraphStyle.lineHeightMultiple = [propertyList[NSParagraphStyleLineHeightMultiplePersistenceKey] floatValue];
    paragraphStyle.maximumLineHeight = [propertyList[NSParagraphStyleMaximumLineHeightPersistenceKey] floatValue];
    paragraphStyle.minimumLineHeight = [propertyList[NSParagraphStyleMinimumLineHeightPersistenceKey] floatValue];
    paragraphStyle.lineSpacing = [propertyList[NSParagraphStyleLineSpacingPersistenceKey] floatValue];
    paragraphStyle.paragraphSpacing = [propertyList[NSParagraphStyleParagraphSpacingPersistenceKey] floatValue];
    paragraphStyle.paragraphSpacingBefore = [propertyList[NSParagraphStyleParagraphSpacingBeforePersistenceKey] floatValue];
    paragraphStyle.lineBreakMode = [propertyList[NSParagraphStyleLineBreakModePersistenceKey] unsignedIntegerValue];
    paragraphStyle.hyphenationFactor = [propertyList[NSParagraphStyleHyphenationFactorPersistenceKey] floatValue];
    paragraphStyle.baseWritingDirection = [propertyList[NSParagraphStyleBaseWritingDirectionPersistenceKey] integerValue];
    
    // Deserialize tab stops
    NSMutableArray *deserializedTabStops = [NSMutableArray new];
    
    for (id serializedTabStop in propertyList[NSParagraphStyleTabStopsPersistenceKey]) {
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
    return @{
        NSParagraphStyleAlignmentPersistenceKey:                        @(self.alignment),
        NSParagraphStyleFirstLineHeadIndentPersistenceKey:              @(self.firstLineHeadIndent),
        NSParagraphStyleHeadIndentPersistenceKey:                       @(self.headIndent),
        NSParagraphStyleTailIndentPersistenceKey:                       @(self.tailIndent),
        NSParagraphStyleTabStopsPersistenceKey:                         serializedTabStops,
        NSParagraphStyleDefaultTabIntervalPersistenceKey:               @(self.defaultTabInterval),
        NSParagraphStyleLineHeightMultiplePersistenceKey:               @(self.lineHeightMultiple),
        NSParagraphStyleMaximumLineHeightPersistenceKey:                @(self.maximumLineHeight),
        NSParagraphStyleMinimumLineHeightPersistenceKey:                @(self.minimumLineHeight),
        NSParagraphStyleLineSpacingPersistenceKey:                      @(self.lineSpacing),
        NSParagraphStyleParagraphSpacingPersistenceKey:                 @(self.paragraphSpacing),
        NSParagraphStyleParagraphSpacingBeforePersistenceKey:           @(self.paragraphSpacingBefore),
        NSParagraphStyleLineBreakModePersistenceKey:                    @(self.lineBreakMode),
        NSParagraphStyleHyphenationFactorPersistenceKey:                @(self.hyphenationFactor),
        NSParagraphStyleBaseWritingDirectionPersistenceKey:             @(self.baseWritingDirection)
    };
}

@end
