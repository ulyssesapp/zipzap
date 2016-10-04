//
//  RKUtilityTest.m
//  RTFKit
//
//  Created by Lucas Hauswald on 04/10/2016.
//  Copyright © 2016 The Soulmen. All rights reserved.
//

@interface RKUtilityTest : XCTestCase

@end

@implementation RKUtilityTest

- (void)testMacroConversionPointsToTwips
{
	CGFloat originalValue = 93.826771653543303;
	
	NSInteger convertedValue = RKPointsToTwips(originalValue);
	
	NSAssert(convertedValue == 1876, @"Precision error when converting values using the RKPointsToTwips() macro. Converted value is %ld, should be %ld instead.", convertedValue, (long)(originalValue * 20));
}

- (void)testMacroConversionTwipsToPoints
{
	CGFloat originalValue = 1876.535433070866;
	
	NSInteger convertedValue = RKTwipsToPoints(originalValue);
	
	NSAssert(convertedValue == 93, @"Precision error when converting values using the RKTwipsToPoints() macro. Converted value is %ld, should be %ld instead.", convertedValue, (long)(originalValue / 20));
}

- (void)testMacroConversionPointsToEMUs
{
	CGFloat originalValue = 93.826771653543303;
	
	NSInteger convertedValue = RKPointsToEMUs(originalValue);
	
	NSAssert(convertedValue == 1191600, @"Precision error when converting values using the RKPointsToEMUs macro. Converted value is %ld, should be %ld instead.", convertedValue, (long)(originalValue * 12700));
}

@end
