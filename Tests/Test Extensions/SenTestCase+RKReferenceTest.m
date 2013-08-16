//
//  RKReferenceTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@implementation SenTestCase (RKReferenceTest)

-(NSString *)loadTestDocument:(NSString *)name
{
	NSURL *url = [[NSBundle bundleForClass: [self class]] URLForResource:name withExtension:@"rtf" subdirectory:@"Test Data"];
    NSString *content;
    
    STAssertNotNil(url, @"Cannot build URL");
    
	NSError *error;
    content = [NSString stringWithContentsOfURL:url usedEncoding:NULL error:&error];
	STAssertNotNil(content, @"Load failed with error: %@", error);
    
    return content;
}

- (NSString *)normalizeRTFString:(NSString *)rtf
{
    NSString *noNewlines = [rtf stringByReplacingOccurrencesOfString:@"\n" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    NSString *noLinefeeds = [noNewlines stringByReplacingOccurrencesOfString:@"\r" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    NSString *noTabs = [noLinefeeds stringByReplacingOccurrencesOfString:@"\t" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    NSString *noMultiSpaces = [noTabs stringByReplacingOccurrencesOfString:@"  " withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [rtf length])];
    
    return [noMultiSpaces stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

- (void)assertGeneratedRTFString:(NSString *)generated withExpectedString:(NSString *)expected
{
    NSString *normalizedGenerated = [self normalizeRTFString: generated];
    NSString *normalizedExpected = [self normalizeRTFString: expected];
    
    STAssertTrue([normalizedGenerated isEqualToString: normalizedExpected], @"Unexpected RTF conversion.", normalizedGenerated, normalizedExpected);
	if (![normalizedGenerated isEqualToString: normalizedExpected])
		NSLog(@"\n\n%@\n\nShould be:\n\n%@\n\n", generated, expected);
	
    if (![normalizedGenerated isEqual: normalizedExpected])
        return;
}

- (void)assertRTF:(NSData *)rtf withTestDocument:(NSString *)name
{
    NSString *rtfContent = [[NSString alloc] initWithData:rtf encoding:NSASCIIStringEncoding];
    NSString *testContent = [self loadTestDocument: name];
    
    NSLog(@"Testing with File %@", name);
    
    return [self assertGeneratedRTFString:rtfContent withExpectedString:testContent];
}

@end
