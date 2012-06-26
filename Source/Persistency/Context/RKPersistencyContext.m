//
//  RKPersistencyContext.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPersistencyContext.h"
#import "RKListStyle+RKPersistency.h"

NSString *RKPersistencyContextFileWrappersPersistencyKey        = @"fileWrappers";
NSString *RKPersistencyContextListStylesPersistencyKey          = @"listStyles";

NSString *NSFileWrapperDataPersistencyKey                       = @"data";
NSString *NSFileWrapperFileNamePersistencyKey                   = @"filename";

@interface RKPersistencyContext ()
{
    NSMutableArray *_fileWrappers;
    NSMutableArray *_listStyles;
}

@end

@implementation RKPersistencyContext

- (id)init
{
    self = [super init];
    
    if (self) {
        _fileWrappers = [NSMutableArray new];
        _listStyles = [NSMutableArray new];
    }
    
    return self;
}

- (NSUInteger)indexForFileWrapper:(NSFileWrapper *)fileWrapper
{
    NSParameterAssert(fileWrapper.isRegularFile);
    
    NSUInteger index = [_fileWrappers indexOfObject: fileWrapper];
    
    if (index == NSNotFound) {
        index = _fileWrappers.count;
        [_fileWrappers addObject: fileWrapper];
    }
    
    return index;
}

- (NSFileWrapper *)fileWrapperForIndex:(NSUInteger)index
{
    if (index >= _fileWrappers.count)
        return nil;
    
    return [_fileWrappers objectAtIndex: index];
}

- (NSUInteger)indexForListStyle:(RKListStyle *)listStyle;
{
    NSUInteger index = [_listStyles indexOfObject: listStyle];
    
    if (index == NSNotFound) {
        index = _listStyles.count;
        [_listStyles addObject: listStyle];
    }
    
    return index;
}

- (RKListStyle *)listStyleForIndex:(NSUInteger)index
{
    if (index >= _listStyles.count)
        return nil;
    
    return [_listStyles objectAtIndex: index];
}



#pragma mark - Persistency

- (id)propertyListRepresentation
{
    // Serialize file wrappers
    NSMutableArray *serializedFileWrapper = [NSMutableArray new];
    
    for (NSFileWrapper *fileWrapper in _fileWrappers)
        [serializedFileWrapper addObject: @{
            NSFileWrapperDataPersistencyKey:        fileWrapper.regularFileContents,
            NSFileWrapperFileNamePersistencyKey:   fileWrapper.filename ?: (fileWrapper.preferredFilename ?: @"")
         }];

    // Serialize list styles
    NSMutableArray *serializedListStyles = [NSMutableArray new];
    
    for (RKListStyle *listStyle in _listStyles)
        [serializedListStyles addObject: [listStyle propertyListRepresentation]];
    
    return @{
        RKPersistencyContextFileWrappersPersistencyKey: serializedFileWrapper,
        RKPersistencyContextListStylesPersistencyKey:   serializedListStyles
    };
}

- (id)initWithPropertyListRepresentation:(id)propertyList error:(NSError **)error
{
    self = [self init];
    
    if (self) {
        // De-serialize file wrapper
        for (NSDictionary *serializedFileWrapper in propertyList[RKPersistencyContextFileWrappersPersistencyKey]) {
            NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents: serializedFileWrapper[NSFileWrapperDataPersistencyKey]];
            fileWrapper.filename = serializedFileWrapper[NSFileWrapperFileNamePersistencyKey];
            
            [_fileWrappers addObject: fileWrapper];
        }
        
        // De-serialize list styles
        for (id serializedListStyle in propertyList[RKPersistencyContextListStylesPersistencyKey])
            [_listStyles addObject: [[RKListStyle alloc] initWithPropertyList: serializedListStyle]];
    }
        
    return self;
}

@end
