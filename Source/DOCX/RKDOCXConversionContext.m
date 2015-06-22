//
//  RKDOCXConversionContext.m
//  RTFKit
//
//  Created by Lucas Hauswald on 26.03.15.
//  Copyright (c) 2015 The Soulmen. All rights reserved.
//

#import "RKDOCXConversionContext.h"

#import "RKDOCXFontAttributesWriter.h"
#import <zipzap/zipzap.h>

NSString *RKDOCXConversionContextRelationshipTarget			= @"Target";
NSString *RKDOCXConversionContextRelationshipTypeName		= @"Type";
NSString *RKDOCXConversionContextRelationshipIdentifierName	= @"ID";

@interface RKDOCXConversionContext ()
{
	NSMutableDictionary *_files;
	NSMutableDictionary *_styleCache;
	NSMutableDictionary *_checkedFontNames;
	NSUInteger _imageID;
	NSMutableDictionary *_documentRelationships;
}
@end

@implementation RKDOCXConversionContext

- (id)initWithDocument:(RKDocument *)document
{
	self = [self init];
	
	if (self) {
		_files = [NSMutableDictionary new];
		_styleCache = [NSMutableDictionary new];
		_checkedFontNames = [[NSMutableDictionary alloc] initWithDictionary: @{
																			   // To improve compatibility of certain fonts, we handle them differently. See ULYSSES-5070 for further details.
																			   // Whitelisted fonts
																			   @"Menlo Regular": @YES,
																			   @"Menlo Bold": @YES,
																			   @"Menlo Italic": @YES,
																			   
																			   // Blacklisted fonts
																			   @"Helvetica Neue Italic": @NO,
																			   }];
		_imageID = 0;
		_document = document;
		_usedXMLTypes = [NSDictionary new];
		_usedMIMETypes = [NSDictionary new];
		_footnotes = [NSDictionary new];
		_endnotes = [NSDictionary new];
		_prependFootnoteIndentations = NO;
		_headerCount = 0;
		_footerCount = 0;
		_evenAndOddHeaders = NO;
		_listStyles = [NSDictionary new];
		_currentRelationshipSource = @"document.xml";
		_documentRelationships = [NSMutableDictionary new];
		_packageRelationships = [NSDictionary new];
	}
	
	return self;
}

- (NSDictionary *)cachedStyleFromParagraphStyle:(NSString *)paragraphStyleName characterStyle:(NSString *)characterStyleName
{
	NSDictionary *defaultStyle = self.document.defaultStyle;
	NSArray *styleKey;
	
	if (!paragraphStyleName && !characterStyleName)
		return defaultStyle;
	
	// Try to use pre-chached value
	else if (!paragraphStyleName)
		styleKey = @[characterStyleName];
	
	else if (!characterStyleName)
		styleKey = @[paragraphStyleName];
	
	else
		styleKey = @[characterStyleName, paragraphStyleName];
	
	NSDictionary *cachedStyle = _styleCache[styleKey];
	
	if (cachedStyle)
		return cachedStyle;
	
	// Mix given paragraph or character style with default style, depending on which is available
	if (styleKey.count == 1)
		cachedStyle = [self attributesByMixingStyleAttributes:(characterStyleName ? self.document.characterStyles[characterStyleName] : self.document.paragraphStyles[paragraphStyleName]) intoStyleAttributes:defaultStyle];
	
	// Mix character and paragraph style, character styles have the higher priority
	else
		cachedStyle = [self attributesByMixingStyleAttributes:self.document.characterStyles[characterStyleName] intoStyleAttributes:[self cachedStyleFromParagraphStyle:paragraphStyleName characterStyle:nil]];
	
	// Add mixed style to cache
	_styleCache[styleKey] = cachedStyle;
	
	return cachedStyle;
}

- (NSDictionary *)attributesByMixingStyleAttributes:(NSDictionary *)highPriorityStyleAttributes intoStyleAttributes:(NSDictionary *)lowPriorityStyleAttributes
{
	NSMutableDictionary *mixedStyle = self.document.defaultStyle ? [self.document.defaultStyle mutableCopy] : [NSMutableDictionary new];
	
	if (lowPriorityStyleAttributes)
		[mixedStyle addEntriesFromDictionary: lowPriorityStyleAttributes];
	
	if (highPriorityStyleAttributes)
		[mixedStyle addEntriesFromDictionary: highPriorityStyleAttributes];
	
	if (lowPriorityStyleAttributes[RKFontAttributeName] && highPriorityStyleAttributes[RKFontAttributeName])
		mixedStyle[RKFontAttributeName] = [RKDOCXFontAttributesWriter fontByMixingFont:lowPriorityStyleAttributes[RKFontAttributeName] withOverridingFont:highPriorityStyleAttributes[RKFontAttributeName] usingMask:[highPriorityStyleAttributes[RKFontMixAttributeName] unsignedIntegerValue]];
	
	return mixedStyle;
}

- (BOOL)isFullNameRequieredForFont:(ULFont *)font
{
	NSString *fontName = (__bridge NSString *)CTFontCopyFullName((__bridge CTFontRef)font);
	
	// Look for previously checked font
	if (_checkedFontNames[fontName])
		return [_checkedFontNames[fontName] boolValue];
	
	// Ignore font if it doesn't use the requested traits at all
	CTFontSymbolicTraits fontTraits = CTFontGetSymbolicTraits((__bridge CTFontRef)font);
	CTFontSymbolicTraits filteredTraits = (kCTFontTraitItalic|kCTFontTraitBold);
	
	if ((fontTraits & filteredTraits) == 0) {
		_checkedFontNames[fontName] = @NO;
		return NO;
	}
	
	// Check all other fonts from family
	NSString *fontFamily = (__bridge NSString *)CTFontCopyFamilyName((__bridge CTFontRef)font);
	
	for (NSString *otherFontName in [RKDOCXConversionContext fontNamesForFamilyName: fontFamily]) {
		ULFont *otherFont = [ULFont fontWithName:otherFontName size:font.pointSize];
		if ([otherFont.fontName isEqual: font.fontName])
			continue;
		
		if ((CTFontGetSymbolicTraits((__bridge CTFontRef)otherFont)/* & (kCTFontTraitItalic|kCTFontTraitBold)*/) == fontTraits) {
			_checkedFontNames[fontName] = @YES;
			return YES;
		}
	}
	
	_checkedFontNames[fontName] = @NO;
	return NO;
}

+ (NSArray *)fontNamesForFamilyName:(NSString *)familyName
{
	NSMutableArray *members = [NSMutableArray new];;
	
	for (NSArray *fontVariant in [NSFontManager.sharedFontManager availableMembersOfFontFamily: familyName])
		[members addObject: fontVariant.firstObject];
	
	return members;
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

- (void)addDocumentPartWithXMLDocument:(NSXMLDocument *)part filename:(NSString *)filename contentType:(NSString *)contentType
{
	NSAssert(!_files[filename], @"Document parts may be only set once: %@ was reused.", filename);
	
	if (contentType)
		[self addContentType:contentType forFileName:filename];
	
	NSData *file = [part XMLDataWithOptions: NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement];
	
	_files[filename] = file;
}

- (void)addDocumentPartWithData:(NSData *)part filename:(NSString *)filename MIMEType:(NSString *)MIMEType
{
	// Already added: skip the file (e.g. reused image).
	if (_files[filename])
		return;
	
	[self addContentType:MIMEType forPathExtension:filename.pathExtension];
	
	_files[filename] = part;
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

- (NSString *)newImageId
{
	return @(++_imageID).stringValue;
}


#pragma mark - Footnotes and Endnotes

- (NSUInteger)indexForFootnoteContent:(NSArray *)content
{
	// Identifiers 0 and 1 are reserved for "separator" and "continuationSeparator"
	NSUInteger index = _footnotes.count + 2;
	
	NSMutableDictionary *newFootnotes = [_footnotes mutableCopy];
	newFootnotes[@(index)] = content;
	_footnotes = newFootnotes;
	
	return index;
}

- (NSUInteger)indexForEndnoteContent:(NSArray *)content
{
	// Identifiers 0 and 1 are reserved for "separator" and "continuationSeparator"
	NSUInteger index = _endnotes.count + 2;
	
	NSMutableDictionary *newEndnotes = [_endnotes mutableCopy];
	newEndnotes[@(index)] = content;
	_endnotes = newEndnotes;
	
	return index;
}


#pragma mark - Lists

- (NSUInteger)indexForListStyle:(RKListStyle *)listStyle
{
	__block NSUInteger index = 0;
	
	// List Style already registered
	[_listStyles enumerateKeysAndObjectsUsingBlock: ^(NSNumber *currentIndex, RKListStyle *currentListStyle, BOOL *stop) {
		if ([currentListStyle isEqual: listStyle]) {
			index = currentIndex.unsignedIntegerValue;
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
	NSMutableArray *relationships = _documentRelationships[self.currentRelationshipSource] ?: [NSMutableArray new];
	
	for (NSDictionary *relationship in relationships) {
		if ([relationship[RKDOCXConversionContextRelationshipTarget] isEqual: target])
			return [relationship[RKDOCXConversionContextRelationshipIdentifierName] unsignedIntegerValue];
	}
	
	[relationships addObject: @{RKDOCXConversionContextRelationshipTarget: target,
								RKDOCXConversionContextRelationshipTypeName: type,
								RKDOCXConversionContextRelationshipIdentifierName: @(relationships.count + 1)}];
	
	_documentRelationships[self.currentRelationshipSource] = relationships;
	
	return relationships.count;
}

- (void)addPackageRelationshipWithTarget:(NSString *)target type:(NSString *)type
{
	NSMutableDictionary *newPackageRelationships = [_packageRelationships mutableCopy];
	newPackageRelationships[target] = type;
	
	_packageRelationships = newPackageRelationships;
}

@end
