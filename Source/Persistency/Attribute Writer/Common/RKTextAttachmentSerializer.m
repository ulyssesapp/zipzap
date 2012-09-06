//
//  RKTextAttachmentSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 22.07.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKTextAttachmentSerializer.h"
#import "RKTextAttachment.h"

#import "RKPersistenceContext+PrivateStorageAccessors.h"

NSString *RKTextAttachmentFileIndexPersistenceKey = @"fileIdentifier";

@implementation RKTextAttachmentSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKAttachmentAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if(![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    #if !TARGET_OS_IPHONE
        NSTextAttachment *textAttachment = [NSTextAttachment new];
    #else
        RKTextAttachment *textAttachment = [RKTextAttachment new];
    #endif
    
    NSNumber *fileIndexObject = [propertyList objectForKey: RKTextAttachmentFileIndexPersistenceKey];
    
    if (fileIndexObject)
        textAttachment.fileWrapper = [context fileWrapperForIndex: [fileIndexObject unsignedIntegerValue]];
    
    return textAttachment;
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(id)attributeValue context:(RKPersistenceContext *)context
{
    #if !TARGET_OS_IPHONE
        NSTextAttachment *textAttachment = attributeValue;
    #else
        RKTextAttachment *textAttachment = attributeValue;
    #endif
    
    if (textAttachment.fileWrapper)
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger: [context indexForFileWrapper: textAttachment.fileWrapper]] forKey:RKTextAttachmentFileIndexPersistenceKey];
    else
        return [NSDictionary new];
}

@end
