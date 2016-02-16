//
//  RKDOCXReviewAnnotationWriter.m
//  RTFKit
//
//  Created by Lucas Hauswald on 13.01.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

#import "RKDOCXReviewAnnotationWriter.h"

#import "RKDOCXAttributedStringWriter.h"
#import "RKDOCXFootnotesWriter.h"
#import "RKDOCXRunWriter.h"

// Root element name
NSString *RKDOCXCommentsRootElementName			= @"w:comments";

// Content type
NSString *RKDOCXCommentsContentType				= @"application/vnd.openxmlformats-officedocument.wordprocessingml.comments+xml";

// Filename
NSString *RKDOCXCommentsFilename				= @"comments.xml";

// Relationship type
NSString *RKDOCXCommentsRelationshipType		= @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments";

// Elements
NSString *RKDOCXAuthorAttributeName				= @"w:author";
NSString *RKDOCXCommentElementName				= @"w:comment";
NSString *RKDOCXCommentRangeEndElementName		= @"w:commentRangeEnd";
NSString *RKDOCXCommentRangeStartElementName	= @"w:commentRangeStart";
NSString *RKDOCXCommentReferenceElementName		= @"w:commentReference";
NSString *RKDOCXDeletedElementName				= @"w:del";
NSString *RKDOCXInsertedElementName				= @"w:ins";

// Attributes
NSString *RKDOCXIDAttributeName					= @"w:id";

@implementation RKDOCXReviewAnnotationWriter

+ (void)buildCommentsUsingContext:(RKDOCXConversionContext *)context
{
	if (!context.comments.count)
		return;
	
	NSXMLDocument *document = [self basicXMLDocumentWithStandardNamespacesAndRootElementName: RKDOCXCommentsRootElementName];
	
	for (NSNumber *index in context.comments) {
		[document.rootElement addChild: [NSXMLElement elementWithName:RKDOCXCommentElementName children:context.comments[index] attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:index.stringValue]]]];
	}
	
	[context indexForRelationshipWithTarget:RKDOCXCommentsFilename andType:RKDOCXCommentsRelationshipType];
	[context addDocumentPartWithXMLDocument:document filename:[self packagePathForFilename:RKDOCXCommentsFilename folder:RKDOCXWordFolder] contentType:RKDOCXCommentsContentType];
}

+ (NSXMLElement *)containerElementForDeletedRunsUsingContext:(RKDOCXConversionContext *)context
{
	return [NSXMLElement elementWithName:RKDOCXDeletedElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:context.newReviewId], [NSXMLElement attributeWithName:RKDOCXAuthorAttributeName stringValue:@""]]];
}

+ (NSXMLElement *)containerElementForInsertedRunsUsingContext:(RKDOCXConversionContext *)context
{
	return [NSXMLElement elementWithName:RKDOCXInsertedElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:context.newReviewId], [NSXMLElement attributeWithName:RKDOCXAuthorAttributeName stringValue:@""]]];
}

+ (NSXMLElement *)startElementForCommentAttribute:(NSAttributedString *)comment withID:(NSUInteger *)outCommentID usingContext:(RKDOCXConversionContext *)context
{
	if (!comment)
		return nil;
	
	// Change relationship source for comment
	NSString *previousRelationshipSource = context.currentRelationshipSource;
	context.currentRelationshipSource = RKDOCXCommentsFilename;
	
	*outCommentID = [context indexForCommentContent: [RKDOCXAttributedStringWriter processAttributedString:[self.class attributedStringForCommentString: comment] usingContext:context]];
	
	// Restore previous relationship source
	context.currentRelationshipSource = previousRelationshipSource;
	
	return [NSXMLElement elementWithName:RKDOCXCommentRangeStartElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:@(*outCommentID).stringValue]]];
}

+ (NSArray *)endElementsForCommentID:(NSUInteger)commentID usingContext:(RKDOCXConversionContext *)context
{
	return @[
			 [NSXMLElement elementWithName:RKDOCXCommentRangeEndElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:@(commentID).stringValue]]],
			 [RKDOCXRunWriter runElementForAttributes:nil contentElement:[NSXMLElement elementWithName:RKDOCXCommentReferenceElementName children:nil attributes:@[[NSXMLElement attributeWithName:RKDOCXIDAttributeName stringValue:@(commentID).stringValue]]] usingContext:context]
			 ];
}

+ (NSAttributedString *)attributedStringForCommentString:(NSAttributedString *)attributedString
{
	NSMutableAttributedString *commentString = attributedString.mutableCopy;
	
	[commentString insertAttributedString:[[NSAttributedString alloc] initWithString:@"\ufffc" attributes:@{RKDOCXReferenceTypeAttributeName: @(RKDOCXCommentReference)}] atIndex:0];
	
	return commentString;
}

@end
