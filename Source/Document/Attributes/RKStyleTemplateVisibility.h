//
//  RKStyleTemplateVisibility.h
//  RTFKit
//
//  Created by Lucas Hauswald on 19.02.16.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

/*!
 @abstract Specifies how the style template should be shown in Word.
 */
extern NSString *RKStyleTemplateVisibilityAttributeName;

/*!
 @abstract Specifies how the style template should be shown in Word.
 
 @const RKStyleTemplateVisibilityAlways		Style template should always be visible.
 @const RKStyleTemplateVisibilityWhenUsed	Style template should only be visible when used.
 @const RKStyleTemplateVisibilityNever		Style template should never be shown.
 */
typedef enum : NSUInteger {
	RKStyleTemplateVisibilityAlways,
	RKStyleTemplateVisibilityWhenUsed,
	RKStyleTemplateVisibilityNever
} RKStyleTemplateVisibility;
