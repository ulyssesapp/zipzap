//
//  RKPDFPlaceholder.h
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPDFTextObject.h"

/*!
 @abstract A placeholder inside an attributed string used for PDF rendering
 */
@interface RKPDFPlaceholder : RKPDFTextObject

/*!
 @abstract Initializes the placeholder using a placeholder type
 */
- (id)initWithPlaceholderType:(RKPlaceholderType)placeholderType;

/*!
 @abstract The placeholder type of the placeholder
 */
@property (nonatomic, readonly) RKPlaceholderType placeholderType;

@end
