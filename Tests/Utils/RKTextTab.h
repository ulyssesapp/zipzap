//
//  RKTextTab.h
//  RTFKit
//
//  Created by Friedrich Gräter on 19.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

#if !TARGET_OS_IPHONE

#define RKLeftTabStopType           NSLeftTabStopType
#define RKCenterTabStopType         NSCenterTabStopType
#define RKRightTabStopType          NSRightTabStopType
#define RKDecimalTabStopType        NSDecimalTabStopType

#else

#define RKLeftTabStopType           kCTLeftTextAlignment
#define RKCenterTabStopType         kCTCenterTextAlignment
#define RKRightTabStopType          kCTRightTextAlignment
#define RKDecimalTabStopType        kCTJustifiedTextAlignment

#endif

/*!
 @abstract Provides a replacement for NSTextTab
 */
@interface RKTextTab : NSObject

@property (nonatomic) NSUInteger tabStopType;
@property (nonatomic) CGFloat location;

- (id)initWithTabStopType:(NSUInteger)tabStopType location:(CGFloat)location;

+ (RKTextTab *)textTabFromCoreTextRepresentation:(CTTextTabRef)textTab;

- (CTTextTabRef)coreTextRepresentation;

+ (RKTextTab *)textTabFromTargetSpecificRepresentation:(id)textTab;

- (id)targetSpecificRepresentation;

@end