//
//  RKDOCXDocumentPropertiesWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 10.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXDocumentPropertiesWriterTest : XCTestCase

@end

@implementation RKDOCXDocumentPropertiesWriterTest

- (void)testCoreProperties
{
	RKDocument *document = [[RKDocument alloc] init];
	NSDate *date = [NSDate dateWithTimeIntervalSince1970: 0];
	NSDictionary *metadata = @{NSTitleDocumentAttribute: @"Title",
							   NSSubjectDocumentAttribute: @"Subject",
							   NSAuthorDocumentAttribute: @"Author",
							   NSKeywordsDocumentAttribute: @[@"Keyword1", @"Keyword2"],
							   NSEditorDocumentAttribute: @"Editor",
							   NSCreationTimeDocumentAttribute: date,
							   NSModificationTimeDocumentAttribute: date,
							   NSCategoryDocumentAttribute: @"Test Document"};
	document.metadata = metadata;
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"coreproperties"];
}

@end
