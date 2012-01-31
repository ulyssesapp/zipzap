//
//  RKUnderlineStyleAttributeWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 31.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKUnderlineStyleAttributeWriter.h"
#import "RKUnderlineStyleAttributeWriterTest.h"

@implementation RKUnderlineStyleAttributeWriterTest

- (void)testUnderlineStyle
{
    RKTaggedString *taggedString;
    
    // Default style
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: 0]
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"abc", @"Invalid underline style");
    
    // Single line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: NSUnderlineStyleSingle] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ul\\ulstyle1 b\\ulnone c", @"Invalid underline style");
    
    // Double line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: NSUnderlineStyleDouble] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldb\\ulstyle9 b\\ulnone c", @"Invalid underline style");
    
    // Thick line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: NSUnderlineStyleThick] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulth\\ulstyle2 b\\ulnone c", @"Invalid underline style");
    
    // Dashed line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleSingle | NSUnderlinePatternDash)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldash\\ulstyle513 b\\ulnone c", @"Invalid underline style");
    
    // Dash-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleSingle | NSUnderlinePatternDashDot)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldashd\\ulstyle769 b\\ulnone c", @"Invalid underline style");
    
    // Dash-Dot-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleSingle | NSUnderlinePatternDashDotDot)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\uldashdd\\ulstyle1025 b\\ulnone c", @"Invalid underline style");
    
    // Thick Dashed line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleThick | NSUnderlinePatternDash)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1)
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdash\\ulstyle514 b\\ulnone c", @"Invalid underline style");
    
    // Thick Dash-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleThick | NSUnderlinePatternDashDot)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdashd\\ulstyle770 b\\ulnone c", @"Invalid underline style");
    
    // Thick Dash-Dot-Dot line
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];    
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleThick | NSUnderlinePatternDashDotDot)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulthdashdd\\ulstyle1026 b\\ulnone c", @"Invalid underline style");
    
    // Wordwise, single underline
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];  
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleSingle | NSUnderlineByWordMask)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulw\\ulstyle32769 b\\ulnone c", @"Invalid underline style");
    
    // Wordwise, double underline (additional styles are placed after \ulw)
    taggedString = [RKTaggedString taggedStringWithString:@"abc"];  
    [RKUnderlineStyleAttributeWriter addTagsForAttribute:[NSNumber numberWithInteger: (NSUnderlineStyleDouble | NSUnderlineByWordMask)] 
                                          toTaggedString:taggedString 
                                                 inRange:NSMakeRange(1,1) 
                                    withAttachmentPolicy:0 
                                               resources:nil];
    STAssertEqualObjects([taggedString flattenedRTFString], @"a\\ulw\\uldb\\ulstyle32777 b\\ulnone c", @"Invalid underline style");
}


@end
