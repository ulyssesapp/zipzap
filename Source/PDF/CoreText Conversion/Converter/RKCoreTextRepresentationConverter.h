//
//  RKCoreTextRepresentationConverter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext;

/*!
 @abstract A class used for converting an attribute to a certain CoreText style used for PDF output
 */
@interface RKCoreTextRepresentationConverter : NSObject

/*!
 @abstract Converts the given attributed string to its core text representation according to the converter rules
 */
+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context;

@end
