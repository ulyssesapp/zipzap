//
//  RKFontSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFontSerializer.h"
#import "RKFontAdditions.h"

NSString *RKFontNamePersistenceKey = @"name";
NSString *RKFontSizePersistenceKey = @"size";

@implementation RKFontSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKFontAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if(![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }

    CTFontRef defaultFont = RKGetDefaultFont();

    NSString *fontName;
    CGFloat pointSize;

    if ([propertyList objectForKey: RKFontNamePersistenceKey])
        fontName = [propertyList objectForKey: RKFontNamePersistenceKey];
    else
        fontName = (__bridge_transfer NSString *)CTFontCopyPostScriptName(defaultFont);

    if ([propertyList objectForKey: RKFontSizePersistenceKey])
        pointSize = [[propertyList objectForKey: RKFontSizePersistenceKey] floatValue];
    else
        pointSize = CTFontGetSize(defaultFont);

    return (__bridge id)CTFontCreateWithName((__bridge CFStringRef)fontName, pointSize, NULL);
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    CTFontRef font = (__bridge CTFontRef)attributeValue;
    
    NSString *fontName = (__bridge_transfer NSString *)CTFontCopyPostScriptName(font);
    CGFloat size = CTFontGetSize(font);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            fontName,                           RKFontNamePersistenceKey,
            [NSNumber numberWithFloat: size],   RKFontSizePersistenceKey,
           nil];
}

@end
