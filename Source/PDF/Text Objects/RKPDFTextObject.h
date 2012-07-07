//
//  RKPDFTextObject.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKPDFRenderingContext;

/*!
 @abstract Specifies enumeration options for text objects during PDF rendering
 @const
    RKEnumerateTextObjectForPage          The enumeration index is relative to the number of text objects of the same class used in the currently rendered page. This index is newly calculated for each page.
                                          Requesting the index for the same text object on different pages might lead to different results.
 
    RKEnumerateTextObjectForSection       The enumeration index is relative to the number of text objects of the same class inside the section of the text object
    RKEnumerateTextObjectForDocument      The enumeration index is relative to the number of text objects of the same class inside the current document
 */
typedef enum : NSUInteger {
    RKEnumerateTextObjectForPage          = 0,
    RKEnumerateTextObjectForSection       = 1,
    RKEnumerateTextObjectForDocument      = 2
}RKTextObjectEnumerationPolicy;

/*!
 @abstract (Abstract class) Represents a single-character unit inside an attributed string that requires custom rendering for PDF output
 */
@interface RKPDFTextObject : NSObject

/*!
 @abstract (Abstract) The attribute name from which the text object was derived
 @discussion Used for enumeration
 */
+ (NSString *)originalAttributeName;

/*!
 @abstract An enumeration policy that describes how this particular text object should be enumerated
 */
@property (nonatomic) RKTextObjectEnumerationPolicy enumerationPolicy;

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
