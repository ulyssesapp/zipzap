//
//  RKPDFStrikethroughRenderer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextRenderer.h"

/*!
 @abstract The attributed used to describe the underline that should be applied by the RKPDFTextDecorationRenderer
 @discussion Required, since CoreText renders underlines since 10.9 when using run-wise rendering. See kCTUnderlineAttributeName.
 */
extern NSString *RKPDFRendererUnderlineAttributeName;

/*!
 @abstract The attribute used to describe the underline color in a core text representation
 @discussion References a CGColorRef
 */
extern NSString *RKPDFRendererUnderlineColorAttributeName;


/*!
 @abstract The attributed used to describe the strikethrough that should be applied by the RKPDFTextDecorationRenderer
 @discussion Required, since CoreText renders underlines since 10.9 when using run-wise rendering. See kCTUnderlineAttributeName.
 */
extern NSString *RKPDFRendererStrikethroughAttributeName;

/*!
 @abstract The attribute used to describe the strikethrough color in a core text representation
 @discussion References a CGColorRef
 */
extern NSString *RKPDFRendererStrikethroughColorAttributeName;


/*!
 @abstract Renders underlining and strikethrough attributes.
 @discussion Uses RKPDFRendererUnderlineAttributeName, RKPDFRendererUnderlineColorAttributeName, RKPDFRendererStrikethroughAttributeName, RKPDFRendererStrikethroughColorAttributeName attributes. Make sure to unset kCTUnderlineAttributeName and kCTStrikethroughAttributeName, since these attributes are interpreted differently among different CoreText versions.
 */
@interface RKPDFTextDecorationRenderer : RKPDFTextRenderer

@end
