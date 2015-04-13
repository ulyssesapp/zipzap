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
	NSDictionary *metadata = @{RKTitleDocumentAttribute: @"Title",
							   RKSubjectDocumentAttribute: @"Subject",
							   RKAuthorDocumentAttribute: @"Author",
							   RKKeywordsDocumentAttribute: @[@"Keyword1", @"Keyword2"],
							   RKEditorDocumentAttribute: @"Editor",
							   RKCreationTimeDocumentAttribute: date,
							   RKModificationTimeDocumentAttribute: date,
							   RKCategoryDocumentAttribute: @"Test Document"};
	document.metadata = metadata;
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"coreproperties"];
}

@end
