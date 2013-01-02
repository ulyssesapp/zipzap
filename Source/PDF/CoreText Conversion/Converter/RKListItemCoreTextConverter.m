//
//  RKListItemPDFConverter.m
//  RTFKit
//
//  Created by Friedrich Gräter on 05.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListItemCoreTextConverter.h"
#import "RTFKit.h"
#import "RKListStyle+WriterAdditions.h"
#import "RKListCounter.h"
#import "RKPDFRenderingContext.h"

#import "NSAttributedString+PDFCoreTextConversion.h"

@implementation RKListItemCoreTextConverter

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerConverter: self];
    }
}

+ (NSAttributedString *)coreTextRepresentationForAttributedString:(NSAttributedString *)attributedString usingContext:(RKPDFRenderingContext *)context
{
    NSMutableAttributedString *converted = [attributedString mutableCopy];
    __block NSUInteger insertionOffset = 0;
    
    [attributedString enumerateAttribute:RKTextListItemAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(RKListItem *listItem, NSRange range, BOOL *stop) {
        if (!listItem)
            return;
        
        // Insert marker string (include a tab behave the same as the cocoa text engine)
        NSString *markerString = [NSString stringWithFormat:@"\t%@\t", [context.listCounter markerForListItem: listItem]];
        NSAttributedString *styledMarkerString = [[NSAttributedString alloc] initWithString:markerString attributes:[attributedString attributesAtIndex:range.location effectiveRange:NULL]];
        
        [converted insertAttributedString:styledMarkerString atIndex:range.location + insertionOffset];
        insertionOffset += markerString.length;
        
        // Remove text list item attribute
        [converted removeAttribute:RKTextListItemAttributeName range:range];
    }];
    
    return converted;
}

@end
