//
//  RKHeaderWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKHeaderWriter.h"
#import "RKResourceManager.h"

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
    
}

@end
