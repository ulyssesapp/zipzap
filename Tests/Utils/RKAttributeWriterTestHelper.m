//
//  RKAttributeWriterTestHelper.m
//  RTFKit
//
//  Created by Friedrich Gräter on 10.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKAttributeWriterTestHelper.h"
#import "RKAttributeWriter.h"

@implementation SenTestCase (RKAttributeWriterTestHelper)

- (void)assertResourcelessStyle:(NSString *)styleName withValue:(NSNumber *)style onWriter:(Class)writer expectedTranslation:(NSString *)expectedTranslation
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"abc"];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    
    [writer addTagsForAttribute:styleName value:style effectiveRange:NSMakeRange(1,1) toString:taggedString originalString:attributedString attachmentPolicy:0 resources:nil];
    
    STAssertEqualObjects([taggedString flattenedRTFString], expectedTranslation, @"Invalid style");
    
}

@end
