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
                [escapedString appendFormat:@"\\%c", currentChar];
                break;
                
            default:
                if (currentChar > 127) {
                    // All Non-ASCII are converted to \uN commands
                    [escapedString appendFormat:@"\\u%u", currentChar];
                }
                else {
                    [escapedString appendFormat:@"%c", currentChar];
                }
        }
    }
    
    return escapedString;
}

@end

@implementation NSDate (RKConversion)

- (NSString *)RTFDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"'\\yr'yyyy '\\mo'M '\\dy'd '\\hr'H '\\min'm '\\sec's"];
    
    return [dateFormatter stringFromDate:self];  
}

@end
