//
//  RKImageAttachmentSerializer.m
//  RTFKit
//
//  Created by Friedrich Gräter on 23.09.13.
//  Copyright (c) 2013 The Soulmen. All rights reserved.
//

#import "RKImageAttachmentSerializer.h"

#import "RKImageAttachment.h"
#import "RKPersistenceContext+PrivateStorageAccessors.h"

NSString *RKImageAttachmentFileIndexPersistenceKey		= @"fileIdentifier";
NSString *RKImageAttachmentMarginTopKey					= @"marginTop";
NSString *RKImageAttachmentMarginLeftKey				= @"marginLeft";
NSString *RKImageAttachmentMarginBottomKey				= @"marginBottom";
NSString *RKImageAttachmentMarginRightKey				= @"marginRight";

@implementation RKImageAttachmentSerializer

+ (void)load
{
    @autoreleasepool {
        [NSAttributedString registerAttributeSerializer:self forAttribute:RKImageAttachmentAttributeName];
    }
}

+ (id)attributeValueForPropertyList:(id)propertyList attributeName:(NSString *)attributeName context:(RKPersistenceContext *)context error:(NSError **)error
{
    if(![propertyList isKindOfClass: NSDictionary.class]) {
        if (error) *error = [self invalidFormatForAttribute:attributeName value:propertyList];
        return nil;
    }
    
    NSNumber *fileIndexObject = propertyList[RKImageAttachmentFileIndexPersistenceKey];
	NSFileWrapper *file;
    if (fileIndexObject)
        file = [context fileWrapperForIndex: [fileIndexObject unsignedIntegerValue]];
    
	NSEdgeInsets margins = NSEdgeInsetsMake([propertyList[RKImageAttachmentMarginTopKey] doubleValue], [propertyList[RKImageAttachmentMarginLeftKey] doubleValue], [propertyList[RKImageAttachmentMarginBottomKey] doubleValue], [propertyList[RKImageAttachmentMarginRightKey] doubleValue]);
	
    return [[RKImageAttachment alloc] initWithFile:file margins:margins];
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(RKImageAttachment *)imageAttachment context:(RKPersistenceContext *)context
{
	NSMutableDictionary *propertyList = [NSMutableDictionary new];
	
    if (imageAttachment.imageFile)
        propertyList[RKImageAttachmentFileIndexPersistenceKey] = [NSNumber numberWithUnsignedInteger: [context indexForFileWrapper: imageAttachment.imageFile]];
	
	propertyList[RKImageAttachmentMarginTopKey] = @(imageAttachment.margins.top);
	propertyList[RKImageAttachmentMarginLeftKey] = @(imageAttachment.margins.left);
	propertyList[RKImageAttachmentMarginBottomKey] = @(imageAttachment.margins.bottom);
	propertyList[RKImageAttachmentMarginRightKey] = @(imageAttachment.margins.right);
	
	return propertyList;
}

@end
