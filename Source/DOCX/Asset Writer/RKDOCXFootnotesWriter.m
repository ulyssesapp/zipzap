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

// Root element names
NSString *RKDOCXEndnotesRootElementName							= @"w:endnotes";
NSString *RKDOCXFootnotesRootElementName						= @"w:footnotes";

// Content types
NSString *RKDOCXEndnotesContentType								= @"application/vnd.openxmlformats-officedocument.wordprocessingml.endnotes+xml";
NSString *RKDOCXFootnotesContentType							= @"application/vnd.openxmlformats-officedocument.wordprocessingml.footnotes+xml";

// Relationship types
NSString *RKDOCXEndnotesRelationshipType						= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/endnotes";
NSString *RKDOCXFootnotesRelationshipType						= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/footnotes";

// Filenames
NSString *RKDOCXEndnotesFilename								= @"endnotes.xml";
NSString *RKDOCXFootnotesFilename								= @"footnotes.xml";

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

/*!
 @abstract Specifies the type of endnote/footnote reference that should be created.
 
 @const RKDOCXNoReference		No reference should be created. If this value is actually used, something has gone wrong.
 @const RKDOCXFootnoteReference	A footnote reference should be created.
 @const RKDOCXEndnoteReference	An endnote reference should be created.
 */
typedef enum : NSUInteger {
	RKDOCXNoReference,
	RKDOCXFootnoteReference,
	RKDOCXEndnoteReference,
} RKDOCXReferenceType;

@implementation RKDOCXFootnotesWriter

+ (void)buildFootnotesUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.footnotes.count && !context.endnotes.count)
		return;
	
	// In case of footnotes
	NSXMLDocument *footnotesDocument = [self buildDocumentPartForNotes:context.footnotes endnoteSection:NO];
	if (footnotesDocument) {
		[context indexForRelationshipWithTarget:RKDOCXFootnotesFilename andType:RKDOCXFootnotesRelationshipType];
		[context addDocumentPartWithXMLDocument:footnotesDocument filename:[self packagePathForFilename:RKDOCXFootnotesFilename folder:RKDOCXWordFolder] contentType:RKDOCXFootnotesContentType];
	}
	
	// In case of endnotes
	NSXMLDocument *endnotesDocument = [self buildDocumentPartForNotes:context.endnotes endnoteSection:YES];
	if (endnotesDocument) {
		[context indexForRelationshipWithTarget:RKDOCXEndnotesFilename andType:RKDOCXEndnotesRelationshipType];
		[context addDocumentPartWithXMLDocument:endnotesDocument filename:[self packagePathForFilename:RKDOCXEndnotesFilename folder:RKDOCXWordFolder] contentType:RKDOCXEndnotesContentType];
	}
}

+ (NSXMLDocument *)buildDocumentPartForNotes:(NSDictionary *)notes endnoteSection:(BOOL)isEndnoteSection
{
	if (!notes.count)
		return nil;
	
	NSString *rootElementName = isEndnoteSection ? RKDOCXEndnotesRootElementName : RKDOCXFootnotesRootElementName;
	NSString *noteElementName = isEndnoteSection ? RKDOCXFootnotesEndnoteElementName : RKDOCXFootnotesFootnoteElementName;
	
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: rootElementName];
	
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
	NSString *newRelationshipSource;
	
	if (attributes[RKFootnoteAttributeName]) {
		referenceType = RKDOCXFootnoteReference;
		referenceElementName = RKDOCXFootnotesFootnoteReferenceElementName;
		referenceString = attributes[RKFootnoteAttributeName];
		newRelationshipSource = RKDOCXFootnotesFilename;
	}
	else if (attributes[RKEndnoteAttributeName]) {
		referenceType = RKDOCXEndnoteReference;
		referenceElementName = RKDOCXFootnotesEndnoteReferenceElementName;
		referenceString = attributes[RKEndnoteAttributeName];
		newRelationshipSource = RKDOCXEndnotesFilename;
	}
	else {
		return nil;
	}
	
	NSMutableAttributedString *referenceStringWithReferenceMark = [[NSMutableAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKDOCXReferenceTypeAttributeName: @(referenceType)}];
	[referenceStringWithReferenceMark appendAttributedString: referenceString];
	
	// Change relationship source for endnotes/footnotes
	NSString *previousRelationshipSource = context.currentRelationshipSource;
	context.currentRelationshipSource = newRelationshipSource;
	
	NSArray *referenceContent = [RKDOCXAttributedStringWriter processAttributedString:referenceStringWithReferenceMark usingContext:context];
	
	// Restore previous relationship
	context.currentRelationshipSource = previousRelationshipSource;
	
	NSUInteger referenceIndex = 0;
	if (referenceType == RKDOCXFootnoteReference) {
		referenceIndex = [context indexForFootnoteContent: referenceContent];
	} else {
		referenceIndex = [context indexForEndnoteContent: referenceContent];
	}
	
	return [RKDOCXRunWriter runElementForAttributes:attributes contentElement:[NSXMLElement elementWithName:referenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:@(referenceIndex).stringValue]]] usingContext:context];
}

+ (NSXMLElement *)referenceMarkForAttributes:(NSDictionary *)attributes usingContext:(RKDOCXConversionContext *)context
{
	NSString *refElementName;
	
	switch ([attributes[RKDOCXReferenceTypeAttributeName] unsignedIntegerValue]) {
		case RKDOCXFootnoteReference:
			refElementName = RKDOCXFootnotesFootnoteRefElementName;
			break;
			
		case RKDOCXEndnoteReference:
			refElementName = RKDOCXFootnotesEndnoteRefElementName;
			break;
			
		default:
			return nil;
	}
	
	NSXMLElement *footnoteRefElement = [NSXMLElement elementWithName: refElementName];
	return [RKDOCXRunWriter runElementForAttributes:attributes contentElement:footnoteRefElement usingContext:context];
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
