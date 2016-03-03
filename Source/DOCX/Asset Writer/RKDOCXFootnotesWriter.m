//
//  RKDOCXFootnotesWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 16.04.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXFootnotesWriter.h"

#import "RKDOCXAttributedStringWriter.h"
#import "RKDOCXParagraphWriter.h"
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
NSString *RKDOCXFootnotesAnnotationRefElementName				= @"w:annotationRef";
NSString *RKDOCXFootnotesEndnoteElementName						= @"w:endnote";
NSString *RKDOCXFootnotesEndnoteRefElementName					= @"w:endnoteRef";
NSString *RKDOCXFootnotesEndnoteReferenceElementName			= @"w:endnoteReference";
NSString *RKDOCXFootnotesFootnoteElementName					= @"w:footnote";
NSString *RKDOCXFootnotesFootnoteRefElementName					= @"w:footnoteRef";
NSString *RKDOCXFootnotesFootnoteReferenceElementName			= @"w:footnoteReference";

// Attributes
NSString *RKDOCXFootnotesTypeAttributeName						= @"w:type";
NSString *RKDOCXFootnotesIdentifierAttributeName				= @"w:id";

// Attribute Names
NSString *RKDOCXEndnoteReferenceAttributeName					= @"RKDOCXEndnoteReference";
NSString *RKDOCXFootnoteReferenceAttributeName					= @"RKDOCXFootnoteReference";

NSString *RKDOCXReferenceTypeAttributeName						= @"RKDOCXReferenceType";

NSString *RKDOCXEndnoteReferenceStyleName						= @"endnote reference";
NSString *RKDOCXEndnoteTextStyleName							= @"endnote text";
NSString *RKDOCXFootnoteReferenceStyleName						= @"footnote reference";
NSString *RKDOCXFootnoteTextStyleName							= @"footnote text";

@implementation RKDOCXFootnotesWriter

+ (void)buildFootnotesUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.footnotes.count && !context.endnotes.count)
		return;
	
	// In case of footnotes
	NSXMLDocument *footnotesDocument = [self buildFootnotesDocumentPartUsingContext:context isEndnoteSection:NO];
	if (footnotesDocument) {
		[context indexForRelationshipWithTarget:RKDOCXFootnotesFilename andType:RKDOCXFootnotesRelationshipType];
		[context addDocumentPartWithXMLDocument:footnotesDocument filename:[self packagePathForFilename:RKDOCXFootnotesFilename folder:RKDOCXWordFolder] contentType:RKDOCXFootnotesContentType];
	}
	
	// In case of endnotes
	NSXMLDocument *endnotesDocument = [self buildFootnotesDocumentPartUsingContext:context isEndnoteSection:YES];
	if (endnotesDocument) {
		[context indexForRelationshipWithTarget:RKDOCXEndnotesFilename andType:RKDOCXEndnotesRelationshipType];
		[context addDocumentPartWithXMLDocument:endnotesDocument filename:[self packagePathForFilename:RKDOCXEndnotesFilename folder:RKDOCXWordFolder] contentType:RKDOCXEndnotesContentType];
	}
}

+ (NSXMLDocument *)buildFootnotesDocumentPartUsingContext:(RKDOCXConversionContext *)context isEndnoteSection:(BOOL)isEndnoteSection
{
	NSDictionary *notes = isEndnoteSection ? context.endnotes : context.footnotes;
	
	if (!notes.count)
		return nil;
	
	NSString *rootElementName = isEndnoteSection ? RKDOCXEndnotesRootElementName : RKDOCXFootnotesRootElementName;
	NSString *noteElementName = isEndnoteSection ? RKDOCXFootnotesEndnoteElementName : RKDOCXFootnotesFootnoteElementName;
	
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: rootElementName];
	
	// Separator
	[document.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesSeparatorAttributeValue identifier:@"0" endnote:isEndnoteSection usingContext:context]];
	
	// Continuation Separator
	[document.rootElement addChild: [self separatorElementWithName:RKDOCXFootnotesContinuationSeparatorAttributeValue identifier:@"1" endnote:isEndnoteSection usingContext:context]];
	
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
	NSMutableAttributedString *referenceString;
	NSString *characterStyleName;
	NSString *paragraphStyleName;
	NSString *newRelationshipSource;
	
	// Get footnote or endnote contents
	if (attributes[RKFootnoteAttributeName]) {
		referenceType = RKDOCXFootnoteReference;
		referenceElementName = RKDOCXFootnotesFootnoteReferenceElementName;
		referenceString = [attributes[RKFootnoteAttributeName] mutableCopy];
		characterStyleName = RKDOCXFootnoteReferenceStyleName;
		paragraphStyleName = RKDOCXFootnoteTextStyleName;
		newRelationshipSource = RKDOCXFootnotesFilename;
	}
	else if (attributes[RKEndnoteAttributeName]) {
		referenceType = RKDOCXEndnoteReference;
		referenceElementName = RKDOCXFootnotesEndnoteReferenceElementName;
		referenceString = [attributes[RKEndnoteAttributeName] mutableCopy];
		characterStyleName = RKDOCXEndnoteReferenceStyleName;
		paragraphStyleName = RKDOCXEndnoteTextStyleName;
		newRelationshipSource = RKDOCXEndnotesFilename;
	}
	else {
		return nil;
	}
	
	NSMutableDictionary *referenceMarkAttributes;
	
	if (context.characterStyles[characterStyleName])
		referenceMarkAttributes = context.characterStyles[characterStyleName];
	
	// Store reference style after first time usage
	else {
		referenceMarkAttributes = [context.document.footnoteAreaAnchorAttributes mutableCopy];
		
		// Overwrite style name with 'EndnoteReference'/'FootnoteReference'
		referenceMarkAttributes[RKCharacterStyleNameAttributeName] = characterStyleName;
		[context registerCharacterStyle:referenceMarkAttributes withName:characterStyleName];
	}
	
	// Insert anchor and content indenting tab
	[referenceString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\ufffc\t" attributes:referenceMarkAttributes] atIndex:0];
	[referenceString addAttribute:RKDOCXReferenceTypeAttributeName value:@(referenceType) range:NSMakeRange(0, 1)];
	
	NSMutableParagraphStyle *paragraphStyleWithContentInset;
	
	if (context.paragraphStyles[paragraphStyleName])
		paragraphStyleWithContentInset = context.paragraphStyles[paragraphStyleName][RKParagraphStyleAttributeName];
	
	// Store paragraph style after first usage
	else {
		paragraphStyleWithContentInset = referenceString.length > 2 ? [[referenceString attribute:RKParagraphStyleAttributeName atIndex:2 effectiveRange:NULL] mutableCopy] : nil;
		
		if (!paragraphStyleWithContentInset)
			paragraphStyleWithContentInset = [NSMutableParagraphStyle new];
		
		// Set indent for content
		paragraphStyleWithContentInset.headIndent = context.document.footnoteAreaContentInset;
		paragraphStyleWithContentInset.firstLineHeadIndent = paragraphStyleWithContentInset.headIndent;
		
		[context registerParagraphStyle:@{RKParagraphStyleNameAttributeName: paragraphStyleName, RKParagraphStyleAttributeName: paragraphStyleWithContentInset} withName:paragraphStyleName];
	}
	
	// Overwrite style name with 'EndnoteText'/'FootnoteText'
	[referenceString addAttribute:RKParagraphStyleNameAttributeName value:paragraphStyleName range:NSMakeRange(0, referenceString.length)];
	
	NSMutableParagraphStyle *firstParagraphStyle = [paragraphStyleWithContentInset mutableCopy];
	
	// Adjust tab stop to contain marker inset if necessary
	if (context.document.footnoteAreaContentInset > 0) {
		NSMutableArray *tabStops = [NSMutableArray new];
		[tabStops addObject: [[NSTextTab alloc] initWithTextAlignment:RKTextAlignmentLeft location:context.document.footnoteAreaContentInset options:@{}]];
		
		for (NSTextTab *tabStop in firstParagraphStyle.tabStops) {
			if (tabStop.location > context.document.footnoteAreaContentInset)
				[tabStops addObject: tabStop];
		}
		
		firstParagraphStyle.tabStops = tabStops;
	}
	
	// Set indent for first line of first paragraph (with marker and content)
	firstParagraphStyle.firstLineHeadIndent = context.document.footnoteAreaContentInset - (context.document.footnoteAreaContentInset - context.document.footnoteAreaAnchorInset);
	
	NSRange firstNewlineRange = [referenceString.string rangeOfCharacterFromSet: NSCharacterSet.newlineCharacterSet];
	if (firstNewlineRange.location == NSNotFound)
		firstNewlineRange = NSMakeRange(referenceString.length - 1, 1);
	
	NSRange firstParagraphRange = NSMakeRange(0, firstNewlineRange.location);
	
	// Add style attribute for all paragraphs
	[referenceString addAttribute:RKParagraphStyleAttributeName value:paragraphStyleWithContentInset range:NSMakeRange(0, referenceString.length)];
	
	// Add style attribute for first paragraph
	[referenceString addAttribute:RKParagraphStyleAttributeName value:firstParagraphStyle range:firstParagraphRange];
	
	// Change relationship source for endnotes/footnotes
	NSString *previousRelationshipSource = context.currentRelationshipSource;
	context.currentRelationshipSource = newRelationshipSource;
	
	NSArray *referenceContent = [RKDOCXAttributedStringWriter processAttributedString:referenceString usingContext:context];
	
	// Restore previous relationship source
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
			
		case RKDOCXCommentReference:
			refElementName = RKDOCXFootnotesAnnotationRefElementName;
			break;
			
		default:
			return nil;
	}
	
	NSXMLElement *footnoteRefElement = [NSXMLElement elementWithName: refElementName];
	return [RKDOCXRunWriter runElementForAttributes:attributes contentElement:footnoteRefElement usingContext:context];
}

+ (NSXMLElement *)separatorElementWithName:(NSString *)separatorName identifier:(NSString *)identifier endnote:(BOOL)isEndnote usingContext:(RKDOCXConversionContext *)context
{
	NSXMLElement *separatorElement = [NSXMLElement elementWithName: [@"w:" stringByAppendingString: separatorName]];
	NSXMLElement *paragraphElement = [RKDOCXParagraphWriter paragraphElementForSeparatorElement:separatorElement usingContext:context];
	NSXMLElement *typeAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesTypeAttributeName stringValue:separatorName];
	NSXMLElement *identifierAttribute = [NSXMLElement attributeWithName:RKDOCXFootnotesIdentifierAttributeName stringValue:identifier];
	NSString *elementName = isEndnote ? RKDOCXFootnotesEndnoteElementName : RKDOCXFootnotesFootnoteElementName;
	
	return [NSXMLElement elementWithName:elementName children:@[paragraphElement] attributes:@[typeAttribute, identifierAttribute]];
}

@end
