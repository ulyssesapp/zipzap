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
	ZZMutableArchive *_archive;
}
@end

@implementation RKDOCXContextObject

- (id)init
{
	self = [super init];
	
	if (self) {
		_archive = [[ZZMutableArchive alloc] initWithData:[NSMutableData new] encoding:NSUTF8StringEncoding];
	}
	
	return self;
}

- (void)addDocumentPart:(NSData *)part withFilename:(NSString *)filename
{
	[_archive updateEntries:@[[ZZArchiveEntry archiveEntryWithFileName:filename compress:YES dataBlock:^(NSError** error) {
		return part;
	}]] error:nil];
}

@end
