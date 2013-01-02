//
//  RKPDFLine.h
//  RTFKit
//
//  Created by Friedrich Gräter on 12.09.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext, RKParagraphStyleWrapper;

@interface RKPDFLine : NSObject

/*!
 @abstract Creates a PDF line from the given attributed string using the given range and width.
 @discussion Creates a justified line depending on the paragraph style and respects the line spacing of the line. The method instantiates all text objects in the attributed string using the given context.
 */
- (id)initWithAttributedString:(NSAttributedString *)attributedString inRange:(NSRange)range usingWidth:(CGFloat)width maximumHeight:(CGFloat)maximumHeight justificationAllowed:(BOOL)justificationAllowed context:(RKPDFRenderingContext *)context;

/*!
 @abstract The range of the line in the source string
 */
@property (nonatomic, readonly) NSRange visibleRange;

/*!
 @abstract The size of the line
 */
@property (nonatomic, readonly) CGSize size;

/*!
 @abstract The ascent of a line
 */
@property (nonatomic, readonly) CGFloat ascent;

/*!
 @abstract The descent of a line
 */
@property (nonatomic, readonly) CGFloat descent;

/*!
 @abstract The leading of a line
 */
@property (nonatomic, readonly) CGFloat leading;

/*!
 @abstract The attributed string of the line
 @discussion Might contain the hyphen used to wrap the line
 */
@property (nonatomic, readonly) NSAttributedString *content;

/*!
 @abstract The context used to render the line
 */
@property (nonatomic, readonly) RKPDFRenderingContext *context;

/*!
 @abstract The paragraph style of the line
 */
@property (nonatomic, readonly) RKParagraphStyleWrapper *paragraphStyle;

/*!
 @abstract The RTFKit-specific paragraph style of the line
 */
@property (nonatomic, readonly) RKAdditionalParagraphStyle *additionalParagraphStyle;

/*!
 @abstract Renders a frane to uts graphics context within the given rect.
 */
- (void)renderUsingOrigin:(CGPoint)rect;

@end
