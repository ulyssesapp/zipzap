//
//  RKListStyle+RKPersistence.m
//  RTFKit
//
//  Created by Friedrich Gräter on 26.06.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#import "RKListStyle+RKPersistence.h"
#import "NSAttributedString+RKPersistence.h"

NSString *RKListStyleLevelFormatsPersistenceKey                 = @"levelFormats";
NSString *RKListStyleLevelStylesPersistenceKey					= @"levelStyles";
NSString *RKListStyleStartNumbersPersistenceKey                 = @"startNumbers";

@implementation RKListStyle (RKPersistence)

- (id)initWithPropertyList:(id)propertyList context:(RKPersistenceContext *)context error:(NSError **)error
{
    NSParameterAssert([propertyList isKindOfClass: NSDictionary.class]);
    
	NSMutableArray *unserializedStyles = [NSMutableArray new];
	for (NSDictionary *serializedStyle in propertyList[RKListStyleLevelStylesPersistenceKey]) {
		NSDictionary *unserializedStyle = [NSAttributedString attributeDictionaryFromRTFKitPropertyListRepresentation:serializedStyle usingContext:context error:error];
		[unserializedStyles addObject: unserializedStyle];
	}
	
    return [self initWithLevelFormats:propertyList[RKListStyleLevelFormatsPersistenceKey] styles:unserializedStyles startNumbers:propertyList[RKListStyleStartNumbersPersistenceKey]];
}

- (id)propertyListRepresentationUsingContext:(RKPersistenceContext *)context
{
    NSMutableDictionary *propertyList = [NSMutableDictionary new];
    
    if (self.levelFormats)
        propertyList[RKListStyleLevelFormatsPersistenceKey] = self.levelFormats;

    if (self.levelStyles) {
		NSMutableArray *serializedStyles = [NSMutableArray new];
		
		for (NSDictionary *unserializedAttributes in self.levelStyles) {
			[serializedStyles addObject: [NSAttributedString RTFKitPropertyListRepresentationForAttributeDictionary:unserializedAttributes usingContext:context]];
		}
			 
		propertyList[RKListStyleLevelStylesPersistenceKey] = serializedStyles;
	}
	   
    if (self.startNumbers)
        propertyList[RKListStyleStartNumbersPersistenceKey] = self.startNumbers;
    
    return propertyList;
}

@end
