//
//  RKInlineStyleWriter+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKInlineStyleWriter.h"

@interface RKInlineStyleWriter (TestExtensions)

+ (void)tag:(RKTaggedString *)taggedString withFont:(NSFont *)font inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)tag:(RKTaggedString *)taggedString withBackgroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;
+ (void)tag:(RKTaggedString *)taggedString withForegroundColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)tag:(RKTaggedString *)taggedString withUnderlineStyle:(NSUInteger)underlineStyle inRange:(NSRange)range;
+ (void)tag:(RKTaggedString *)taggedString withUnderlineColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)tag:(RKTaggedString *)taggedString withStrikethroughStyle:(NSUInteger)underlineStyle inRange:(NSRange)range;
+ (void)tag:(RKTaggedString *)taggedString withStrikethroughColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)tag:(RKTaggedString *)taggedString withStrokeWidth:(CGFloat)strokeWidth inRange:(NSRange)range;
+ (void)tag:(RKTaggedString *)taggedString withStrokeColor:(NSColor *)color inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)tag:(RKTaggedString *)taggedString withShadowStyle:(NSShadow *)shadow inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)tag:(RKTaggedString *)taggedString withSuperscriptMode:(NSInteger)mode inRange:(NSRange)range;

@end
