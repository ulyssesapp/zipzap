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
	NSMutableDictionary		*_files;
	NSMutableDictionary		*_styleCache;
	NSMutableDictionary		*_checkedFontNames;
	NSUInteger				_imageID;
	NSUInteger				_reviewID;
	NSMutableDictionary		*_characterStyles;
	NSMutableDictionary		*_paragraphStyles;
	NSMutableDictionary		*_documentRelationships;
	NSMutableSet			*_consumedListItems;
}
@end

@implementation RKDOCXConversionContext

- (id)initWithDocument:(RKDocument *)document
{
	self = [self init];
	
	if (self) {
		_files = [NSMutableDictionary new];
		_styleCache = [NSMutableDictionary new];
		_checkedFontNames = [[self.class fontNamesRequiringFullNames] mutableCopy];
		_imageID = 0;
		_reviewID = 0;
		_document = document;
		_characterStyles = [document.characterStyles mutableCopy] ?: [NSMutableDictionary new];
		_paragraphStyles = [document.paragraphStyles mutableCopy] ?: [NSMutableDictionary new];
		_usedStyles = [NSSet new];
		_usedXMLTypes = [NSDictionary new];
		_usedMIMETypes = [NSDictionary new];
		_footnotes = [NSDictionary new];
		_endnotes = [NSDictionary new];
		_comments = [NSDictionary new];
		_headerCount = 0;
		_footerCount = 0;
		_evenAndOddHeaders = NO;
		_listStyles = [NSDictionary new];
		_consumedListItems = [NSMutableSet new];
		_currentRelationshipSource = @"document.xml";
		_documentRelationships = [NSMutableDictionary new];
		_packageRelationships = [NSDictionary new];
	}
	
	return self;
}

- (NSDictionary *)cachedStyleFromParagraphStyle:(NSString *)paragraphStyleName characterStyle:(NSString *)characterStyleName processingDefaultStyle:(BOOL)processingDefaultStyle
{
	// When processing a default style, no style templates should be used. Thus
	if (processingDefaultStyle)
		return nil;
	
	NSDictionary *defaultStyle = self.document.defaultStyle;
	NSArray *styleKey;

	// Use default style if no template is given
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
	
	// Log used styles
	NSMutableSet *newUsedStyles = [_usedStyles mutableCopy];
	
	if (characterStyleName)
		[newUsedStyles addObject: characterStyleName];
	
	if (paragraphStyleName)
		[newUsedStyles addObject: paragraphStyleName];
	
	_usedStyles = newUsedStyles;
	
	// Mix given paragraph or character style with default style, depending on which is available
	if (styleKey.count == 1)
		cachedStyle = [self attributesByMixingStyleAttributes:(characterStyleName ? _characterStyles[characterStyleName] : _paragraphStyles[paragraphStyleName]) intoStyleAttributes:defaultStyle];
	
	// Mix character and paragraph style, character styles have the higher priority
	else
		cachedStyle = [self attributesByMixingStyleAttributes:_characterStyles[characterStyleName] intoStyleAttributes:[self cachedStyleFromParagraphStyle:paragraphStyleName characterStyle:nil processingDefaultStyle:processingDefaultStyle]];
	
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
	
	// Look for previously checked font. See also +fontNamesRequiringFullNaming.
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
	for (NSString *otherFontName in [ULFont fontNamesForFamilyName: font.familyName]) {
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

+ (NSDictionary *)fontNamesRequiringFullNames
{
	return @{
			// The following fonts do not support traits on Word 2011, thus we need to use full font names:
			@"Menlo Regular":			@YES,
			@"Menlo Bold":				@YES,
			@"Menlo Italic":			@YES,

			@"Helvetica Neue UltraLight":	@YES,
			@"Helvetica Neue Light":		@YES,
			
			// The following fonts do not support full names on Word 2011. The automatic fallback in -isFullNameRequieredForFont shall not be used:
			@"Helvetica Neue Italic":		@NO,
			@"Avenir Next Italic":			@NO
			};
}

- (void)registerCharacterStyle:(NSDictionary *)style withName:(NSString *)name
{
	_characterStyles[name] = style;
}

- (void)registerParagraphStyle:(NSDictionary *)style withName:(NSString *)name
{
	_paragraphStyles[name] = style;
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
	if (_usedMIMETypes[extension.lowercaseString])
		return;
	
	NSMutableDictionary *newMIMETypes = [_usedMIMETypes mutableCopy];
	newMIMETypes[extension.lowercaseString] = MIMEType;
	_usedMIMETypes = newMIMETypes;
}

- (NSString *)newImageId
{
	return @(++_imageID).stringValue;
}

- (NSString *)newReviewId
{
	return @(++_reviewID).stringValue;
}


#pragma mark - Footnotes, Endnotes and Comments

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

- (NSUInteger)indexForCommentContent:(NSArray *)content
{
	NSUInteger index = _comments.count;
	
	NSMutableDictionary *newComments = [_comments mutableCopy];
	newComments[@(index)] = content;
	_comments = newComments;
	
	return index;
}


#pragma mark - Lists

- (NSUInteger)indexForListStyle:(RKListStyle *)listStyle
{
	__block NSUInteger index = 0;
	
	// List Style already registered
	[_listStyles enumerateKeysAndObjectsUsingBlock: ^(NSNumber *currentIndex, RKListStyle *currentListStyle, BOOL *stop) {
		if (currentListStyle == listStyle) {
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

- (BOOL)consumeListItem:(RKListItem *)listItem
{
	if ([_consumedListItems containsObject: listItem])
		return YES;
	
	[_consumedListItems addObject: listItem];
	return NO;
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
