//
//  RKPlaceholderWriterTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 07.02.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKPlaceholderWriter.h"
#import "RKPlaceholderWriterTest.h"

@implementation RKPlaceholderWriterTest

- (void)testGeneratePlaceholderWithPageNumber
{
    NSNumber *placeholder = [NSNumber numberWithInt:RKPlaceholderPageNumber];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@">%C<", NSAttachmentCharacter]];
    
    [RKPlaceholderWriter addTagsForAttribute:RKPlaceholderAttributeName value:placeholder effectiveRange:NSMakeRange(1,1) toString:taggedString originalString:nil attachmentPolicy:0 resources:nil];
    
    // Valid string tagging
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @">\\chpgn<",
                         @"Invalid placeholder generated"
                         );
}

- (void)testGeneratePlaceholderWithSectionNumber
{
    NSNumber *placeholder = [NSNumber numberWithInt:RKPlaceholderSectionNumber];
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:[NSString stringWithFormat:@">%C<", NSAttachmentCharacter]];
    
    [RKPlaceholderWriter addTagsForAttribute:RKPlaceholderAttributeName value:placeholder effectiveRange:NSMakeRange(1,1) toString:taggedString originalString:nil attachmentPolicy:0 resources:nil];
    
    // Valid string tagging
    STAssertEqualObjects([taggedString flattenedRTFString],
                         @">\\sectnum<",
                         @"Invalid placeholder generated"
                         );
}

- (void)testPlaceholdersAreCompatibleToManualReferenceTest
{
    // Sections with placeholder contents
    NSMutableAttributedString *contentA = [[NSMutableAttributedString alloc] 
                                           initWithString:[NSString stringWithFormat:
                                                           @"Section Number: 1 == %C, Page Number: 1 == %C",
                                                           NSAttachmentCharacter, NSAttachmentCharacter
                                                           ]
                                           ];
    
    NSMutableAttributedString *contentB = [[NSMutableAttributedString alloc] 
                                           initWithString:[NSString stringWithFormat:
                                                           @"Section Number: 2 == %C, Page Number: 2 == %C\f"
                                                            "Section Number: 2 == %C, Page Number: 3 == %C",
                                                           NSAttachmentCharacter, NSAttachmentCharacter,
                                                           NSAttachmentCharacter, NSAttachmentCharacter
                                                           ]
                                           ];
    // Set placeholders
    [contentA addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderSectionNumber] range:NSMakeRange(21, 1)];
    [contentA addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderPageNumber] range:NSMakeRange(42, 1)];

    [contentB addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderSectionNumber] range:NSMakeRange(21, 1)];
    [contentB addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderPageNumber] range:NSMakeRange(42, 1)];

    [contentB addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderSectionNumber] range:NSMakeRange(44 + 21, 1)];
    [contentB addAttribute:RKPlaceholderAttributeName value:[NSNumber numberWithInt:RKPlaceholderPageNumber] range:NSMakeRange(44 + 42, 1)];
        
    // Two Sections with different contents
    RKSection *sectionA = [RKSection sectionWithContent:contentA];
    RKSection *sectionB = [RKSection sectionWithContent:contentB];
    
    // This testcase should verify that we can use "Test Data/section.rtf" in order to verify its interpretation with MS Word, Nissus, Mellel etc.    
    RKDocument *document = [RKDocument documentWithSections:[NSArray arrayWithObjects:sectionA, sectionB, nil]];
    NSData *converted = [document RTF];
    
    [self assertRTF: converted withTestDocument: @"placeholder"];
}

@end
