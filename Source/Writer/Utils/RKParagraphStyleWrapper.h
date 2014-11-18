//
//  RKParagraphStyleWrapper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

/*!
 @abstract Allows to wrap a CTParagraphStyle for more convenient usage
 */
@interface RKParagraphStyleWrapper : NSObject

/*!
 @abstract Creates a new default paragraph style wrapper
 */
+ (RKParagraphStyleWrapper *)newDefaultParagraphStyle;

/*!
 @abstract Initializes the wrapper with the given paragraph style
 */
- (id)initWithCTParagraphStyle:(CTParagraphStyleRef)paragraphStyle;

/*!
 @abstract Creates a new paragraph style based on the settings of the wrapper
 */
- (CTParagraphStyleRef)newCTParagraphStyle;

/*!
 @abstract Initializes the wrapper with the given paragraph style
 */
- (id)initWithNSParagraphStyle:(NSParagraphStyle *)paragraphStyle;

/*!
 @abstract Creates a new paragraph style based on the settings of the wrapper
 */
- (NSParagraphStyle *)newNSParagraphStyle;

/*!
 @abstract The alignment setting
 */
@property (nonatomic, readwrite) CTTextAlignment textAlignment;

/*!
 @abstract The first line head indent
 */
@property (nonatomic, readwrite) CGFloat firstLineHeadIndent;

/*!
 @abstract The head indent
 */
@property (nonatomic, readwrite) CGFloat headIndent;

/*!
 @abstract The tail indent
 */
@property (nonatomic, readwrite) CGFloat tailIndent;

/*!
 @abstract The tab stops (array of RKTabStopWrapper)
 */
@property (nonatomic, strong, readwrite) NSArray *tabStops;

/*!
 @abstract The default tab interval
 */
@property (nonatomic, readwrite) CGFloat defaultTabInterval;

/*!
 @abstract The line break mode
 */
@property (nonatomic, readwrite) CTLineBreakMode lineBreakMode;

/*!
 @abstract The line height multiple
 */
@property (nonatomic, readwrite) CGFloat lineHeightMultiple;

/*!
 @abstract The maximum line height
 */
@property (nonatomic, readwrite) CGFloat maximumLineHeight;

/*!
 @abstract The minimum line height
 */
@property (nonatomic, readwrite) CGFloat minimumLineHeight;

/*!
 @abstract The line spacing
 */
@property (nonatomic, readwrite) CGFloat lineSpacing;

/*!
 @abstract The paragraph spacing after the paragraph
 */
@property (nonatomic, readwrite) CGFloat paragraphSpacing;

/*!
 @abstract The paragraph spacing before the paragraph
 */
@property (nonatomic, readwrite) CGFloat paragraphSpacingBefore;

/*!
 @abstract The writing direction
 */
@property (nonatomic, readwrite) CTWritingDirection baseWritingDirection;

/*!
 @abstract The hyphenation factor
 */
@property (nonatomic, readwrite) CGFloat hyphenationFactor;

@end
