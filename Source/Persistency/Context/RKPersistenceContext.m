//
//  RKPersistenceContext.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPersistenceContext.h"
#import "RKListStyle+RKPersistence.h"

NSString *RKPersistenceContextFileWrappersPersistenceKey        = @"fileWrappers";
NSString *RKPersistenceContextListStylesPersistenceKey          = @"listStyles";

NSString *NSFileWrapperDataPersistenceKey                       = @"data";
NSString *NSFileWrapperFileNamePersistenceKey                   = @"filename";

@interface RKPersistenceContext ()
{
    NSMutableArray *_fileWrappers;
    NSMutableArray *_listStyles;
    NSMutableSet *_uniqueObjects;
}

@end

@implementation RKPersistenceContext

- (id)init
{
    self = [super init];
    
    if (self) {
        _fileWrappers = [NSMutableArray new];
        _listStyles = [NSMutableArray new];
        _uniqueObjects = [NSMutableSet new];
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

- (BOOL)registerUniqueObject:(id)object
{
    if ([_uniqueObjects containsObject: object])
        return YES;
    
    [_uniqueObjects addObject: object];
    return NO;
}


#pragma mark - Persistence

- (id)propertyListRepresentation
{
    // Serialize file wrappers
    NSMutableArray *serializedFileWrapper = [NSMutableArray new];
    
    for (NSFileWrapper *fileWrapper in _fileWrappers)
        [serializedFileWrapper addObject: @{
            NSFileWrapperDataPersistenceKey:       fileWrapper.regularFileContents,
            NSFileWrapperFileNamePersistenceKey:   fileWrapper.filename ?: (fileWrapper.preferredFilename ?: @"")
         }];

    // Serialize list styles
    NSMutableArray *serializedListStyles = [NSMutableArray new];
    
    for (RKListStyle *listStyle in _listStyles)
        [serializedListStyles addObject: [listStyle propertyListRepresentationUsingContext: self]];
    
    return @{
        RKPersistenceContextFileWrappersPersistenceKey: serializedFileWrapper,
        RKPersistenceContextListStylesPersistenceKey:   serializedListStyles
    };
}

- (id)initWithPropertyListRepresentation:(id)propertyList error:(NSError **)error
{
    self = [self init];
    
    if (self) {
        // De-serialize file wrapper
        for (NSDictionary *serializedFileWrapper in propertyList[RKPersistenceContextFileWrappersPersistenceKey]) {
            NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initRegularFileWithContents: serializedFileWrapper[NSFileWrapperDataPersistenceKey]];
            fileWrapper.filename = serializedFileWrapper[NSFileWrapperFileNamePersistenceKey];
            
            [_fileWrappers addObject: fileWrapper];
        }
        
        // De-serialize list styles
        for (id serializedListStyle in propertyList[RKPersistenceContextListStylesPersistenceKey])
            [_listStyles addObject: [[RKListStyle alloc] initWithPropertyList:serializedListStyle context:self error:error]];
    }
        
    return self;
}

@end
