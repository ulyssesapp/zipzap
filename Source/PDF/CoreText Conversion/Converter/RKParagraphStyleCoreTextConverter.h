//
//  RKParagraphStylePDFConverter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKCoreTextRepresentationConverter.h"

/*!
 @abstract Converts all NSParagraphStyle inside an attributed string to a CTParagraphStyle
 @discussion NSTextList attributes are ignored in favour of RKListItem.
 */
@interface RKParagraphStyleCoreTextConverter : RKCoreTextRepresentationConverter

@end
