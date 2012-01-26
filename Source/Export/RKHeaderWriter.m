//
//  RKHeaderWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriter.h"
#import "RKResourceManager.h"
#import "RKConversion.h"

// Used to access the metaDataDescriptions 
enum {
    RKMetaDescriptionAccessorKey = 0,
    RKMetaDescriptionExportedTag = 1,
    RKMetaDescriptionExpectedType = 2
};

@interface RKHeaderWriter()

/*!
 @abstract Generates the font table using a resource manager
 */
+ (NSString *)fontTableFromResourceManager:(RKResourceManager *)resources;

/*!
 @abstract Generates the color table using a resource manager
 */
+ (NSString *)colorTableFromResourceManager:(RKResourceManager *)resources;

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

static NSDictionary *metaDataDescriptions;

+ (void)initialize
{
    // An ordered lookup table mapping from the field keys to the field titles and types representing RTF document meta data
    metaDataDescriptions = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects: NSTitleDocumentAttribute,                @"\\title",         @"s", nil],
                            [NSArray arrayWithObjects: NSCompanyDocumentAttribute,              @"\\*\\company",    @"s", nil],
                            [NSArray arrayWithObjects: NSCopyrightDocumentAttribute,            @"\\*\\copyright",  @"s", nil],
                            [NSArray arrayWithObjects: NSSubjectDocumentAttribute,              @"\\subject",       @"s", nil],
                            [NSArray arrayWithObjects: NSAuthorDocumentAttribute,               @"\\author",        @"s", nil],
                            [NSArray arrayWithObjects: NSKeywordsDocumentAttribute,             @"\\keywords",      @"s", nil],
                            [NSArray arrayWithObjects: NSCommentDocumentAttribute,              @"\\doccomm",       @"s", nil],
                            [NSArray arrayWithObjects: NSEditorDocumentAttribute,               @"\\editor",        @"s", nil],
                            [NSArray arrayWithObjects: NSCreationTimeDocumentAttribute,         @"\\creatim",       @"d", nil],
                            [NSArray arrayWithObjects: NSModificationTimeDocumentAttribute,     @"\\revtim",        @"d", nil],
                            [NSArray arrayWithObjects: NSManagerDocumentAttribute,              @"\\manager",       @"s", nil],
                            [NSArray arrayWithObjects: NSCategoryDocumentAttribute,             @"\\category",      @"s", nil],
                            nil
                           ];
}

+ (NSString *)RTFHeaderFromDocument:(RKDocument *)document withResources:(RKResourceManager *)resources
{
    return [NSString stringWithFormat:@"\\rtf1\\ansi\\ansicpg1252%@\n%@\n%@\n%@\n",
            [RKHeaderWriter fontTableFromResourceManager:resources],
            [RKHeaderWriter colorTableFromResourceManager:resources],
            [RKHeaderWriter documentMetaDataFromDocument:document],
            [RKHeaderWriter documentFormatFromDocument:document]
           ];
}

+ (NSString *)fontTableFromResourceManager:(RKResourceManager *)resources
{
    NSMutableString *fontTable = [NSMutableString stringWithString:@"{\\fonttbl"];
    NSUInteger index = 0;
    
    for (NSString *fontFamilyName in resources.collectedFonts) {
        [fontTable appendFormat:@"\\f%i\\fnil\\fcharset0 %@;", index, fontFamilyName];
        index ++;
    }
    
    [fontTable appendString: @"}"];
    
    return fontTable;
}

+ (NSString *)colorTableFromResourceManager:(RKResourceManager *)resources
{
    NSMutableString *colorTable = [NSMutableString stringWithString:@"{\\colortbl"];
    
    for (NSColor *color in resources.collectedColors) {
        [colorTable appendFormat:@"\\red%i\\green%i\\blue%i;", 
         (NSUInteger)([color redComponent] * 255.0f), 
         (NSUInteger)([color greenComponent] * 255.0f),
         (NSUInteger)([color blueComponent] * 255.0f)
        ];
    }
    
    [colorTable appendString: @"}"];
    
    return colorTable;
}

+ (NSString *)documentMetaDataFromDocument:(RKDocument *)document
{
    NSMutableString *infoTable = [NSMutableString stringWithString:@"{\\info"];
    
    for (NSArray *description in metaDataDescriptions) {
        id itemValue = [document.metadata objectForKey:[description objectAtIndex:RKMetaDescriptionAccessorKey]];
        
        if (itemValue) {
            NSString *convertedValue;
            
            if ([[description objectAtIndex:RKMetaDescriptionExpectedType] isEqualTo: @"s"]) {
                convertedValue = [RKConversion safeRTFString: itemValue];
            }
             else if ([[description objectAtIndex:RKMetaDescriptionExpectedType] isEqualTo: @"d"]) {
                convertedValue = [RKConversion RTFDate: itemValue];
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

@end
