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
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Footnote\ufffc and Endnote\ufffc Test"];
	[attributedString addAttribute:RKFootnoteAttributeName value:[[NSAttributedString alloc] initWithString:@"This is the footnote content."] range:NSMakeRange(8, 1)];
	[attributedString addAttribute:RKEndnoteAttributeName value:[[NSAttributedString alloc] initWithString:@"This is the endnote content."] range:NSMakeRange(21, 1)];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	document.hyphenationEnabled = YES;
	document.footnotePlacement = RKFootnotePlacementSectionEnd;
	document.footnoteEnumerationStyle = RKFootnoteEnumerationAlphabeticLowerCase;
	document.footnoteEnumerationPolicy = RKFootnoteContinuousEnumeration;
	document.endnotePlacement = RKEndnotePlacementSectionEnd;
	document.endnoteEnumerationStyle = RKFootnoteEnumerationChicagoManual;
	document.endnoteEnumerationPolicy = RKFootnoteEnumerationPerSection;
	document.twoSided = YES;
	
	[self assertDOCX:document withTestDocument:@"settings"];
}

@end
