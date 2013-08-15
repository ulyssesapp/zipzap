//
//  RKAttributeWriterTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "SenTestCase+RKAttributeWriterTestHelper.h"
#import "RKAttributeWriter.h"
#import "RKConversion.h"
#import "RKDocument.h"

@implementation SenTestCase (RKAttributeWriterTestHelper)

+ (void)load
{
    // We switch off random list identifiers to allow proper testing
    [RKDocument useRandomListIdentifiers: NO];
}

- (void)assertResourcelessStyle:(NSString *)styleName withValue:(NSNumber *)style onWriter:(Class)writer expectedTranslation:(NSString *)expectedTranslation
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"abc"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    
    [writer addTagsForAttribute:styleName value:style effectiveRange:NSMakeRange(1,1) toString:taggedString originalString:attributedString conversionPolicy:0 resources:nil];
    
    STAssertEqualObjects([taggedString flattenedRTFString], expectedTranslation, @"Invalid style");
    
}

#if !TARGET_OS_IPHONE

+ (id)targetSpecificColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}

+ (id)targetSpecificColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [NSColor rtfColorWithRed:red green:green blue:blue];
}

+ (id)targetSpecificFontWithName:(NSString *)name size:(CGFloat)pointSize
{
    return [NSFont fontWithName:name size:pointSize];
}

#else

+ (id)targetSpecificColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return (__bridge id)CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){red, green, blue, 1.0f});
}

+ (id)targetSpecificColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return (__bridge id)CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){red, green, blue, alpha});
}

+ (id)targetSpecificFontWithName:(NSString *)name size:(CGFloat)pointSize
{
    return (__bridge id)CTFontCreateWithName((__bridge CFStringRef)name, pointSize, NULL);
}

#endif

+ (CGColorRef)cgRGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){red, green, blue, 1.0f});    
}

+ (CGColorRef)cgRGBColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return CGColorCreate(CGColorSpaceCreateDeviceRGB(), (CGFloat[]){red, green, blue, alpha});    
}

@end
