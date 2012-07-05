//
//  RKPDFRepresentationConverter.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext;

/*!
 @abstract A class used for converting an attribute to a certain CoreText style used for PDF output
 */
@interface RKPDFRepresentationConverter : NSObject

/*!
 @abstract Converts the given attributed string to its PDF representation according to the converter rules
 */
+ (void)applyPDFConversionToAttributedString:(NSMutableAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context;

@end
