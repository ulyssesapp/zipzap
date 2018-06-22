//
//  RKListEnumerator.m
//  RTFKit
//
//  Created by Friedrich Gräter on 04.04.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListCounter.h"
#import "RKResourcePool.h"
#import "RKListStyle+WriterAdditions.h"

@interface RKListCounter ()
{
    NSMutableDictionary *_listStyles;
	NSMutableDictionary *_listItemIndices;
}

@end

@implementation RKListCounter

- (id)init
{
    self = [super init];
    
    if (self) {
		_listStyles = [NSMutableDictionary new];
		_listItemIndices = [NSMutableDictionary new];
    }
    
    return self;
}

- (id)initWithListStyles:(NSDictionary *)listStyles itemIndices:(NSDictionary *)itemIndices
{
	self = [self init];
	
	if (self) {
		_listStyles = [listStyles mutableCopy];
		_listItemIndices = [itemIndices mutableCopy];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[RKListCounter alloc] initWithListStyles:_listStyles itemIndices:_listItemIndices];
}

+ (NSUInteger)maximumListStyleIndex
{
    // According to the RTF specification Word seems to allow only numbers between 1 and 31680
    return 31000;
}

- (NSNumber *)unusedListIndex
{
    if (!RKDocument.isUsingRandomListIdentifier) {
        // In testing mode we have to use stable IDs
        return @(_listStyles.count + 1);
    }
	
    NSNumber *listIndex;
    NSUInteger maximumIndex = RKListCounter.maximumListStyleIndex;
    
    if (_listStyles.count < (maximumIndex / 50)) {
        // Create a random index unless we have only 1/50 of random numbers used
        do {
            listIndex = @((random() % (maximumIndex - 1)) + 1);
        }while ([_listStyles objectForKey: listIndex]);
    }
    else {
        // Otherwise we break the Cut&Paste bug-to-bug compatibility with Word to prevent bad perfomance and crashes and create linear numbers on top of the maximum...
        NSArray *sortedIndices = [_listStyles.allKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"unsignedIntegerValue" ascending:NO]]];
        listIndex = @([sortedIndices.lastObject unsignedIntegerValue] + 1);
    }
	
    return listIndex;
}

- (NSUInteger)indexOfListStyle:(RKListStyle *)listStyle
{
	__block NSUInteger key = NSNotFound;
	[_listStyles enumerateKeysAndObjectsUsingBlock:^(NSNumber *currentKey, RKListStyle *currentListStyle, BOOL *stop) {
		if (listStyle == currentListStyle) {
			key = currentKey.unsignedIntegerValue;
			*stop = YES;
		}
	}];
	
    if (key == NSNotFound) {
        NSNumber *listIndex = [self unusedListIndex];
        [_listStyles setObject:listStyle forKey:listIndex];
        [_listItemIndices setObject:[NSMutableArray new] forKey:listIndex];
		
        return listIndex.unsignedIntegerValue;
    }
    
    return key;
}

- (NSDictionary *)listStyles
{
    return _listStyles;
}

- (void)resetCounterOfList:(RKListStyle *)listStyle
{
    NSArray *keys = [_listStyles allKeysForObject: listStyle];
    
    // Style unknown
    if (!keys.count)
        return;
    
    // Reset style
    _listItemIndices[keys[0]] = [NSMutableArray new];
}

- (NSArray *)incrementItemNumbersForListLevel:(NSUInteger)level ofList:(RKListStyle *)textList resetIndex:(NSUInteger)resetIndex
{
    NSUInteger listIndex = [self indexOfListStyle: textList];
    NSMutableArray *itemNumbers = _listItemIndices[@(listIndex)];
    
    // Truncate nested item numbers, if a higher item number is increased
    if (level + 1 < itemNumbers.count) {
        [itemNumbers removeObjectsInRange: NSMakeRange(level + 1, itemNumbers.count - level - 1)];
    }
    
    if (level >= itemNumbers.count) {
        // Fill with 1 if requested, nested list is deeper nested than the current list length
        for (NSUInteger position = itemNumbers.count; position < level + 1; position ++) {
            [itemNumbers addObject: @([textList startNumberForLevel: position])];
        }
    }
    else {
        // Increment requested counter
        NSUInteger currentItemNumber = [itemNumbers[level] unsignedIntegerValue] + 1;
        itemNumbers[level] = @(currentItemNumber);
    }
	
	// Override item counter if needed
	if (resetIndex != NSUIntegerMax)
		itemNumbers[level] = @(resetIndex);
	
    return [itemNumbers copy];
}

- (NSString *)markerForListItem:(RKListItem *)listItem
{
	NSArray *itemNumbers = [self incrementItemNumbersForListLevel:listItem.indentationLevel ofList:listItem.listStyle resetIndex:listItem.resetIndex];
    return [listItem.listStyle markerForItemNumbers: itemNumbers];
}

@end
