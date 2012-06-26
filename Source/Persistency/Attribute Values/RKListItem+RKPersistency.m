//
//  RKListItem+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItem+RKPersistency.h"
#import "RKPersistencyContext.h"

NSString *RKListItemListStyleIndexPersistencyKey = @"listStyle";
NSString *RKListItemIndentationLevelPersistencyKey = @"indentationLevel";

@implementation RKListItem (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSUInteger indentationLevel = [propertyList[RKListItemIndentationLevelPersistencyKey] unsignedIntegerValue];
    RKListStyle *listStyle = [context listStyleForIndex: [propertyList[RKListItemListStyleIndexPersistencyKey] unsignedIntegerValue]];
    if (!listStyle)
        return nil;
    
    RKListItem *listItem = [RKListItem listItemWithStyle:listStyle indentationLevel:indentationLevel];
    
    return listItem;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return @{
        RKListItemListStyleIndexPersistencyKey:         @([context indexForListStyle: self.listStyle]),
        RKListItemIndentationLevelPersistencyKey:       @(self.indentationLevel)
    };
}

@end
