//
//  RKListItem+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItem+RKPersistence.h"
#import "RKPersistenceContext.h"

NSString *RKListItemListStyleIndexPersistenceKey = @"listStyle";
NSString *RKListItemIndentationLevelPersistenceKey = @"indentationLevel";

@implementation RKListItem (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSUInteger indentationLevel = [propertyList[RKListItemIndentationLevelPersistenceKey] unsignedIntegerValue];
    RKListStyle *listStyle = [context listStyleForIndex: [propertyList[RKListItemListStyleIndexPersistenceKey] unsignedIntegerValue]];
    if (!listStyle)
        return nil;
    
    RKListItem *listItem = [RKListItem listItemWithStyle:listStyle indentationLevel:indentationLevel];
    
    return listItem;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    return @{
        RKListItemListStyleIndexPersistenceKey:         @([context indexForListStyle: self.listStyle]),
        RKListItemIndentationLevelPersistenceKey:       @(self.indentationLevel)
    };
}

@end
