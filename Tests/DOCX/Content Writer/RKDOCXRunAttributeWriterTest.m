//
//  RKDOCXRunAttributeWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 01.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXRunAttributeWriter.h"


@interface RKDOCXRunAttributeWriterTest : XCTestCase

@end

@implementation RKDOCXRunAttributeWriterTest

+ (NSFont *)defaultFontWithTraitMask:(NSFontTraitMask)traitMask
{
	return [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:traitMask weight:0 size:12];
}

- (void)testRunElementWithoutAttributes
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Hello World"];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLWithoutRunAttributes];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithInvalidRange
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Hello World"];
	XCTAssertThrows([RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(attributedString.length, 1)], @"Invalid Range does not throw exception.");
}

- (void)testRunElementWithEmptyRange
{
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: @"Hello World"];
	XCTAssertNil([RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:nil range:NSMakeRange(0, 0)]);
}

- (void)testRunElementWithFontSizeAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Helvetica" traits:0 weight:0 size:42];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLElementWithString:@"Hello World" runProperties:@[[NSXMLElement elementWithName:@"w:rFonts" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:ascii" stringValue:@"Helvetica"], [NSXMLElement attributeWithName:@"w:cs" stringValue:@"Helvetica"], [NSXMLElement attributeWithName:@"w:eastAsia" stringValue:@"Helvetica"], [NSXMLElement attributeWithName:@"w:hAnsi" stringValue:@"Helvetica"]]], [NSXMLElement elementWithName:@"w:sz" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"84"]]], [NSXMLElement elementWithName:@"w:szCs" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"84"]]]]];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithFontNameAttribute
{
	NSFont *font = [NSFont fontWithName:@"Papyrus" size:12];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLElementWithString:@"Hello World" runProperties:@[[NSXMLElement elementWithName:@"w:rFonts" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:ascii" stringValue:@"Papyrus"], [NSXMLElement attributeWithName:@"w:cs" stringValue:@"Papyrus"], [NSXMLElement attributeWithName:@"w:eastAsia" stringValue:@"Papyrus"], [NSXMLElement attributeWithName:@"w:hAnsi" stringValue:@"Papyrus"]]], [NSXMLElement elementWithName:@"w:sz" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"24"]]], [NSXMLElement elementWithName:@"w:szCs" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"24"]]]]];
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

- (void)testRunElementWithBoldItalicFontNameAttribute
{
	NSFont *font = [NSFontManager.sharedFontManager fontWithFamily:@"Arial" traits:(NSBoldFontMask | NSItalicFontMask) weight:0 size:12];
	NSDictionary *attributes = @{NSFontAttributeName: font};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Hello World" attributes:attributes];
	NSXMLElement *generated = [RKDOCXRunAttributeWriter runElementForAttributedString:attributedString attributes:attributes range:NSMakeRange(0, attributedString.length)];
	NSXMLElement *expected = [self.class expectedXMLElementWithString:@"Hello World" runProperties:@[[NSXMLElement elementWithName: @"w:i"], [NSXMLElement elementWithName: @"w:b"], [NSXMLElement elementWithName:@"w:rFonts" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:ascii" stringValue:@"Arial"], [NSXMLElement attributeWithName:@"w:cs" stringValue:@"Arial"], [NSXMLElement attributeWithName:@"w:eastAsia" stringValue:@"Arial"], [NSXMLElement attributeWithName:@"w:hAnsi" stringValue:@"Arial"]]], [NSXMLElement elementWithName:@"w:sz" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"24"]]], [NSXMLElement elementWithName:@"w:szCs" children:nil attributes:@[[NSXMLElement attributeWithName:@"w:val" stringValue:@"24"]]]]];
	
	XCTAssertEqualObjects(generated, expected, @"Generated XML element does not match.");
}

+ (NSXMLElement *)expectedXMLWithoutRunAttributes
{
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t" stringValue:@"Hello World"];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	
	return runElement;
}

+ (NSXMLElement *)expectedXMLElementWithString:(NSString *)string runProperties:(NSArray *)runProperties
{
	
	NSXMLElement *runElement = [NSXMLElement elementWithName: @"w:r"];
	NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName: @"w:rPr"];
	[runElement addChild: runPropertiesElement];
	
	for (NSXMLElement* property in runProperties)
		[runPropertiesElement addChild: property];
	
	NSXMLElement *textElement = [NSXMLElement elementWithName: @"w:t" stringValue:string];
	[textElement addAttribute: [NSXMLElement attributeWithName:@"xml:space" stringValue:@"preserve"]];
	[runElement addChild: textElement];
	
	return runElement;
}

@end
