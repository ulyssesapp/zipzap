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
NSString *RKDOCXEndnotesRootElementName							= @"w:endnotes";
NSString *RKDOCXFootnotesRootElementName						= @"w:footnotes";

// Relationship type and target
NSString *RKDOCXEndnotesRelationshipType						= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/endnotes";
NSString *RKDOCXEndnotesRelationshipTarget						= @"endnotes.xml";
NSString *RKDOCXFootnotesRelationshipType						= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/footnotes";
NSString *RKDOCXFootnotesRelationshipTarget						= @"footnotes.xml";

// Elements
NSString *RKDOCXFootnotesContinuationSeparatorAttributeValue	= @"continuationSeparator";
NSString *RKDOCXFootnotesSeparatorAttributeValue				= @"separator";
NSString *RKDOCXFootnotesEndnoteElementName						= @"w:endnote";
NSString *RKDOCXFootnotesEndnoteRefElementName					= @"w:endnoteRef";
NSString *RKDOCXFootnotesEndnoteReferenceElementName			= @"w:endnoteReference";
NSString *RKDOCXFootnotesFootnoteElementName					= @"w:footnote";
NSString *RKDOCXFootnotesFootnoteRefElementName					= @"w:footnoteRef";
NSString *RKDOCXFootnotesFootnoteReferenceElementName			= @"w:footnoteReference";

// Attributes
NSString *RKDOCXFootnotesTypeAttributeName						= @"w:type";
NSString *RKDOCXFootnotesIdentifierAttributeName				= @"w:id";

NSString *RKDOCXEndnoteReferenceAttributeName					= @"RKDOCXEndnoteReference";
NSString *RKDOCXFootnoteReferenceAttributeName					= @"RKDOCXFootnoteReference";

NSString *RKDOCXReferenceTypeAttributeName						= @"RKDOCXReferenceType";

@implementation RKDOCXFootnotesWriter

+ (void)buildFootnotesUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.footnotes.count && !context.endnotes.count)
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
	
	// In case of footnotes
	if (context.footnotes.count) {
		NSXMLDocument *footnotesDocument = [self basicXMLDocumentWithRootElementName:RKDOCXFootnotesRootElementName namespaces:namespaces];
		
		// Separator
		[footnotesDocument.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesSeparatorAttributeValue identifier:@"0" forEndnote:NO]];
		
		// Continuation Separator
		[footnotesDocument.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesContinuationSeparatorAttributeValue identifier:@"1" forEndnote:NO]];
		
		// Footnotes
		for (NSNumber *index in context.footnotes) {
			[footnotesDocument.rootElement addChild: [NSXMLElement elementWithName:RKDOCXFootnotesFootnoteElementName children:context.footnotes[index] attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:index.stringValue]]]];
		}
		
		[context indexForRelationshipWithTarget:RKDOCXFootnotesRelationshipTarget andType:RKDOCXFootnotesRelationshipType];
		[context addDocumentPart:[footnotesDocument XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXFootnotesFilename];
	}
	
	// In case of endnotes
	if (context.endnotes.count) {
		NSXMLDocument *endnotesDocument = [self basicXMLDocumentWithRootElementName:RKDOCXEndnotesRootElementName namespaces:namespaces];
		
		// Separator
		[endnotesDocument.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesSeparatorAttributeValue identifier:@"0" forEndnote:YES]];
		
		// Continuation Separator
		[endnotesDocument.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesSeparatorAttributeValue identifier:@"1" forEndnote:YES]];
		
		// Endnotes
		for (NSNumber *index in context.endnotes) {
			[endnotesDocument.rootElement addChild: [NSXMLElement elementWithName:RKDOCXFootnotesEndnoteElementName children:context.endnotes[index] attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:index.stringValue]]]];
		}
		
		[context indexForRelationshipWithTarget:RKDOCXEndnotesRelationshipTarget andType:RKDOCXEndnotesRelationshipType];
		[context addDocumentPart:[endnotesDocument XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXEndnotesFilename];
	}
}

+ (NSXMLElement *)referenceElementForAttributes:(NSDictionary *)attributes inRunElement:(NSXMLElement *)runElement usingContext:(RKDOCXConversionContext *)context
{
	RKDOCXReferenceType referenceType = RKDOCXNoReference;
	NSString *referenceElementName;
	NSAttributedString *referenceString;
	
	if (attributes[RKFootnoteAttributeName]) {
		referenceType = RKDOCXFootnoteReference;
		referenceElementName = RKDOCXFootnotesFootnoteReferenceElementName;
		referenceString = attributes[RKFootnoteAttributeName];
	} else if (attributes[RKEndnoteAttributeName]) {
		referenceType = RKDOCXEndnoteReference;
		referenceElementName = RKDOCXFootnotesEndnoteReferenceElementName;
		referenceString = attributes[RKEndnoteAttributeName];
	} else {
		return nil;
	}
	
	NSMutableArray *referenceProperties = [NSMutableArray new];
	[referenceString enumerateAttributesInRange:NSMakeRange(0, referenceString.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
		[referenceProperties addObjectsFromArray: [RKDOCXRunWriter propertyElementsForAttributes:attrs usingContext:context]];
	}];
	
	NSMutableAttributedString *referenceStringWithReferenceMark = [[NSMutableAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKDOCXReferenceTypeAttributeName: @(referenceType)}];
	[referenceStringWithReferenceMark appendAttributedString: referenceString];
	
	NSArray *referenceContent = [RKDOCXAttributedStringWriter processAttributedString:referenceStringWithReferenceMark usingContext:context];
	
	NSUInteger referenceIndex = 0;
	if (referenceType == RKDOCXFootnoteReference) {
		referenceIndex = [context indexForFootnoteContent: referenceContent];
	} else {
		referenceIndex = [context indexForEndnoteContent: referenceContent];
	}
	
	[runElement addChild: [NSXMLElement elementWithName:referenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:@(referenceIndex).stringValue]]]];
	return runElement;
}

+ (NSXMLElement *)referenceMarkWithRunElementName:(NSString *)runElementName runPropertiesElementName:(NSString *)runPropertiesElementName referenceType:(RKDOCXReferenceType)referenceType
{
	if (!referenceType)
		return nil;
	
	NSString *refElementName = RKDOCXFootnotesFootnoteRefElementName;
	
	if (referenceType == RKDOCXEndnoteReference) {
		refElementName = RKDOCXFootnotesEndnoteRefElementName;
	}
	
	NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName: runPropertiesElementName];
	NSXMLElement *footnoteRefElement = [NSXMLElement elementWithName: refElementName];
	return [NSXMLElement elementWithName:runElementName children:@[runPropertiesElement, footnoteRefElement] attributes:nil];
}

+ (NSXMLElement *)separatorElementWithName:(NSString *)separatorName identifier:(NSString *)identifier forEndnote:(BOOL)forEndnote
{
	NSXMLElement *separatorElement = [NSXMLElement elementWithName: [@"w:" stringByAppendingString: separatorName]];
	NSXMLElement *runElement = [NSXMLElement elementWithName:@"w:r" children:@[separatorElement] attributes:nil];
	NSXMLElement *paragraphElement = [NSXMLElement elementWithName:@"w:p" children:@[runElement] attributes:nil];
	NSXMLElement *typeAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesTypeAttributeName stringValue:separatorName];
	NSXMLElement *identifierAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:identifier];
	NSString *elementName = RKDOCXFootnotesFootnoteElementName;
	if (forEndnote)
		elementName = RKDOCXFootnotesEndnoteElementName;
	return [NSXMLElement elementWithName:elementName children:@[paragraphElement] attributes:@[typeAttribute, identifierAttribute]];
}

@end
