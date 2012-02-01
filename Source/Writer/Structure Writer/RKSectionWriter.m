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

@interface RKSectionWriter ()

/*!
 @abstract Translates all section attributes to RTF command
 */
+ (NSString *)sectionAttributesForSection:(RKSection *)section;

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
    NSMutableString *attributes = [NSMutableString new];
    
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
     
+ (NSString *)headersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    return @"";
}

+ (NSString *)footersForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    return @"";
}

+ (NSString *)contentForSection:(RKSection *)section withAttachmentPolicy:(RKAttachmentPolicy)attachmentPolicy resources:(RKResourcePool *)resources
{
    return @"";
}

@end
