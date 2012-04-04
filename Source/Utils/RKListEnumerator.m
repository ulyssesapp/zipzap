//
//  RKListEnumerator.m
//  RTFKit
//
//  Created by Friedrich Gräter on 04.04.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListEnumerator.h"
#import "RKResourcePool.h"
#import "RKListStyle+WriterAdditions.h"

@interface RKListEnumerator ()
{
    RKResourcePool *resourcePool;
}

@end

@implementation RKListEnumerator

- (id)init
{
    self = [super init];
    
    if (self) {
        resourcePool = [RKResourcePool new];
    }
    
    return self;
}

- (void)resetCounterOfList:(RKListStyle *)listStyle
{
    [resourcePool resetCounterOfList: listStyle];
}

- (NSString *)markerForListItem:(RKListItem *)listItem
{
    NSArray *itemNumbers = [resourcePool incrementItemNumbersForListLevel:listItem.indentationLevel ofList:listItem.listStyle];
    
    return [listItem.listStyle markerForItemNumbers: itemNumbers];
}

@end
