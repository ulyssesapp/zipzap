//
//  RKSectionWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKSection.h"
#import "RKWriter.h"
#import "RKResourcePool.h"
#import "RKSectionWriter.h"
#import "RKAttributedStringWriter.h"
#import "NSString+RKConvenienceAdditions.h"

@interface RKSectionWriter ()

/*!
 @abstract Translates all section attributes to RTF command
 */
+ (NSString *)sectionAttributesForSection:(RKSection *)section;

/*!
 @abstract Translates a mapping from tag names to attributed string such that the translated
           attributed strings are surrounded by the given tag
 */
+ (NSString *)translateAttributedStringMap:(NSDictionary *)attributedStringMap
                      withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                                 resources:(RKResourcePool *)resources;

/*!
 @abstract Translates all headers of a section to RTF
 */
+ (NSString *)headersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

/*!
 @abstract Translates all footers of a section to RTF
 */
+ (NSString *)footersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

/*!
 @abstract Translates the content of a section to RTF
 */
+ (NSString *)contentForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources;

@end

@implementation RKSectionWriter

+ (NSString *)RTFFromSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSString *sectionAttributes = [self sectionAttributesForSection:section];

    NSString *headers = [self headersForSection:section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources];
    NSString *footers = [self footersForSection:section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources];
    NSString *content = [self contentForSection:section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources];
    
    return [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@", sectionAttributes, headers, footers, content];
}

+ (NSString *)sectionAttributesForSection:(RKSection *)section
{
    NSMutableString *attributes = [NSMutableString stringWithString:@"\\titlepg"];
    
    [attributes appendFormat: @"\\cols%lu", section.numberOfColumns];
    
    if (section.indexOfFirstPage != RKContinuousPageNumbering)
        [attributes appendFormat: @"\\pgnstarts%lu\\pgnrestart", section.indexOfFirstPage];
    
    switch (section.pageNumberingStyle) {
        case RKPageNumberingDecimal:
            [attributes appendFormat: @"\\pgndec"];
            break;

        case RKPageNumberingRomanLowerCase:
            [attributes appendFormat: @"\\pgnlcrm"];
            break;

        case RKPageNumberingRomanUpperCase:
            [attributes appendFormat: @"\\pgnucrm"];
            break;

        case RKPageNumberingAlphabeticUpperCase:
            [attributes appendFormat: @"\\pgnucltr"];
            break;

        case RKPageNumberingAlphabeticLowerCase:
            [attributes appendFormat: @"\\pgnlcltr"];
            break;
    }

    return attributes;
}

+ (NSString *)translateAttributedStringMap:(NSDictionary *)attributedStringMap
                   withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                              resources:(RKResourcePool *)resources
{
    NSMutableString *translation = [NSMutableString new];    
    
    for (NSString *tag in [attributedStringMap.allKeys sortedArrayUsingSelector:@selector(compare:)]) {
        NSAttributedString *attributedString = [attributedStringMap objectForKey: tag];

        [translation appendString:
         [NSString stringWithRTFGroupTag:tag body:[RKAttributedStringWriter RTFFromAttributedString:attributedString withAttachmentPolicy:attachmentPolicy resources:resources]]
        ];
    }     
    
    return translation;
}

+ (NSString *)headersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSMutableDictionary *translationTable = [NSMutableDictionary new];

    NSAttributedString *leftHeader = [section headerForPage: RKPageSelectionLeft];
    NSAttributedString *rightHeader = [section headerForPage: RKPageSelectionRight];
    NSAttributedString *firstHeader = [section headerForPage: RKPageSelectionFirst];         
    
    if (leftHeader)
        [translationTable setObject:leftHeader forKey:@"headerl"];

    if (rightHeader)
        [translationTable setObject:rightHeader forKey:@"headerr"];

    if (firstHeader)
        [translationTable setObject:firstHeader forKey:@"headerf"];


    return [self translateAttributedStringMap:translationTable withAttachmentPolicy:attachmentPolicy resources:resources];

}

+ (NSString *)footersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSMutableDictionary *translationTable = [NSMutableDictionary new];
    
    NSAttributedString *leftFooter = [section footerForPage: RKPageSelectionLeft];
    NSAttributedString *rightFooter = [section footerForPage: RKPageSelectionRight];
    NSAttributedString *firstFooter = [section footerForPage: RKPageSelectionFirst];         
    
    if (leftFooter)
        [translationTable setObject:leftFooter forKey:@"footerl"];
    
    if (rightFooter)
        [translationTable setObject:rightFooter forKey:@"footerr"];
    
    if (firstFooter)
        [translationTable setObject:firstFooter forKey:@"footerf"];
    
    return [self translateAttributedStringMap:translationTable withAttachmentPolicy:attachmentPolicy resources:resources];
}

+ (NSString *)contentForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    return [RKAttributedStringWriter RTFFromAttributedString:section.content withAttachmentPolicy:attachmentPolicy resources:resources];
}

@end
