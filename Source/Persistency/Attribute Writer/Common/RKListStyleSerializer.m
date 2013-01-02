//
//  RKListStyleSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyleSerializer.h"

#import "RKPersistenceContext+PrivateStorageAccessors.h"

NSString *RKListItemListStyleIndexPersistenceKey = @"listStyle";
NSString *RKListItemIndentationLevelPersistenceKey = @"indentationLevel";

@implementation RKListStyleSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKTextListItemAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if (![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    NSUInteger indentationLevel = [[propertyList objectForKey: RKListItemIndentationLevelPersistenceKey] unsignedIntegerValue];
    RKListStyle *listStyle = [context listStyleForIndex: [[propertyList objectForKey: RKListItemListStyleIndexPersistenceKey] unsignedIntegerValue]];
    if (!listStyle)
        return nil;
    
    RKListItem *listItem = [RKListItem listItemWithStyle:listStyle indentationLevel:indentationLevel];
    
    return listItem;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(RKListItem *)attributeValue context:(RKPersistenceContext *)context
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithUnsignedInteger: [context indexForListStyle: attributeValue.listStyle]],      RKListItemListStyleIndexPersistenceKey,
            [NSNumber numberWithUnsignedInteger: attributeValue.indentationLevel],                            RKListItemIndentationLevelPersistenceKey,
            nil];
}

@end
