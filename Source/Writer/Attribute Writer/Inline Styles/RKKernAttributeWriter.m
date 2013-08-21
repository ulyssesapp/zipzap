//
//  RKKernAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 21.08.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKKernAttributeWriter.h"

@implementation RKKernAttributeWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKKernAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    }
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)kerningObject resources:(RKResourcePool *)resources
{
    CGFloat kerning = [kerningObject doubleValue];
	if (!kerning)
		return @"";
	
    return [NSString stringWithFormat:@"\\kerning1\\expnd%li\\expndtw%li ", (NSInteger)kerning, (NSInteger)(kerning * 20)];
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(NSNumber *)kerningObject resources:(RKResourcePool *)resources
{
    CGFloat kerning = [kerningObject doubleValue];
	if (!kerning)
		return @"";
	
    return @"\\kerning0\\expnd0\\expndtw0 ";
}

@end

