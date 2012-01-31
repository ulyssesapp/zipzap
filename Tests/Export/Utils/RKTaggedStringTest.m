//
//  RKTaggedStringTest.m
//  RTFKit
//
//  Created by Friedrich Gräter on 27.01.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTaggedString.h"
#import "RKTaggedStringTest.h"
#import "RKTaggedString+TestExtensions.h"

@implementation RKTaggedStringTest

- (RKTaggedString *)sampleStringWithTags
{
    RKTaggedString *taggedString = [RKTaggedString taggedStringWithString:@"äbcd{fg"];
    
    // Simple associations
    [taggedString associateTag:@"1-1" atPosition:1];
    [taggedString associateTag:@"3-1" atPosition:3];
    
    // Multiple associations at the same position, to show position saving
    [taggedString associateTag:@"1-2" atPosition:1];
    [taggedString associateTag:@"1-3" atPosition:1];
    
    [taggedString associateTag:@"4-1" atPosition:4];
    [taggedString associateTag:@"4-2" atPosition:4];
    
    return taggedString;
}

- (void)testExceptions
{
    RKTaggedString *taggedString = [self sampleStringWithTags];
    
    // Exception when leaving the string boundaries
    STAssertThrows([taggedString associateTag:@"8-1" atPosition:8], @"Placement beyond boundaries possible");    
    STAssertThrows([taggedString associateTag:@"1000-1" atPosition:1000], @"Placement beyond boundaries possible");    
    
    
}

- (void)testAssociateTags
{
    RKTaggedString *taggedString = [self sampleStringWithTags];

    // Insert a tag before the first element
    [taggedString associateTag:@"0-1" atPosition:0];
    
    // Append a tag beyond the last element
    [taggedString associateTag:@"7-1" atPosition:7];    
    
    // Verifying index table
    NSDictionary *tagPlacement = [taggedString _getTagPositions];
    
    STAssertEquals(tagPlacement.count, (NSUInteger)5, @"Invalid elements count");
    
    // Verify indices
    NSArray *positionZero = [tagPlacement objectForKey:[NSNumber numberWithUnsignedInt:0]];
    STAssertEquals(positionZero.count, (NSUInteger)1, @"Invalid tag count");
    STAssertEqualObjects([positionZero objectAtIndex:0], @"0-1", @"Invalid tag");
    
    NSArray *positionOne = [tagPlacement objectForKey:[NSNumber numberWithUnsignedInt:1]];
    STAssertEquals(positionOne.count, (NSUInteger)3, @"Invalid tag count");
    STAssertEqualObjects([positionOne objectAtIndex:0], @"1-1", @"Invalid tag");
    STAssertEqualObjects([positionOne objectAtIndex:1], @"1-2", @"Invalid tag");
    STAssertEqualObjects([positionOne objectAtIndex:2], @"1-3", @"Invalid tag");    
    
    NSArray *positionThree = [tagPlacement objectForKey:[NSNumber numberWithUnsignedInt:3]];
    STAssertEquals(positionThree.count, (NSUInteger)1, @"Invalid tag count");
    STAssertEqualObjects([positionThree objectAtIndex:0], @"3-1", @"Invalid tag");
    
    NSArray *positionFour = [tagPlacement objectForKey:[NSNumber numberWithUnsignedInt:4]];
    STAssertEquals(positionFour.count, (NSUInteger)2, @"Invalid tag count");
    STAssertEqualObjects([positionFour objectAtIndex:0], @"4-1", @"Invalid tag");
    STAssertEqualObjects([positionFour objectAtIndex:1], @"4-2", @"Invalid tag");
        
    NSArray *positionSeven = [tagPlacement objectForKey:[NSNumber numberWithUnsignedInt:7]];
    STAssertEquals(positionSeven.count, (NSUInteger)1, @"Invalid tag count");
    STAssertEqualObjects([positionSeven objectAtIndex:0], @"7-1", @"Invalid tag");
}

- (void)testFlatteningWithoutFirstAndLastElement
{
    RKTaggedString *taggedString = [self sampleStringWithTags];

    [taggedString associateTag:@"[tag with different length]" atPosition:1];
    
    NSString *flattened = [taggedString flattenedRTFString];
    
    STAssertEqualObjects(flattened, @"\\u228"
                                     "1-11-21-3[tag with different length]b"
                                     "c"
                                     "3-1d"
                                     "4-14-2\\{"
                                     "f"
                                     "g",
                          @"Flattening failed"
                         );
}

- (void)testFlatteningWithLastElement
{
    RKTaggedString *taggedString = [self sampleStringWithTags];
 
    [taggedString associateTag:@"7-1" atPosition:7];    
    [taggedString associateTag:@"[tag with different length]" atPosition:1];
    
    NSString *flattened = [taggedString flattenedRTFString];
    
    STAssertEqualObjects(flattened, 
                         @"\\u228"
                          "1-11-21-3[tag with different length]b"
                          "c"
                          "3-1d"
                          "4-14-2\\{"
                          "f"
                          "g"
                          "7-1",
                         @"Flattening failed"
                         );
}

- (void)testFlatteningWithFirstElement
{
    RKTaggedString *taggedString = [self sampleStringWithTags];
    
    [taggedString associateTag:@"0-1" atPosition:0];    
    [taggedString associateTag:@"[tag with different length]" atPosition:1];
    
    NSString *flattened = [taggedString flattenedRTFString];
    
    STAssertEqualObjects(flattened, 
                         @"0-1\\u228"
                          "1-11-21-3[tag with different length]b"
                          "c"
                          "3-1d"
                          "4-14-2\\{"
                          "f"
                          "g",
                         @"Flattening failed"
                         );
}

- (void)testFlatteningWithFirstAndLast
{
    RKTaggedString *taggedString = [self sampleStringWithTags];
    
    [taggedString associateTag:@"0-1" atPosition:0];    
    [taggedString associateTag:@"7-1" atPosition:7];    
    [taggedString associateTag:@"[tag with different length]" atPosition:1];
    
    NSString *flattened = [taggedString flattenedRTFString];
    
    STAssertEqualObjects(flattened, 
                         @"0-1\\u228"
                         "1-11-21-3[tag with different length]b"
                         "c"
                         "3-1d"
                         "4-14-2\\{"
                         "f"
                         "g"
                         "7-1",
                         @"Flattening failed"
                         );
}

@end
