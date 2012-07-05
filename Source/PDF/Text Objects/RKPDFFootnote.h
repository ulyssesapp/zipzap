//
//  RKPDFFootnote.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

/*!
 @abstract A footnote or endnote used inside an attributed string used for PDF rendering
 */
@interface RKPDFFootnote : RKPDFTextObject

/*!
 @abstract Initializes the footnote object with an attributed string that can be used for PDF rendering
 */
- (id)initWithContent:(NSAttributedString *)footnoteContent isEndnote:(BOOL)isEndnote;

@end
