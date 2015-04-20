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
	
	// In case of footnotes
	NSXMLDocument *footnotesDocument = [self buildDocumentPartForNotes:context.footnotes endnoteSection:NO];
	if (footnotesDocument) {
		[context indexForRelationshipWithTarget:RKDOCXFootnotesRelationshipTarget andType:RKDOCXFootnotesRelationshipType];
		[context addDocumentPart:[footnotesDocument XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXFootnotesFilename];
	}
	
	// In case of endnotes
	NSXMLDocument *endnotesDocument = [self buildDocumentPartForNotes:context.endnotes endnoteSection:YES];
	if (endnotesDocument) {
		[context indexForRelationshipWithTarget:RKDOCXEndnotesRelationshipTarget andType:RKDOCXEndnotesRelationshipType];
		[context addDocumentPart:[endnotesDocument XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement] withFilename:RKDOCXEndnotesFilename];
	}
}

+ (NSXMLDocument *)buildDocumentPartForNotes:(NSDictionary *)notes endnoteSection:(BOOL)isEndnoteSection
{
	if (!notes.count)
		return nil;
	
	NSString *rootElementName = isEndnoteSection ? RKDOCXEndnotesRootElementName : RKDOCXFootnotesRootElementName;
	NSString *noteElementName = isEndnoteSection ? RKDOCXFootnotesEndnoteElementName : RKDOCXFootnotesFootnoteElementName;
	
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
	
	NSXMLDocument *document = [self basicXMLDocumentWithRootElementName:rootElementName namespaces:namespaces];
	
	// Separator
	[document.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesSeparatorAttributeValue identifier:@"0" endnote:isEndnoteSection]];
	
	// Continuation Separator
	[document.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesContinuationSeparatorAttributeValue identifier:@"1" endnote:isEndnoteSection]];
	
	// Notes
	for (NSNumber *index in notes) {
		[document.rootElement addChild: [NSXMLElement elementWithName:noteElementName children:notes[index] attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:index.stringValue]]]];
	}
	
	return document;
}

+ (NSXMLElement *)referenceElementForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	RKDOCXReferenceType referenceType = RKDOCXNoReference;
	NSString *referenceElementName;
	NSAttributedString *referenceString;
	
	if (attributes[RKFootnoteAttributeName]) {
		referenceType = RKDOCXFootnoteReference;
		referenceElementName = RKDOCXFootnotesFootnoteReferenceElementName;
		referenceString = attributes[RKFootnoteAttributeName];
	}
	else if (attributes[RKEndnoteAttributeName]) {
		referenceType = RKDOCXEndnoteReference;
		referenceElementName = RKDOCXFootnotesEndnoteReferenceElementName;
		referenceString = attributes[RKEndnoteAttributeName];
	}
	else {
		return nil;
	}
	
	NSMutableAttributedString *referenceStringWithReferenceMark = [[NSMutableAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKDOCXReferenceTypeAttributeName: @(referenceType)}];
	[referenceStringWithReferenceMark appendAttributedString: referenceString];
	
	NSArray *referenceContent = [RKDOCXAttributedStringWriter processAttributedString:referenceStringWithReferenceMark usingContext:context];
	
	NSUInteger referenceIndex = 0;
	if (referenceType == RKDOCXFootnoteReference) {
		referenceIndex = [context indexForFootnoteContent: referenceContent];
	} else {
		referenceIndex = [context indexForEndnoteContent: referenceContent];
	}
	
	return [RKDOCXRunWriter runElementWithProperties:[RKDOCXRunWriter propertyElementsForAttributes:attributes usingContext:context] contentElement:[NSXMLElement elementWithName:referenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:@(referenceIndex).stringValue]]]];
}

+ (NSXMLElement *)referenceMarkForAttributes:(NSDictionary *)attributes
{
	NSString *refElementName;
	
	switch ([attributes[RKDOCXReferenceTypeAttributeName] integerValue]) {
		case RKDOCXFootnoteReference:
			refElementName = RKDOCXFootnotesFootnoteRefElementName;
			break;
			
		case RKDOCXEndnoteReference:
			refElementName = RKDOCXFootnotesEndnoteRefElementName;
			break;
			
		default:
			return nil;
	}
	
	NSXMLElement *runPropertiesElement = [NSXMLElement elementWithName: RKDOCXRunPropertiesElementName];
	NSXMLElement *footnoteRefElement = [NSXMLElement elementWithName: refElementName];
	return [NSXMLElement elementWithName:RKDOCXRunElementName children:@[runPropertiesElement, footnoteRefElement] attributes:nil];
}

+ (NSXMLElement *)separatorElementWithName:(NSString *)separatorName identifier:(NSString *)identifier endnote:(BOOL)isEndnote
{
	NSXMLElement *separatorElement = [NSXMLElement elementWithName: [@"w:" stringByAppendingString: separatorName]];
	NSXMLElement *runElement = [NSXMLElement elementWithName:@"w:r" children:@[separatorElement] attributes:nil];
	NSXMLElement *paragraphElement = [NSXMLElement elementWithName:@"w:p" children:@[runElement] attributes:nil];
	NSXMLElement *typeAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesTypeAttributeName stringValue:separatorName];
	NSXMLElement *identifierAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:identifier];
	NSString *elementName = isEndnote ? RKDOCXFootnotesEndnoteElementName : RKDOCXFootnotesFootnoteElementName;
	
	return [NSXMLElement elementWithName:elementName children:@[paragraphElement] attributes:@[typeAttribute, identifierAttribute]];
}

@end
