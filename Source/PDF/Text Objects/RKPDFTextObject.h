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
 @abstract (Abstract class) Represents a placeholder inside an attributed string that has content which is determined during rendering and uses a custom renderer
 */
@interface RKPDFTextObject : NSObject

/*!
 @abstract An enumeration policy that describes how this particular text object should be enumerated
 */
@property (nonatomic) RKTextObjectEnumerationPolicy enumerationPolicy;

/*!
 @abstract (Semi-Abstract) Re-Renders the actual object using a rendering context
 @discussion If not overriden, this method just does nothing.
 */
- (void)renderUsingContext:(RKPDFRenderingContext *)context rect:(CGRect)rect;

/*!
 @abstract Provides a replacement string for the text object according to the current context
 @discussion Receives the attributed string and the index of the text object and the size of the frame that is currently created.
 */
- (NSAttributedString *)replacementStringUsingContext:(RKPDFRenderingContext *)context attributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)atIndex frameSize:(CGSize)size;

@end
