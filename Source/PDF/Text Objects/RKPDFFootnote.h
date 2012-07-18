//
//  RKPDFFootnote.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

@class RKPDFRenderingContext;

/*!
 @abstract A footnote or endnote used inside an attributed string used for PDF rendering
 */
@interface RKPDFFootnote : RKPDFTextObject

/*!
 @abstract Initializes the footnote object with an attributed string that can be used for PDF rendering
 @discussion The given footnote content is automatically converted to core text representation.
 */
- (id)initWithContent:(NSAttributedString *)footnoteContent isEndnote:(BOOL)isEndnote context:(RKPDFRenderingContext *)context;

/*!
 @abstract The anchor of the footnote that can be used to reference it inside a PDF document
 */
@property (nonatomic, strong, readonly) NSString *footnoteAnchor;

/*!
 @abstract The footnote content in core text representation
 */
@property (nonatomic, strong, readonly) NSAttributedString *footnoteContent;

/*!
 @abstract Specifies whether it is a footnote or an endnote
 */
@property (nonatomic, readonly) BOOL isEndnote;

@end
