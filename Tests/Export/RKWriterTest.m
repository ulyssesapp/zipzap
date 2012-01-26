//
//  RKWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKWriterTest.h"
#import "RKWriter.h"
#import "RKDocument.h"

@interface RKWriterTest()

/*!
 @abstract Loads a document from the test bundle
 */
-(NSString *)loadTestDocument:(NSString *)name;

/*!
 @abstract Creates a variant of a string that is free of newlines and tabs
 */
- (NSString *)normalizeRTFString:(NSString *)rtf;

/*!
 @abstract Compares the content of two RTF files. Newlines and tabs are ignored
 */
- (bool)compareRTFString:(NSString *)stringA withString:(NSString *)stringB;

/*!
 @abstract Loads a test document from TestData and compares it charwise with the given RTF output. Ignores newlines and tabs.
 */
- (bool)compareRTF:(NSData *)rtf withTestDocument:(NSString *)name;

@end

@implementation RKWriterTest

#pragma mark - Test helper

-(NSString *)loadTestDocument:(NSString *)name
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:@"rtf" subdirectory:@"Test Data"];
    NSString *content;
    
	if (url) {
		__autoreleasing NSError *error;
        content = [NSString stringWithContentsOfURL:url usedEncoding:NULL error:&error];
		STAssertNotNil(content, @"Load failed with error: %@", error);
	}
    
    return content;
}

- (NSString *)normalizeRTFString:(NSString *)rtf
{
    NSString *noNewlines = [rtf stringByReplacingOccurrencesOfString:@"\n" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    NSString *noLinefeeds = [noNewlines stringByReplacingOccurrencesOfString:@"\r" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    NSString *noTabs = [noLinefeeds stringByReplacingOccurrencesOfString:@"\t" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];

    return noTabs;
}

- (bool)compareRTFString:(NSString *)stringA withString:(NSString *)stringB
{
    return [[self normalizeRTFString: stringA] isEqualToString: [self normalizeRTFString: stringB]];
}

- (bool)compareRTF:(NSData *)rtf withTestDocument:(NSString *)name
{
    NSString *rtfContent = [[NSString alloc] initWithData:rtf encoding:NSASCIIStringEncoding];
    NSString *testContent = [self loadTestDocument: name];
    
    return [self compareRTFString:rtfContent withString:testContent];
}

#pragma mark -

- (void)testGeneratingEmptyRTFDocument
{
    RKDocument *document = [RKDocument documentWithAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    NSData *converted = [document RTF];
                            
    STAssertTrue([self compareRTF:converted withTestDocument:@"empty"], @"Invalid empty document creation");
}

@end
