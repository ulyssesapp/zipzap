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
NSString *RKImageAttachmentWidthKey						= @"width";
NSString *RKImageAttachmentHeightKey					= @"height";

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
    
	RKEdgeInsets margin = RKEdgeInsetsMake([propertyList[RKImageAttachmentMarginTopKey] doubleValue], [propertyList[RKImageAttachmentMarginLeftKey] doubleValue], [propertyList[RKImageAttachmentMarginBottomKey] doubleValue], [propertyList[RKImageAttachmentMarginRightKey] doubleValue]);
	
	CGSize size = CGSizeMake([propertyList[RKImageAttachmentWidthKey] doubleValue], [propertyList[RKImageAttachmentHeightKey] doubleValue]);
	return [[RKImageAttachment alloc] initWithFile:file title:nil description:nil margin:margin size:size];
}

+ (id)propertyListForAttribute:(NSString *)attributeName value:(RKImageAttachment *)imageAttachment context:(RKPersistenceContext *)context
{
	NSMutableDictionary *propertyList = [NSMutableDictionary new];
	
    if (imageAttachment.imageFile)
        propertyList[RKImageAttachmentFileIndexPersistenceKey] = [NSNumber numberWithUnsignedInteger: [context indexForFileWrapper: imageAttachment.imageFile]];
	
	propertyList[RKImageAttachmentMarginTopKey] = @(imageAttachment.margin.top);
	propertyList[RKImageAttachmentMarginLeftKey] = @(imageAttachment.margin.left);
	propertyList[RKImageAttachmentMarginBottomKey] = @(imageAttachment.margin.bottom);
	propertyList[RKImageAttachmentMarginRightKey] = @(imageAttachment.margin.right);
	propertyList[RKImageAttachmentWidthKey] = @(imageAttachment.size.width);
	propertyList[RKImageAttachmentHeightKey] = @(imageAttachment.size.height);
	
	return propertyList;
}

@end
