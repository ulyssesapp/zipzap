//
//  RKFootNoteWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 03.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKFootNoteWriter.h"
#import "RKFootNoteWriterTest.h"

@implementation RKFootNoteWriterTest

- (void)testGenerateFootNote
{
    RKResourcePool *resources = [RKResourcePool new];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"aaa"];
    
    [content addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Menlo" size:16] range:NSMakeRange(0, 3)];
    
    RKFootNote *footNote = [RKFootNote footNoteWithAttributedString:content];
    NSString *string = [NSString stringWithFormat:@">%c<", NSAttachmentCharacter];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:string];
    
    [RKFootNoteWriter addTagsForAttribute:footNote toTaggedString:taggedString inRange:NSMakeRange(1,1) withAttachmentPolicy:0 resources:resources];
    
    // Valid string tagging
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @">{\\footnote \\pard\\ql \\cb1 \\f0 \\fs16 \\cf0 aaa\\par\n}<",
                         @"Invalid footnote generated"
                         );
    
    // Font was collected
    STAssertEquals(resources.fontFamilyNames.count, (NSUInteger)1, @"Invalid count of fonts");
    STAssertEqualObjects([resources.fontFamilyNames objectAtIndex:0], @"Menlo-Regular", @"Missing font");    

}

@end
