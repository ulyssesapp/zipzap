//
//  RKAttributeWriterTest.h
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@interface SenTestCase (RKAttributeWriterTestHelper)

/*!
 @abstract Asserts whether a certain style will be translated correctly
 @discussion The translation of the style does not require a resource pool or an attachment policy
 */
- (void)assertResourcelessStyle:(NSString *)styleName withValue:(NSNumber *)style onWriter:(Class)writer expectedTranslation:(NSString *)expectedTranslation;

@end
