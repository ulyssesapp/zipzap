//
//  RKPDFColumn.h
//  RTFKit
//
//  Created by Friedrich Gräter on 13.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFWriterTypes.h"

@class RKPDFRenderingContext, RKPDFFrame;

@interface RKPDFColumn : NSObject

/*!
 @abstract Creates a column for a given attributed string in range
 @discussion The given footnote string is prepended to the footnotes of the frame. The widowWidth describes the size of the first line of a succeeding column and is used to detect widows.
 */
- (id)initWithRect:(CGRect)rect widowWidth:(CGFloat)widowWidth context:(RKPDFRenderingContext *)context;

/*!
 @abstract Appends content to a column
 */
- (void)appendContent:(NSAttributedString *)attributedString inRange:(NSRange)range;

/*!
 @abstract Appends notes to a column
 @discussion All contents that could not be appended to the column will be appended to the 'remainingFootnotes' property.
 */
- (void)appendFootnote:(NSAttributedString *)attributedString;

/*!
 @abstract The footnote frame of a column
 */
@property (nonatomic, strong, readonly) RKPDFFrame *contentFrame;

/*!
 @abstract The bounding box of a column
 */
@property (nonatomic, readonly) CGRect boundingBox;

/*!
 @abstract The content frame of a column
 */
@property (nonatomic, strong, readonly) RKPDFFrame *footnotesFrame;

/*!
 @abstract All footnote lines that could not be rendered within this column and should be prepended to the footnote section of any following column.
 */
@property (nonatomic, strong, readonly) NSAttributedString *remainingFootnotes;

/*!
 @abstract Renders the column using the given options
 */
- (void)renderWithOptions:(RKPDFWriterRenderingOptions)options;

@end
