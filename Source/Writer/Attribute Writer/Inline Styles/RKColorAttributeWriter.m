//
//  RKColorAttributeWriter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributedStringWriter.h"
#import "RKColorAttributeWriter.h"
#import "RKConversion.h"

@interface RKColorAttributeWriter ()

/*!
 @abstract Creates a color tag for the given attribute name and color index.
 @discussion If color is NSNotFound, a default color setting will be used.
 */
+ (NSString *)openingTagsForAttribute:(NSString *)attributeName colorIndex:(NSUInteger)colorIndex;

@end

@implementation RKColorAttributeWriter

+ (void)load
{
    @autoreleasepool {
        [RKAttributedStringWriter registerWriter:self forAttribute:RKBackgroundColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
        [RKAttributedStringWriter registerWriter:self forAttribute:RKForegroundColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
        [RKAttributedStringWriter registerWriter:self forAttribute:RKUnderlineColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
        [RKAttributedStringWriter registerWriter:self forAttribute:RKStrikethroughColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
        [RKAttributedStringWriter registerWriter:self forAttribute:RKStrokeColorAttributeName priority:RKAttributedStringWriterPriorityInlineStyleLevel];
    }
}
    
+ (NSString *)openingTagsForAttribute:(NSString *)attributeName colorIndex:(NSUInteger)colorIndex
{
    static NSDictionary *colorTags = nil;
    static NSDictionary *defaultColorTags = nil;
    
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		colorTags = @{RKBackgroundColorAttributeName: @"\\cb",
					  RKForegroundColorAttributeName: @"\\cf",
					  RKUnderlineColorAttributeName: @"\\ulc",
					  RKStrikethroughColorAttributeName: @"\\strikec",
					  RKStrokeColorAttributeName: @"\\strokec"};
		
		// There are different default colors for background (= 1) and stroke styles (= 0)
		// We may not use \\ulc0 since it will activate underlining in OpenOffice
		defaultColorTags = @{RKBackgroundColorAttributeName: @"\\cb1 ",
							 RKForegroundColorAttributeName: @"\\cf0 ",
							 RKUnderlineColorAttributeName: @"",
							 RKStrikethroughColorAttributeName: @"\\strikec0 ",
							 RKStrokeColorAttributeName: @"\\strokec0 "};
	});
	
    
    if (colorIndex != NSNotFound) {
        return [NSString stringWithFormat:@"%@%lu ", colorTags[attributeName], colorIndex];        
    }
    else {
        return defaultColorTags[attributeName];
    }    
}

+ (NSString *)openingTagsForAttribute:(NSString *)attributeName value:(id)colorObject resources:(RKResourcePool *)resources
{
	NSUInteger colorIndex = NSNotFound;
	
	if (colorObject) {
		CGColorRef color;
		
#if !TARGET_OS_IPHONE
		color = [colorObject newCGColorUsingGenericRGBColorSpace];
#else
		color = [colorObject CGColor];
#endif
		
		colorIndex = [resources indexOfColor: color];
		
#if !TARGET_OS_IPHONE
		CGColorRelease(color);
#endif
	}
	
	return [self.class openingTagsForAttribute:attributeName colorIndex:colorIndex];
}

+ (NSString *)closingTagsForAttribute:(NSString *)attributeName value:(id)value resources:(RKResourcePool *)resources
{
    // We have to unset the underline color, to by compatible when re-reading RTF with the text system
    // However, we should only unset if, if it was not set before, otherwise it will activate underlining in OpenOffice...
    if ([attributeName isEqual: RKUnderlineColorAttributeName] && (value))
        return @"\\ulc0 ";
    
    return @"";
}

@end
