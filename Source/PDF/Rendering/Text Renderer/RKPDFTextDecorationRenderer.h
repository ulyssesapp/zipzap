//
//  RKPDFStrikethroughRenderer.h
//  RTFKit
//
//  Created by Friedrich Gräter on 10.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextRenderer.h"

/*!
 @abstract The attribute used to describe the strikethrough color in a core text representation
 @discussion References a CGColorRef
 */
extern NSString *RKPDFStrikethroughColorAttributeName;

@interface RKPDFTextDecorationRenderer : RKPDFTextRenderer

@end
