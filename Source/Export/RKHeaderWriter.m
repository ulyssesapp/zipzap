//
//  RKHeaderWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriter.h"
#import "RKResourcePool.h"
#import "RKConversion.h"

// Used to access the RKHeaderWriterMetadataDescriptions 
enum {
    RKMetaDescriptionAccessorKey = 0,
    RKMetaDescriptionExportedTag = 1,
    RKMetaDescriptionExpectedType = 2
};

@interface RKHeaderWriter()

/*!
 @abstract Generates the font table using a resource manager
 */
+ (NSString *)fontTableFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generates the color table using a resource manager
 */
+ (NSString *)colorTableFromResourceManager:(RKResourcePool *)resources;

/*!
 @abstract Generates the document informations from a document
 */
+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document;

/*!
 @abstract Generates the document layout settings from a document
 */
+ (NSString *)documentFormatFromDocument:(RKDocument *)document;

@end

@implementation RKHeaderWriter

NSDictionary *RKHeaderWriterMetadataDescriptions;

+ (void)initialize
{
    // An ordered lookup table mapping from the field keys to the field titles and types representing RTF document meta data
    RKHeaderWriterMetadataDescriptions = 
                           [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects: NSTitleDocumentAttribute,                @"\\title",         [NSString class], nil],
                            [NSArray arrayWithObjects: NSCompanyDocumentAttribute,              @"\\*\\company",    [NSString class], nil],
                            [NSArray arrayWithObjects: NSCopyrightDocumentAttribute,            @"\\*\\copyright",  [NSString class], nil],
                            [NSArray arrayWithObjects: NSSubjectDocumentAttribute,              @"\\subject",       [NSString class], nil],
                            [NSArray arrayWithObjects: NSAuthorDocumentAttribute,               @"\\author",        [NSString class], nil],
                            [NSArray arrayWithObjects: NSKeywordsDocumentAttribute,             @"\\keywords",      [NSString class], nil],
                            [NSArray arrayWithObjects: NSCommentDocumentAttribute,              @"\\doccomm",       [NSString class], nil],
                            [NSArray arrayWithObjects: NSEditorDocumentAttribute,               @"\\editor",        [NSString class], nil],
                            [NSArray arrayWithObjects: NSCreationTimeDocumentAttribute,         @"\\creatim",       [NSDate class], nil],
                            [NSArray arrayWithObjects: NSModificationTimeDocumentAttribute,     @"\\revtim",        [NSDate class], nil],
                            [NSArray arrayWithObjects: NSManagerDocumentAttribute,              @"\\manager",       [NSString class], nil],
                            [NSArray arrayWithObjects: NSCategoryDocumentAttribute,             @"\\category",      [NSString class], nil],
                            nil
                           ];
}

+ (NSString *)RTFHeaderFromDocument:(RKDocument *)document withResources:(RKResourcePool *)resources
{
    return [NSString stringWithFormat:@"\\rtf1\\ansi\\ansicpg1252\n%@\n%@\n%@\n%@\n",
            [RKHeaderWriter fontTableFromResourceManager:resources],
            [RKHeaderWriter colorTableFromResourceManager:resources],
            [RKHeaderWriter documentMetaDataFromDocument:document],
            [RKHeaderWriter documentFormatFromDocument:document]
           ];
}

+ (NSString *)fontTableFromResourceManager:(RKResourcePool *)resources
{
    NSMutableString *fontTable = [NSMutableString stringWithString:@"{\\fonttbl"];
    
    [resources.fontFamilyNames enumerateObjectsUsingBlock:^(NSString *fontFamilyName, NSUInteger index, BOOL *stop) {
        [fontTable appendFormat:@"\\f%i\\fnil\\fcharset0 %@;", index, fontFamilyName];
    }];
    
    [fontTable appendString: @"}"];
    
    return fontTable;
}

+ (NSString *)colorTableFromResourceManager:(RKResourcePool *)resources
{
    NSMutableString *colorTable = [NSMutableString stringWithString:@"{\\colortbl;"];
    
    [resources.colors enumerateObjectsUsingBlock:^(NSColor *color, NSUInteger index, BOOL *stop) {
        if (index > 0) {
            [colorTable appendFormat:@"\\red%i\\green%i\\blue%i;", 
             (NSUInteger)([color redComponent] * 255.0f), 
             (NSUInteger)([color greenComponent] * 255.0f),
             (NSUInteger)([color blueComponent] * 255.0f)
             ];
        }
    }];
    
    [colorTable appendString: @"}"];
    
    return colorTable;
}

+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document
{
    NSMutableString *infoTable = [NSMutableString stringWithString:@"{\\info"];
    
    for (NSArray *description in RKHeaderWriterMetadataDescriptions) {
        id itemValue = [document.metadata objectForKey:[description objectAtIndex:RKMetaDescriptionAccessorKey]];
        
        if (itemValue) {
            NSString *convertedValue;
            
            if ([[description objectAtIndex:RKMetaDescriptionExpectedType] isEqualTo: [NSString class]]) {
                convertedValue = [itemValue RTFEscapedString];
            }
             else if ([[description objectAtIndex:RKMetaDescriptionExpectedType] isEqualTo: [NSDate class]]) {
                convertedValue = [itemValue RTFDate];
            }
            else {
                NSAssert(false, @"Invalid meta data definitions");
            }
            
            [infoTable appendFormat:@"{%@ %@}", [description objectAtIndex:RKMetaDescriptionExportedTag], convertedValue];
        }
    }
    
    [infoTable appendString: @"}"];
    
    return infoTable;
}

+ (NSString *)documentFormatFromDocument:(RKDocument *)document
{
    NSMutableString *attributes = [NSMutableString string];
    
    // Hyphenation settings
    if (document.hyphenationEnabled)
        [attributes appendString:@"\\hyphauto"];
    
    // Footnote settings
    switch (document.footnotePlacement) {
        case RKFootnotePlacementSamePage:
            [attributes appendString:@"\\fet0"];
            break;
        case RKFootnotePlacementDocumentEnd:
            [attributes appendString:@"\\fet1\\enddoc\\aenddoc"];
            break;
        case RKFootnotePlacementSectionEnd:
            [attributes appendString:@"\\fet1\\endnotes\\aendnotes"];
            break;
    }
    
    // Page orientation
    if (document.pageOrientation == RKPageOrientationLandscape)
        [attributes appendString:@"\\landscape"];
    
    // Paper size
    [attributes appendFormat:[NSString stringWithFormat:@"\\paperw%u\\paperh%u", 
                                (NSUInteger)RKPointsToTwips(document.pageSize.width), 
                                (NSUInteger)RKPointsToTwips(document.pageSize.height)
                              ]];
    
    // Margins
    [attributes appendFormat:[NSString stringWithFormat:@"\\margt%u\\margl%u\\margr%u\\margb%u", 
                              (NSUInteger)RKPointsToTwips(document.pageInsets.top), 
                              (NSUInteger)RKPointsToTwips(document.pageInsets.left), 
                              (NSUInteger)RKPointsToTwips(document.pageInsets.right), 
                              (NSUInteger)RKPointsToTwips(document.pageInsets.bottom)
                              ]];   
    
    // We disable ANSI replacements for UNICODE charracters in general
    // To prevent conflicts with text following the formatting tags, add a space
    [attributes appendString:@"\\uc0 "];

    return attributes;
}

@end
