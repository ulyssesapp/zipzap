//
//  RKConversion.m
//  RTFKit
//
//  Created by Friedrich Gräter on 25.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKConversion.h"

@implementation NSString (RKConversion)

- (NSString *)RTFEscapedString
{
    NSMutableString *escapedString = [NSMutableString new];
    
    for (NSUInteger position = 0; position < [self length]; position ++) {
        unichar currentChar = [self characterAtIndex:position];
        
        switch (currentChar) {
            // Charracters that have to be escaped due to the RTF standard
            case '\\':
            case '}':
            case '{':
                [escapedString appendFormat: @"\\%C", currentChar];
                break;
                
            case '\n':
                [escapedString appendString: @"\\line\n"];
                break;
                
            default:
                if (currentChar > 127) {
                    // All Non-ASCII are converted to \uN commands
                    [escapedString appendFormat: @"\\u%u", currentChar];
                }
                else {
                    [escapedString appendFormat: @"%C", currentChar];
                }
        }
    }
    
    return escapedString;
}

@end

@implementation NSDate (RKConversion)

- (NSString *)RTFDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];

    [dateFormatter setDateFormat:@"'\\yr'yyyy '\\mo'M '\\dy'd '\\hr'H '\\min'm '\\sec's"];
    
    return [dateFormatter stringFromDate:self];  
}

@end

@implementation NSData (RKConversion)

- (NSString *)stringWithRTFHexEncoding
{
    NSMutableString *encoded = [NSMutableString new];
    const unsigned char *bytes = [self bytes];
    
    for (NSUInteger position = 0; position < [self length]; position ++) {
        if (!(position % 64) && (position > 0))
            [encoded appendString:@"\n"];
        
        [encoded appendFormat:@"%.2x", (unsigned)bytes[position]];
    }
    
    return encoded;
}

@end

@implementation NSColor (RKConversion)

+ (NSColor *)rtfColorFromColor:(NSColor *)color
{
    return [[color colorUsingColorSpaceName: NSCalibratedRGBColorSpace] colorWithAlphaComponent: 1.0]; 
}

+ (NSColor *)rtfColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1];
}

@end    
