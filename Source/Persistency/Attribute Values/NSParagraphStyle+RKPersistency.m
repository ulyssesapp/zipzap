//
//  NSParagraphStyle+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSParagraphStyle+RKPersistency.h"
#import "NSTextTab+RKPersistency.h"

NSString *NSParagraphStyleAlignmentPersistencyKey                       = @"alignment";
NSString *NSParagraphStyleFirstLineHeadIndentPersistencyKey             = @"firstLineHeadIndent";
NSString *NSParagraphStyleHeadIndentPersistencyKey                      = @"headIndent";
NSString *NSParagraphStyleTailIndentPersistencyKey                      = @"tailIndent";
NSString *NSParagraphStyleTabStopsPersistencyKey                        = @"tabStops";
NSString *NSParagraphStyleDefaultTabIntervalPersistencyKey              = @"defaultTabInterval";
NSString *NSParagraphStyleLineHeightMultiplePersistencyKey              = @"lineHeightMulitple";
NSString *NSParagraphStyleMaximumLineHeightPersistencyKey               = @"maximumLineHeight";
NSString *NSParagraphStyleMinimumLineHeightPersistencyKey               = @"minimumLineHeight";
NSString *NSParagraphStyleLineSpacingPersistencyKey                     = @"lineSpacing";
NSString *NSParagraphStyleParagraphSpacingPersistencyKey                = @"paragraphSpacing";
NSString *NSParagraphStyleParagraphSpacingBeforePersistencyKey          = @"paragraphSpacingBefore";
NSString *NSParagraphStyleLineBreakModePersistencyKey                   = @"lineBreakMode";
NSString *NSParagraphStyleHyphenationFactorPersistencyKey               = @"hyphenationFactor";
NSString *NSParagraphStyleTighteningFactorForTruncationPersistencyKey   = @"tighteningFactorForTruncation";
NSString *NSParagraphStyleBaseWritingDirectionPersistencyKey            = @"baseWritingDirection";

@implementation NSParagraphStyle (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    paragraphStyle.alignment = [propertyList[NSParagraphStyleAlignmentPersistencyKey] unsignedIntegerValue];
    paragraphStyle.firstLineHeadIndent = [propertyList[NSParagraphStyleFirstLineHeadIndentPersistencyKey] floatValue];
    paragraphStyle.headIndent = [propertyList[NSParagraphStyleHeadIndentPersistencyKey] floatValue];
    paragraphStyle.tailIndent = [propertyList[NSParagraphStyleTailIndentPersistencyKey] floatValue];
    paragraphStyle.defaultTabInterval = [propertyList[NSParagraphStyleDefaultTabIntervalPersistencyKey] floatValue];
    paragraphStyle.lineHeightMultiple = [propertyList[NSParagraphStyleLineHeightMultiplePersistencyKey] floatValue];
    paragraphStyle.maximumLineHeight = [propertyList[NSParagraphStyleMaximumLineHeightPersistencyKey] floatValue];
    paragraphStyle.minimumLineHeight = [propertyList[NSParagraphStyleMinimumLineHeightPersistencyKey] floatValue];
    paragraphStyle.lineSpacing = [propertyList[NSParagraphStyleLineSpacingPersistencyKey] floatValue];
    paragraphStyle.paragraphSpacing = [propertyList[NSParagraphStyleParagraphSpacingPersistencyKey] floatValue];
    paragraphStyle.paragraphSpacingBefore = [propertyList[NSParagraphStyleParagraphSpacingBeforePersistencyKey] floatValue];
    paragraphStyle.lineBreakMode = [propertyList[NSParagraphStyleLineBreakModePersistencyKey] unsignedIntegerValue];
    paragraphStyle.hyphenationFactor = [propertyList[NSParagraphStyleHyphenationFactorPersistencyKey] floatValue];
    paragraphStyle.baseWritingDirection = [propertyList[NSParagraphStyleBaseWritingDirectionPersistencyKey] integerValue];
    
    // Deserialize tab stops
    NSMutableArray *deserializedTabStops = [NSMutableArray new];
    
    for (id serializedTabStop in propertyList[NSParagraphStyleTabStopsPersistencyKey]) {
        NSTextTab *tabStop = (NSTextTab *)[NSTextTab instanceWithRTFKitPropertyListRepresentation:serializedTabStop usingContext:context error:error];
        
        if (!tabStop)
            return nil;
        
        [deserializedTabStops addObject: tabStop];
    }
    
    paragraphStyle.tabStops = deserializedTabStops;

    return paragraphStyle;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    // Serialize tab stops
    NSMutableArray *serializedTabStops = [NSMutableArray new];
    
    for (NSTextTab *tabStop in self.tabStops)
        [serializedTabStops addObject: [tabStop RTFKitPropertyListRepresentationUsingContext: context]];
    
    // Serialize other attributes
    return @{
        NSParagraphStyleAlignmentPersistencyKey:                        @(self.alignment),
        NSParagraphStyleFirstLineHeadIndentPersistencyKey:              @(self.firstLineHeadIndent),
        NSParagraphStyleHeadIndentPersistencyKey:                       @(self.headIndent),
        NSParagraphStyleTailIndentPersistencyKey:                       @(self.tailIndent),
        NSParagraphStyleTabStopsPersistencyKey:                         serializedTabStops,
        NSParagraphStyleDefaultTabIntervalPersistencyKey:               @(self.defaultTabInterval),
        NSParagraphStyleLineHeightMultiplePersistencyKey:               @(self.lineHeightMultiple),
        NSParagraphStyleMaximumLineHeightPersistencyKey:                @(self.maximumLineHeight),
        NSParagraphStyleMinimumLineHeightPersistencyKey:                @(self.minimumLineHeight),
        NSParagraphStyleLineSpacingPersistencyKey:                      @(self.lineSpacing),
        NSParagraphStyleParagraphSpacingPersistencyKey:                 @(self.paragraphSpacing),
        NSParagraphStyleParagraphSpacingBeforePersistencyKey:           @(self.paragraphSpacingBefore),
        NSParagraphStyleLineBreakModePersistencyKey:                    @(self.lineBreakMode),
        NSParagraphStyleHyphenationFactorPersistencyKey:                @(self.hyphenationFactor),
        NSParagraphStyleBaseWritingDirectionPersistencyKey:             @(self.baseWritingDirection)
    };
}

@end
