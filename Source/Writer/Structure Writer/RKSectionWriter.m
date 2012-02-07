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
    NSString *sectionAttributes = [RKSectionWriter sectionAttributesForSection:section];

    NSString *headers = [RKSectionWriter headersForSection:section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources];
    NSString *footers = [RKSectionWriter footersForSection:section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources];
    NSString *content = [RKSectionWriter contentForSection:section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources];
    
    return [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@", sectionAttributes, headers, footers, content];
}

+ (NSString *)sectionAttributesForSection:(RKSection *)section
{
    NSMutableString *attributes = [NSMutableString stringWithString:@"\\titlepg"];
    
    [attributes appendFormat: @"\\cols%u", section.numberOfColumns];
    [attributes appendFormat: @"\\pgnstarts%u", section.indexOfFirstPage];
    
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
            [attributes appendFormat: @"\\pgnultr"];
            break;

        case RKPageNumberingAlphabeticLowerCase:
            [attributes appendFormat: @"\\pgnlltr"];
            break;
    }

    return attributes;
}

+ (NSString *)translateAttributedStringMap:(NSDictionary *)attributedStringMap
                   withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy 
                              resources:(RKResourcePool *)resources
{
    NSMutableString *translation = [NSMutableString new];    
    
    [attributedStringMap enumerateKeysAndObjectsUsingBlock:^(NSString *tag, NSAttributedString *attributedString, BOOL *stop) {
        if (attributedString) {
            [translation appendString:
             [RKAttributedStringWriter RTFfromAttributedString:attributedString insideTag:tag withAttachmentPolicy:attachmentPolicy resources:resources]
            ];
        }
    }];     
    
    return translation;
}

+ (NSString *)headersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSMutableDictionary *translationTable = [NSMutableDictionary new];

    NSAttributedString *headerl = [section headerForPage: RKPageSelectionLeft];
    NSAttributedString *headerr = [section headerForPage: RKPageSelectionRight];
    NSAttributedString *headerf = [section headerForPage: RKPageSelectionFirst];         
    
    if (headerl)
        [translationTable setObject:headerl forKey:@"headerl"];

    if (headerr)
        [translationTable setObject:headerr forKey:@"headerr"];

    if (headerf)
        [translationTable setObject:headerf forKey:@"headerf"];


    return [self translateAttributedStringMap:translationTable withAttachmentPolicy:attachmentPolicy resources:resources];

}

+ (NSString *)footersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    NSMutableDictionary *translationTable = [NSMutableDictionary new];
    
    NSAttributedString *footerl = [section footerForPage: RKPageSelectionLeft];
    NSAttributedString *footerr = [section footerForPage: RKPageSelectionRight];
    NSAttributedString *footerf = [section footerForPage: RKPageSelectionFirst];         
    
    if (footerl)
        [translationTable setObject:footerl forKey:@"footerl"];
    
    if (footerr)
        [translationTable setObject:footerr forKey:@"footerr"];
    
    if (footerf)
        [translationTable setObject:footerf forKey:@"footerf"];
    
    return [self translateAttributedStringMap:translationTable withAttachmentPolicy:attachmentPolicy resources:resources];
}

+ (NSString *)contentForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    return [RKAttributedStringWriter RTFfromAttributedString:section.content withAttachmentPolicy:attachmentPolicy resources:resources];
}

@end
