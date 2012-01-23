//
//  RKSection.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKTypes.h"

/*!
 @abstract Representation of an RTF section
 @discussion An RTF section is an area of the document that has own headlines, footers and custom layouting options.
 */
@interface RKSection : NSObject

/*!
 @abstract Creates a new section based on a given content string
 */
+ (id)sectionWithContent:(NSAttributedString *)content;

- (id)init;

/*!
 @abstract Initializes a section with a given content
 */
- (id)initWithContent:(NSAttributedString *)content;

/*!
 @abstract Retruns the headline for a given page type
 */
- (NSAttributedString *)headerForPage:(RKPageSelectionMask)pageMask;

/*!
 @abstract Changes the headline for a given page type
 */
- (void)setHeader:(NSAttributedString *)header forPages:(RKPageSelectionMask)pageMask;

/*!
 @abstract Retruns the footer for a single or multiple page types
 */
- (NSAttributedString *)footerForPage:(RKPageSelectionMask)pageMask;

/*!
 @abstract Chanes the footer for a single or multiple page types
 */
- (void)setFooter:(NSAttributedString *)footer forPages:(RKPageSelectionMask)pageMask;

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
 */
@property(nonatomic) NSUInteger numberOfFirstPage;

/*!
 @abstract Page number style
 */
@property(nonatomic) RKPageNumberingStyle pageNumberingStyle;

@end
