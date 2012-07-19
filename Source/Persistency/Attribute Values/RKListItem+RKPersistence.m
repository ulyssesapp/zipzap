//
//  RKListItem+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItem+RKPersistence.h"
#import "RKPersistenceContext+PrivateStorageAccessors.h"

NSString *RKListItemListStyleIndexPersistenceKey = @"listStyle";
NSString *RKListItemIndentationLevelPersistenceKey = @"indentationLevel";

@implementation RKListItem (RKPersistence)

+ (id<RKPersistence>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSUInteger indentationLevel = [[propertyList objectForKey: RKListItemIndentationLevelPersistenceKey] unsignedIntegerValue];
    RKListStyle *listStyle = [context listStyleForIndex: [[propertyList objectForKey: RKListItemListStyleIndexPersistenceKey] unsignedIntegerValue]];
    if (!listStyle)
        return nil;
    
    RKListItem *listItem = [RKListItem listItemWithStyle:listStyle indentationLevel:indentationLevel];
    
    return listItem;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithUnsignedInteger: [context indexForListStyle: self.listStyle]],      RKListItemListStyleIndexPersistenceKey,
            [NSNumber numberWithUnsignedInteger: self.indentationLevel],                            RKListItemIndentationLevelPersistenceKey,
           nil];
}

@end
