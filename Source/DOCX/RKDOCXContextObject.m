//
//  RSDOCXContextObject.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXContextObject.h"
#import <zipzap/zipzap.h>

@interface RKDOCXContextObject ()
{
	NSMutableDictionary *_files;
}
@end

@implementation RKDOCXContextObject

- (id)init
{
	self = [super init];
	
	if (self) {
		_files = [NSMutableDictionary new];
		_documentRelationships = [NSDictionary new];
	}
	
	return self;
}

- (id)initWithDocument:(RKDocument *)initialDocument
{
	self = [self init];
	
	if (self)
		_document = initialDocument;
	
	return self;
}

- (NSData *)docxRepresentation
{
	ZZMutableArchive *archive = [[ZZMutableArchive alloc] initWithData:[NSMutableData new] encoding:NSUTF8StringEncoding];
	NSMutableArray *entries = [NSMutableArray new];
	
	for (NSString* filename in _files) {
		[entries addObject: [ZZArchiveEntry archiveEntryWithFileName:filename compress:YES dataBlock:^(NSError** error) {
			return [_files objectForKey: filename];
		}]];
	}
	
	[archive updateEntries:entries error:nil];
	
	return [archive contents];
}

- (void)addDocumentPart:(NSData *)part withFilename:(NSString *)filename
{
	[_files addEntriesFromDictionary: @{filename: part}];
}

- (void)addDocumentRelationshipWithTarget:(NSString *)target forRId:(NSString *)RId
{
	NSMutableDictionary *newRelationships = [_documentRelationships mutableCopy];
	[newRelationships addEntriesFromDictionary: @{target: RId}];
	_documentRelationships = newRelationships;
}

@end
