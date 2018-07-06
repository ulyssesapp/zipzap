//
//  RKDOCXListWriterTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 24.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "XCTestCase+DOCX.h"
#import "RKColor.h"
#import "RKFont.h"

@interface RKDOCXListWriterTest : XCTestCase

@end

@implementation RKDOCXListWriterTest

- (void)testTwoListItems
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d.", @"%*%d."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"First list item: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Second list item: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];

	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"list"];
}

- (void)testMultipleLists
{
	RKListStyle *listStyleA = [RKListStyle listStyleWithLevelFormats:@[@"%d.", @"%*%d."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}]];
	RKListStyle *listStyleB = [RKListStyle listStyleWithLevelFormats:@[@"%d.", @"%*%d."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}]];
	XCTAssertEqualObjects(listStyleA, listStyleB);
	XCTAssertNotEqual(listStyleA, listStyleB);
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"First list, first item – enumerator should be 1"] withStyle:listStyleA withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"First list, second item – enumerator should be be 2"] withStyle:listStyleA withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendAttributedString: [[NSAttributedString alloc] initWithString: @"Separating paragraph\n"]];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Second list, first item – enumerator should be 1 again"] withStyle:listStyleB withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"Second list, second item – enumerator should be be 2"] withStyle:listStyleB withIndentationLevel:0 resetIndex:NSUIntegerMax];

	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"multiple-lists"];
}

- (void)testMultipleListStyles
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d.", @"%*%d", @"%a)", @"-"] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}, @{RKListStyleMarkerLocationKey: @25, RKListStyleMarkerWidthKey: @35}]];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"A"] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"AA"] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"AB"] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"ABA"] withStyle:listStyle withIndentationLevel:2 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"AC"] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"B"] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"C"] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"CA"] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"CAA"] withStyle:listStyle withIndentationLevel:2 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"CAAA"] withStyle:listStyle withIndentationLevel:3 resetIndex:NSUIntegerMax];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"multipleliststyles"];
}

- (void)testDifferentStartNumbers
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%A.", @"%d.", @"%R."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1"] withStyle:listStyle withIndentationLevel:0 resetIndex:8];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 2"] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.1"] withStyle:listStyle withIndentationLevel:1 resetIndex:42];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.2"] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.1.1"] withStyle:listStyle withIndentationLevel:2 resetIndex:1337];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 1.1.2"] withStyle:listStyle withIndentationLevel:2 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 3"] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 3.1"] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString: @"List item 3.2"] withStyle:listStyle withIndentationLevel:1 resetIndex:9];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"listswithstartnumbers"];
}

- (void)testListWithRunAttribute
{
	RKListStyle *listStyle = [RKListStyle listStyleWithLevelFormats:@[@"%d)", @"%d)", @"%d)"] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	CTFontRef font = CTFontCreateCopyWithSymbolicTraits(CTFontCreateWithName((__bridge CFStringRef)@"Arial", 12, NULL), 0.0, NULL, kCTFontItalicTrait | kCTFontBoldTrait, kCTFontBoldTrait);
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString:@"This list item is blue." attributes:@{RKForegroundColorAttributeName: [RKColor colorWithRed:0 green:0 blue:1 alpha:0]}] withStyle:listStyle withIndentationLevel:0 resetIndex:NSUIntegerMax];
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString:@"This list item is bold." attributes:@{RKFontAttributeName: (__bridge RKFont *)font}] withStyle:listStyle withIndentationLevel:1 resetIndex:NSUIntegerMax];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"listwithrunattributes"];
}

- (void)testListWithParagraphAttribute
{
	RKListStyle *listStyleA = [RKListStyle listStyleWithLevelFormats:@[@"%d)", @"%d)", @"%d)"] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}]];
	RKListStyle *listStyleB = [RKListStyle listStyleWithLevelFormats:@[@"%A.", @"%A.", @"%A."] styles:@[@{RKListStyleMarkerLocationKey: @10, RKListStyleMarkerWidthKey: @20}, @{RKListStyleMarkerLocationKey: @15, RKListStyleMarkerWidthKey: @25}, @{RKListStyleMarkerLocationKey: @20, RKListStyleMarkerWidthKey: @30}]];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: @""];
	NSMutableParagraphStyle *paragraphStyleA = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyleA.alignment = NSTextAlignmentCenter;
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString:@"This is centered text: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." attributes:@{RKParagraphStyleAttributeName: paragraphStyleA}] withStyle:listStyleA withIndentationLevel:0 resetIndex:NSUIntegerMax];
	NSMutableParagraphStyle *paragraphStyleB = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyleB.alignment = NSTextAlignmentJustified;
	[attributedString appendListItem:[[NSAttributedString alloc] initWithString:@"This is justified text: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua." attributes:@{RKParagraphStyleAttributeName: paragraphStyleB}] withStyle:listStyleB withIndentationLevel:0 resetIndex:NSUIntegerMax];
	
	RKDocument *document = [[RKDocument alloc] initWithAttributedString: attributedString];
	
	[self assertDOCX:document withTestDocument:@"listwithparagraphattributes"];
}

@end
