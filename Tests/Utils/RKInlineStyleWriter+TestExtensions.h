//
//  RKInlineStyleWriter+TestExtensions.h
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//
#import "RKInlineStyleWriter.h"

@interface RKInlineStyleWriter (TestExtensions)

+ (void)addTagsForFont:(NSFont *)font toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)addTagsForBackgroundColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;
+ (void)addTagsForForegroundColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)addTagsForUnderlineStyle:(NSNumber *)underlineStyleObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;
+ (void)addTagsForUnderlineColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)addTagsForStrikethroughStyle:(NSNumber *)strikethroughStyleObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;
+ (void)addTagsForStrikethroughColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)addTagsForStrokeWidth:(NSNumber *)strokeWidthObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;
+ (void)addTagsForStrokeColor:(NSColor *)color toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

+ (void)addTagsForShadow:(NSShadow *)shadow toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;
+ (void)addTagsForSuperscriptMode:(NSNumber *)superScriptModeObject toTaggedString:(RKTaggedString *)taggedString inRange:(NSRange)range resources:(RKResourcePool *)resources;

@end
