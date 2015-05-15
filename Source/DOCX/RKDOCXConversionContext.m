//
//  RKDOCXConversionContext.h
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

#import "RKDOCXFontAttributesWriter.h"
#import <zipzap/zipzap.h>

NSString *RKDOCXConversionContextRelationshipTypeName		= @"Type";
NSString *RKDOCXConversionContextRelationshipIdentifierName	= @"ID";

@interface RKDOCXConversionContext ()
{
	NSMutableDictionary *_files;
	NSMutableDictionary *_styleCache;
}
@end

@implementation RKDOCXConversionContext

- (id)initWithDocument:(RKDocument *)document
{
	self = [self init];
	
	if (self) {
		_files = [NSMutableDictionary new];
		_styleCache = [NSMutableDictionary new];
		_document = document;
		_usedXMLTypes = [NSDictionary new];
		_usedMIMETypes = [NSDictionary new];
		_footnotes = [NSDictionary new];
		_endnotes = [NSDictionary new];
		_headerCount = 0;
		_footerCount = 0;
		_evenAndOddHeaders = NO;
		_listStyles = [NSDictionary new];
		_documentRelationships = [NSDictionary new];
	}
	
	return self;
}

- (NSDictionary *)cachedStyleFromParagraphStyle:(NSString *)paragraphStyleName characterStyle:(NSString *)characterStyleName
{
	// In case there are no styles
	if (!paragraphStyleName) {
		if (!characterStyleName)
			return nil;
		else
			return _document.characterStyles[characterStyleName];
	}
	else if (!characterStyleName)
		return _document.paragraphStyles[paragraphStyleName];
	
	NSArray *styleKey = @[paragraphStyleName, characterStyleName];
	
	if (_styleCache[styleKey])
		return _styleCache[styleKey];
	
	NSDictionary *paragraphAttributes = _document.paragraphStyles[paragraphStyleName];
	NSDictionary *characterAttributes = _document.characterStyles[characterStyleName];
	
	NSMutableDictionary *cachedStyle = [NSMutableDictionary new];
	
	if (paragraphAttributes)
		[cachedStyle addEntriesFromDictionary: paragraphAttributes];
	
	if (characterAttributes)
		[cachedStyle addEntriesFromDictionary: characterAttributes];
	
	if (paragraphAttributes[RKFontAttributeName] && characterAttributes[RKFontAttributeName])
		cachedStyle[RKFontAttributeName] = [RKDOCXFontAttributesWriter overridingFontPropertiesForCharacterAttributes:characterAttributes paragraphAttributes:paragraphAttributes];
	
	[_styleCache addEntriesFromDictionary: @{styleKey: cachedStyle}];
	
	return cachedStyle;
}


#pragma mark - Output context

- (NSData *)docxRepresentation
{
	ZZMutableArchive *archive = [[ZZMutableArchive alloc] initWithData:[NSMutableData new] encoding:NSUTF8StringEncoding];
	NSMutableArray *entries = [NSMutableArray new];
	
	[_files enumerateKeysAndObjectsUsingBlock: ^(NSString* filename, NSData* file, BOOL *stop) {
		[entries addObject: [ZZArchiveEntry archiveEntryWithFileName:filename compress:YES dataBlock:^(NSError** error) {
			return file;
		}]];
	}];
	
	[archive updateEntries:entries error:nil];
	
	return [archive contents];
}

- (void)addXMLDocumentPart:(NSXMLDocument *)part withFilename:(NSString *)filename contentType:(NSString *)contentType
{
	NSAssert(!_files[filename], @"Document parts may be only set once: %@ was reused.", filename);
	
	if (contentType)
		[self addContentType:contentType forFileName:filename];
	
	NSData *file = [part XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement];
	[_files addEntriesFromDictionary: @{filename: file}];
}

- (void)addBinaryDocumentPart:(NSData *)part withFileName:(NSString *)filename MIMEType:(NSString *)MIMEType
{
	NSAssert(!_files[filename], @"Document parts may be only set once: %@ was reused.", filename);
	
	[self addContentType:MIMEType forPathExtension:filename.pathExtension];
	
	[_files addEntriesFromDictionary: @{filename: part}];
}

- (void)addContentType:(NSString *)XMLType forFileName:(NSString *)filename
{
	NSMutableDictionary *newXMLTypes = [_usedXMLTypes mutableCopy];
	newXMLTypes[filename] = XMLType;
	_usedXMLTypes = newXMLTypes;
}

- (void)addContentType:(NSString *)MIMEType forPathExtension:(NSString *)extension
{
	if (_usedMIMETypes[extension])
		return;
	
	NSMutableDictionary *newMIMETypes = [_usedMIMETypes mutableCopy];
	newMIMETypes[extension] = MIMEType;
	_usedMIMETypes = newMIMETypes;
}


#pragma mark - Footnotes and Endnotes

- (NSUInteger)indexForFootnoteContent:(NSArray *)content
{
	// Identifiers 0 and 1 are reserved for "separator" and "continuationSeparator"
	NSUInteger index = _footnotes.count + 2;
	
	NSMutableDictionary *newFootnotes = [_footnotes mutableCopy];
	[newFootnotes addEntriesFromDictionary: @{@(index): content}];
	_footnotes = newFootnotes;
	
	return index;
}

- (NSUInteger)indexForEndnoteContent:(NSArray *)content
{
	// Identifiers 0 and 1 are reserved for "separator" and "continuationSeparator"
	NSUInteger index = _endnotes.count + 2;
	
	NSMutableDictionary *newEndnotes = [_endnotes mutableCopy];
	[newEndnotes addEntriesFromDictionary: @{@(index): content}];
	_endnotes = newEndnotes;
	
	return index;
}


#pragma mark - Lists

- (NSUInteger)indexForListStyle:(RKListStyle *)listStyle
{
	__block NSUInteger index = 0;
	
	// List Style already registered
	[_listStyles enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
		if ([obj isEqual: listStyle]) {
			index = [key unsignedIntegerValue];
			*stop = YES;
		}
	}];
	
	// Return index if list style was found
	if (index)
		return index;
	
	// Register new list style
	index = _listStyles.count + 1;
	NSMutableDictionary *newListStyles = [_listStyles mutableCopy];
	newListStyles[@(index)] = listStyle;
	_listStyles = newListStyles;
	
	return index;
}


#pragma mark - Document relationships

- (NSUInteger)indexForRelationshipWithTarget:(NSString *)target andType:(NSString *)type
{
	NSUInteger index = 0;
	
	// Relationship exists
	if (_documentRelationships[target]) {
		index = [_documentRelationships[target][RKDOCXConversionContextRelationshipIdentifierName] unsignedIntegerValue];
		return index;
	}
	
	// Create new relationship
	index = _documentRelationships.count + 1;
	NSMutableDictionary *newRelationships = [_documentRelationships mutableCopy];
	[newRelationships addEntriesFromDictionary: @{
												  target: @{
														  RKDOCXConversionContextRelationshipTypeName: type,
														  RKDOCXConversionContextRelationshipIdentifierName: @(index)
														  }
												  }];
	_documentRelationships = newRelationships;
	
	return index;
}

@end
