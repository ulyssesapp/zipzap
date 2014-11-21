//
//  RKSection.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTypes.h"

#define RKContinuousPageNumbering           NSNotFound

/*!
 @abstract Representation of an RTF section
 @discussion An RTF section is an area of the document that has own headlines, footers and custom layouting options.
 @note Section style sheets are currently unsupported, since RTF readers do not provide any support for it
 */
@interface RKSection : NSObject <NSCopying>

/*!
 @abstract Initializes a section with a given content string.
 */
- (id)initWithContent:(NSAttributedString *)content;


#pragma mark - Section header

/*!
 @abstract Retruns the headline for a given page type
 @discussion The page mask may be either a left or right selector. Additionally the first-page selector may be set. If no first page header is given, the left or right page will be used according to the mask.
 */
- (NSAttributedString *)headerForPage:(RKPageSelectionMask)pageMask;

/*!
 @abstract Changes the headline for a given page type
 */
- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask;

/*!
 @abstract Returns true, if all headers are identic
 */
- (BOOL)hasSingleHeaderForAllPages;

/*!
 @abstract Enumerates all headers that have been set by their page mask
 */
- (void)enumerateHeadersUsingBlock:(void(^)(RKPageSelectionMask pageSelector, NSAttributedString *header))block;


#pragma mark - Section footer

/*!
 @abstract Retruns the footer for a single or multiple page types
 @discussion The page mask may be either a left or right selector. Additionally the first-page selector may be set. If no first page header is given, the left or right page will be used according to the mask. 
 */
- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask;

/*!
 @abstract Chanes the footer for a single or multiple page types
 */
- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask;

/*!
 @abstract Returns true, if all footers are identic
 */
- (BOOL)hasSingleFooterForAllPages;

/*!
 @abstract Enumerates all headers that have been set by their page mask
 */
- (void)enumerateFootersUsingBlock:(void(^)(RKPageSelectionMask pageSelector, NSAttributedString *footer))block;


#pragma mark - Content and styling

/*!
 @abstract Content of the section
 */
@property(nonatomic, strong) NSAttributedString *content;

/*!
 @abstract Multicolumn layout
 */
@property(nonatomic) NSUInteger numberOfColumns;

/*!
 @abstract Starting page number
 @discussion Continuos page numbering if NSNotFound is set
 */
@property(nonatomic) NSUInteger indexOfFirstPage;

/*!
 @abstract Page number style
 */
@property(nonatomic) RKPageNumberingStyle pageNumberingStyle;

/*!
 @abstract Column spacing in points
 */
@property(nonatomic) CGFloat columnSpacing;

@end
