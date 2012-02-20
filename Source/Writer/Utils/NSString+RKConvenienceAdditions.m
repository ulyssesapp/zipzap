//
//  NSString+RKConvenienceAdditions.m
//  RTFKit
//
//  Created by Friedrich Gräter on 15.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSString+RKConvenienceAdditions.h"

@implementation NSString (RKConvenienceAdditions)

+ (NSString *)stringWithRTFGroupTag:(NSString *)tag body:(NSString *)body
{
    return [NSString stringWithFormat:@"{\\%@ %@}", tag, body];
}

- (NSArray *)componentsSeparatedByRegularExpression:(NSRegularExpression *)regularExpression
{
    __block NSUInteger lastEnd = 0;
    __block NSMutableArray *components = [NSMutableArray new];
    
    [regularExpression enumerateMatchesInString:self options:0 range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        // Add everything between the last match and the current match
        if (result.range.location > lastEnd)
            [components addObject: [self substringWithRange: NSMakeRange(lastEnd, result.range.location - lastEnd)]];
        
        // Add the current match
        [components addObject: [self substringWithRange: result.range]];
         
        lastEnd = NSMaxRange(result.range);
    }];
    
    // Add remainder, if any
    if (lastEnd < self.length) {
        [components addObject: [self substringWithRange: NSMakeRange(lastEnd, self.length - lastEnd)]];
    }
    
    return components;
}

@end
