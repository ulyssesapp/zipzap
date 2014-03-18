//
//  RKAttributeWriterTest.h
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface XCTestCase (RKAttributeWriterTestHelper)

/*!
 @abstract Asserts whether a certain style will be translated correctly
 @discussion The translation of the style does not require a resource pool or an attachment policy
 */
- (void)assertResourcelessStyle:(NSString *)styleName withValue:(NSNumber *)style onWriter:(Class)writer expectedTranslation:(NSString *)expectedTranslation;

/*!
 @abstract Returns a font object that is instance of a type fitting to the current target
 */
+ (id)targetSpecificFontWithName:(NSString *)name size:(CGFloat)pointSize;

/*!
 @abstract Returns an RGB color that is instance of a type fitting to the current target
 */
+ (id)targetSpecificColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/*!
 @abstract Returns an RGB color that is instance of a type fitting to the current target
 */
+ (id)targetSpecificColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/*!
 @abstract Returns an RGB color as CGColor
 */
+ (CGColorRef)cgRGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/*!
 @abstract Returns an RGBA color as CGColor
 */
+ (CGColorRef)cgRGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
