//
//  RKDOCXConversionContext.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

#import <zipzap/zipzap.h>

NSString *RKDOCXConversionContextRelationshipTypeName = @"Type";
NSString *RKDOCXConversionContextRelationshipIdentifierName = @"ID";

@interface RKDOCXConversionContext ()
{
	NSMutableDictionary *_files;
}
@end

@implementation RKDOCXConversionContext

- (id)initWithDocument:(RKDocument *)document
{
	self = [self init];
	
	if (self) {
		_files = [NSMutableDictionary new];
		_documentRelationships = [NSDictionary new];
		_document = document;
	}
	
	return self;
}

- (NSData *)docxRepresentation
{
	ZZMutableArchive *archive = [[ZZMutableArchive alloc] initWithData:[NSMutableData new] encoding:NSUTF8StringEncoding];
	NSMutableArray *entries = [NSMutableArray new];
	
	[_files enumerateKeysAndObjectsUsingBlock: ^(NSString* filename, NSData* file, BOOL *stop) {
		[entries addObject: [ZZArchiveEntry archiveEntryWithFileName:filename compress:YES dataBlock:^(NSError** error) {
			return file;
		}]];
	}];
	
	[archive updateEntries:entries error:nil];
	
	return [archive contents];
}

- (void)addDocumentPart:(NSData *)part withFilename:(NSString *)filename
{
	[_files addEntriesFromDictionary: @{filename: part}];
//	NSAssert(!_files[filename], @"Document parts may be only set once: %@ was reused.", filename);
}

- (NSUInteger)indexForRelationshipWithTarget:(NSString *)target andType:(NSString *)type
{
	NSUInteger index = 0;
	
	// Relationship exists
	if (_documentRelationships[target]) {
		index = [_documentRelationships[target] integerValue];
		return index;
	}
	
	// Create new relationship
	index = _documentRelationships.count + 1;
	NSMutableDictionary *newRelationships = [_documentRelationships mutableCopy];
	[newRelationships addEntriesFromDictionary: @{
												  target: @{
														  RKDOCXConversionContextRelationshipTypeName: type,
														  RKDOCXConversionContextRelationshipIdentifierName: [NSNumber numberWithInteger: index]
														  }
												  }];
	_documentRelationships = newRelationships;
	
	return index;
}

@end
