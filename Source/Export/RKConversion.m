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
    return [[[self stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"]
                stringByReplacingOccurrencesOfString:@"{" withString:@"\\{"]
                    stringByReplacingOccurrencesOfString:@"}" withString:@"\\}"];
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
