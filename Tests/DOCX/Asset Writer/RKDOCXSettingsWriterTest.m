//
//  RKDOCXSettingsWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"

@interface RKDOCXSettingsWriterTest : XCTestCase

@end

@implementation RKDOCXSettingsWriterTest

- (void)testSettingsWithFootnoteAndEndnotePlacement
{
	RKDocument *document = [[RKDocument alloc] init];
	document.hyphenationEnabled = YES;
	document.footnotePlacement = RKFootnotePlacementSectionEnd;
	document.footnoteEnumerationStyle = RKFootnoteEnumerationAlphabeticLowerCase;
	document.footnoteEnumerationPolicy = RKFootnoteContinuousEnumeration;
	document.endnotePlacement = RKEndnotePlacementSectionEnd;
	document.endnoteEnumerationStyle = RKFootnoteEnumerationChicagoManual;
	document.endnoteEnumerationPolicy = RKFootnoteEnumerationPerSection;
	document.twoSided = YES;
	NSData *converted = [document DOCX];
	
	[self assertDOCX:converted withTestDocument:@"settings"];
}

@end
