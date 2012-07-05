//
//  RKPDFTextObject.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext;

/*!
 @abstract (Abstract class) Represents a single-character unit inside an attributed string that requires custom rendering for PDF output
 */
@interface RKPDFTextObject : NSObject

/*!
 @abstract (Abstract) The attribute name used to represent this kind of text object
 */
+ (NSString *)attributeName;

/*!
 @abstract (Abstract) Renders the object using a rendering context
 */
- (void)renderUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex;

/*!
 @abstract (Abstract) Determines the rendering width of a text object
 */
- (CGFloat)widthUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex;

/*!
 @abstract (Abstract) Determines the line ascent height of a text object
 */
- (CGFloat)lineAscentUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex;

/*!
 @abstract (Abstract) Determines the line descent height of a text object
 */
- (CGFloat)lineDescentUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex;

@end
