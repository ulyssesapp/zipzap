//
//  RKReferenceTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@implementation XCTestCase (RKReferenceTest)

-(NSString *)loadTestDocument:(NSString *)name
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:@"rtf" subdirectory:@"Test Data"];
    NSString *content;
    
    XCTAssertNotNil(url, @"Cannot build URL");
    
	NSError *error;
    content = [NSString stringWithContentsOfURL:url usedEncoding:NULL error:&error];
	XCTAssertNotNil(content, @"Load failed with error: %@", error);
    
    return content;
}

- (NSString *)normalizeRTFString:(NSString *)rtf
{
    NSString *noNewlines = [rtf stringByReplacingOccurrencesOfString:@"\n" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    NSString *noLinefeeds = [noNewlines stringByReplacingOccurrencesOfString:@"\r" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [noNewlines length])];
    NSString *noTabs = [noLinefeeds stringByReplacingOccurrencesOfString:@"\t" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [noLinefeeds length])];
    NSString *noMultiSpaces = [noTabs stringByReplacingOccurrencesOfString:@"  " withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [noTabs length])];
	
    return [noMultiSpaces stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

- (void)assertGeneratedRTFString:(NSString *)generated withExpectedString:(NSString *)expected filename:(NSString *)filename
{
    NSString *normalizedGenerated = [self normalizeRTFString: generated];
    NSString *normalizedExpected = [self normalizeRTFString: expected];
    
    XCTAssertTrue([normalizedGenerated isEqualToString: normalizedExpected], @"Unexpected RTF conversion.");
	if (![normalizedGenerated isEqualToString: normalizedExpected]) {
		NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath: NSTemporaryDirectory()];
		temporaryDirectoryURL = [temporaryDirectoryURL URLByAppendingPathComponent: @"rtfkit-rtf-test-verification"];
		
		[NSFileManager.defaultManager createDirectoryAtURL:temporaryDirectoryURL withIntermediateDirectories:YES attributes:nil error:NULL];
		
		[generated writeToURL:[[temporaryDirectoryURL URLByAppendingPathComponent: filename] URLByAppendingPathExtension: @"rtf"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
		[expected writeToURL:[[temporaryDirectoryURL URLByAppendingPathComponent: [filename stringByAppendingString: @"-expected"]] URLByAppendingPathExtension: @"rtf"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
		
		NSLog(@"\n\n-----------------\n\nTest failed. Output written to:\n%@\n\n", temporaryDirectoryURL.path);
	}
	
    if (![normalizedGenerated isEqual: normalizedExpected])
        return;
}

- (void)assertRTF:(NSData *)rtf withTestDocument:(NSString *)name
{
    NSString *rtfContent = [[NSString alloc] initWithData:rtf encoding:NSASCIIStringEncoding];
    NSString *testContent = [self loadTestDocument: name];
    
    NSLog(@"Testing with File %@", name);
    
    return [self assertGeneratedRTFString:rtfContent withExpectedString:testContent filename:name];
}

@end
