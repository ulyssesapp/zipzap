//
//  RKDOCXFootnotesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 16.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFootnotesWriter.h"

#import "RKDOCXAttributedStringWriter.h"
#import "RKDOCXRunWriter.h"

// Root element name
NSString *RKDOCXFootnotesRootElementName						= @"w:footnotes";

// Relationship type and target
NSString *RKDOCXFootnotesRelationshipType						= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/footnotes";
NSString *RKDOCXFootnotesRelationshipTarget						= @"footnotes.xml";

// Elements
NSString *RKDOCXFootnotesContinuationSeparatorAttributeValue	= @"continuationSeparator";
NSString *RKDOCXFootnotesSeparatorAttributeValue				= @"separator";
NSString *RKDOCXFootnotesFootnoteElementName					= @"w:footnote";
NSString *RKDOCXFootnotesFootnoteRefElementName						= @"w:footnoteRef";
NSString *RKDOCXFootnotesFootnoteReferenceElementName			= @"w:footnoteReference";

// Attributes
NSString *RKDOCXFootnotesTypeAttributeName						= @"w:type";
NSString *RKDOCXFootnotesIdentifierAttributeName				= @"w:id";

NSString *RKDOCXFootnoteReferenceAttributeName					= @"RKDOCXFootnoteReference";

@implementation RKDOCXFootnotesWriter

+ (void)buildFootnotesUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.footnotes.count)
		return;
	
	// Namespaces
	NSDictionary *namespaces = @{
								 @"xmlns:wpc": @"http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
								 @"xmlns:mo": @"http://schemas.microsoft.com/office/mac/office/2008/main",
								 @"xmlns:mc": @"http://schemas.openxmlformats.org/markup-compatibility/2006",
								 @"xmlns:mv": @"urn:schemas-microsoft-com:mac:vml",
								 @"xmlns:o": @"urn:schemas-microsoft-com:office:office",
								 @"xmlns:r": @"http://schemas.openxmlformats.org/officeDocument/2006/relationships",
								 @"xmlns:m": @"http://schemas.openxmlformats.org/officeDocument/2006/math",
								 @"xmlns:v": @"urn:schemas-microsoft-com:vml",
								 @"xmlns:wp14": @"http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
								 @"xmlns:wp": @"http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
								 @"xmlns:w10": @"urn:schemas-microsoft-com:office:word",
								 @"xmlns:w": @"http://schemas.openxmlformats.org/wordprocessingml/2006/main",
								 @"xmlns:w14": @"http://schemas.microsoft.com/office/word/2010/wordml",
								 @"xmlns:w15": @"http://schemas.microsoft.com/office/word/2012/wordml",
								 @"xmlns:wpg": @"http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
								 @"xmlns:wpi": @"http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
								 @"xmlns:wne": @"http://schemas.microsoft.com/office/word/2006/wordml",
								 @"xmlns:wps": @"http://schemas.microsoft.com/office/word/2010/wordprocessingShape",
								 @"mc:Ignorable": @"w14 w15 wp14"
								 };
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:RKDOCXFootnotesRootElementName namespaces:namespaces];
	
	// Separator
	[document.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesSeparatorAttributeValue identifier:@"0"]];
	
	// Continuation Separator
	[document.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesContinuationSeparatorAttributeValue identifier:@"1"]];
	
	// Footnotes
	for (NSNumber *index in context.footnotes) {
		[document.rootElement addChild: [NSXMLElement elementWithName:RKDOCXFootnotesFootnoteElementName children:context.footnotes[index] attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:index.stringValue]]]];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXFootnotesRelationshipTarget andType:RKDOCXFootnotesRelationshipType];
	[context addDocumentPart:[document XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXFootnotesFilename];
}

+ (NSXMLElement *)footnoteReferenceElementForFootnoteString:(NSAttributedString *)footnoteString inRunElement:(NSXMLElement *)runElement usingContext:(RKDOCXConversionContext *)context
{
	if (!footnoteString)
		return nil;
	
	NSMutableArray *footNoteProperties = [NSMutableArray new];
	[footnoteString enumerateAttributesInRange:NSMakeRange(0, footnoteString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		[footNoteProperties addObjectsFromArray: [RKDOCXRunWriter propertyElementsForAttributes:attrs usingContext:context]];
	}];
	
	NSMutableAttributedString *footnoteStringWithReferenceMark = [[NSMutableAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKDOCXFootnoteReferenceAttributeName: @YES}];
	[footnoteStringWithReferenceMark appendAttributedString: footnoteString];
	
	NSArray *footnoteContent = [RKDOCXAttributedStringWriter processAttributedString:footnoteStringWithReferenceMark usingContext:context];
	NSUInteger footnoteIndex = [context indexForFootnoteContent: footnoteContent];
	
	[runElement addChild: [NSXMLElement elementWithName:RKDOCXFootnotesFootnoteReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:@(footnoteIndex).stringValue]]]];
	return runElement;
}

+ (NSXMLElement *)footnoteReferenceMarkWithRunElementName:(NSString *)runElementName runPropertiesElementName:(NSString *)runPropertiesElementName
{
#warning Add footnote reference style
	NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName: runPropertiesElementName];
	NSXMLElement *footnoteRefElement = [NSXMLElement elementWithName: RKDOCXFootnotesFootnoteRefElementName];
	return [NSXMLElement elementWithName:runElementName children:@[runPropertiesElement, footnoteRefElement] attributes:nil];
}

+ (NSXMLElement *)separatorElementWithName:(NSString *)separatorName identifier:(NSString *)identifier
{
	NSXMLElement *separatorElement = [NSXMLElement elementWithName: [@"w:" stringByAppendingString: separatorName]];
	NSXMLElement *runElement = [NSXMLElement elementWithName:@"w:r" children:@[separatorElement] attributes:nil];
	NSXMLElement *paragraphElement = [NSXMLElement elementWithName:@"w:p" children:@[runElement] attributes:nil];
	NSXMLElement *typeAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesTypeAttributeName stringValue:separatorName];
	NSXMLElement *identifierAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:identifier];
	return [NSXMLElement elementWithName:RKDOCXFootnotesFootnoteElementName children:@[paragraphElement] attributes:@[typeAttribute, identifierAttribute]];
}

@end
