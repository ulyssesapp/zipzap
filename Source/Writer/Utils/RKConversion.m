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
            
            case '\t':
                [escapedString appendString: @"\\tab "];
                break;

            case '\f':
                [escapedString appendString: @"\\page\n"];
                break;                

            case '\n':
            case '\r':
            case RKLineSeparatorCharacter:
                [escapedString appendString: @"\\line\n"];
                break;
                
            default:
                if (currentChar > 127) {
                    // All Non-ASCII are converted to \uN commands
                    [escapedString appendFormat: @"\\u%u ", currentChar];
                }
                else {
                    [escapedString appendFormat: @"%C", currentChar];
                }
        }
    }
    
    return escapedString;
}

- (NSString *)sanitizedFilenameForRTFD
{
    static NSRegularExpression *unsafeFilenameCharsRegExp = nil;
    unsafeFilenameCharsRegExp = (unsafeFilenameCharsRegExp) ?: [NSRegularExpression regularExpressionWithPattern:@"[\\{\\}\\*\\?/\\\\]" options:0 error:NULL];
    
    // Removing diacritic characters
    NSString *sanitizedFilename = [self stringByFoldingWithOptions:NSDiacriticInsensitiveSearch|NSWidthInsensitiveSearch locale:[NSLocale systemLocale]];
    
    // Removing unicode characters
    sanitizedFilename = [[NSString alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    
    // Replace all characters that are used by RTF
    NSMutableString *rtfSafeFilename = [NSMutableString stringWithString: sanitizedFilename];
    
    [unsafeFilenameCharsRegExp replaceMatchesInString:rtfSafeFilename options:0 range:NSMakeRange(0, sanitizedFilename.length) withTemplate:@"_"];
        
    return rtfSafeFilename;
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
    const uint8_t *bytes = [self bytes];
    
    for (NSUInteger position = 0; position < [self length]; position ++) {
        if (!(position % 64) && (position > 0))
            [encoded appendString:@"\n"];
        
        [encoded appendFormat:@"%.2x", (unsigned)bytes[position]];
    }
    
    return encoded;
}

@end

#if !TARGET_OS_IPHONE

@implementation NSColor (RKConversion)

+ (NSColor *)rtfColorFromColor:(NSColor *)color
{
    return [[color colorUsingColorSpaceName: NSCalibratedRGBColorSpace] colorWithAlphaComponent: 1.0]; 
}

+ (NSColor *)rtfColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1];
}

- (CGColorRef)CGColorWithGenericRGBColorSpace
{
    NSColor *rgbColor = [self colorUsingColorSpaceName: NSCalibratedRGBColorSpace];
    
    return CGColorCreateGenericRGB(rgbColor.redComponent, rgbColor.greenComponent, rgbColor.blueComponent, 1.0);    
}

@end 

#endif
