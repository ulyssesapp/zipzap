//
//  NSTextAttachment+RKPersistency.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "NSTextAttachment+RKPersistency.h"
#import "RKPersistencyContext.h"

NSString *NSTextAttachmentFileIndexPersistencyKey = @"fileIdentifier";

@implementation NSTextAttachment (RKPersistency)

+ (id<RKPersistency>)instanceWithRTFKitPropertyListRepresentation:(id)propertyList usingContext:(RKPersistencyContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);

    NSTextAttachment *textAttachment = [NSTextAttachment new];
    textAttachment.fileWrapper = [context fileWrapperForIndex: [propertyList[NSTextAttachmentFileIndexPersistencyKey] unsignedIntegerValue]];
    
    return textAttachment;
}

- (id)RTFKitPropertyListRepresentationUsingContext:(RKPersistencyContext *)context
{
    return @{
        NSTextAttachmentFileIndexPersistencyKey:      @([context indexForFileWrapper: self.fileWrapper])
    };
}

@end
