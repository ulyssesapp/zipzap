//
//  NSStringHyphenationTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSStringHyphenationTest.h"
#import "NSString+Hyphenation.h"

@implementation NSStringHyphenationTest

- (void)testHyphenation
{
	NSLocale *testLocaleEn = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
	NSLocale *testLocaleDe = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
	
	NSString *enString = @"Our featureset supports hyphenation!";
	XCTAssertEqualObjects([enString stringByHyphenatingWithCharacter:@"-" locale:testLocaleEn inRange:NSMakeRange(0, enString.length) ], @"Our fea-ture-set sup-ports hy-phen-ation!", @"Invalid hyphenation applied");

	NSString *deString = @"Großartig, unser Programm unterstützt Silbentrennung!";
	XCTAssertEqualObjects([deString stringByHyphenatingWithCharacter:@"-" locale:testLocaleDe inRange:NSMakeRange(0, deString.length) ], @"Groß-ar-tig, un-ser Pro-gramm un-ter-stützt Sil-ben-tren-nung!", @"Invalid hyphenation applied");
}

@end
