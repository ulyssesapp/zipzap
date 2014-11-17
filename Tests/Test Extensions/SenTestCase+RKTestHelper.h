//
//  SenTestCase+RKTestHelper.h
//  RTFKit
//
//  Created by Friedrich Gräter on 21.03.12.
//  Copyright (c) 2012 The Soulmen. All rights reserved.
//

@class RKImageAttachment;

@interface XCTestCase (RKTestHelper)

/*!
 @abstract Reads a test file
 */
- (NSFileWrapper *)testFileWithName:(NSString *)name withExtension:(NSString *)extension;

/*!
 @abstract Reads a test file
 */
- (RKImageAttachment *)imageAttachmentWithName:(NSString *)name withExtension:(NSString *)extension margin:(RKEdgeInsets)margin;

/*!
 @abstract Creates a unique temporary folder.
 */
- (NSURL *)newTemporarySubdirectory;

@end



#define ULAssertEqualRange(__rangeA, __rangeB, __description, __other...)				{\
		NSRange __rangeAValue = (__rangeA);\
		NSRange __rangeBValue = (__rangeB);\
		\
		XCTAssertTrue(NSEqualRanges(__rangeAValue, __rangeBValue), __description, ##__other);\
	}

#define ULAssertEqualSize(__sizeA, __sizeB, __description, __other...)					{\
		CGSize __safeValueA = (__sizeA);\
		CGSize __safeValueB = (__sizeB);\
		\
		XCTAssertTrue(CGSizeEqualToSize(__safeValueA, __safeValueB), __description, ##__other);\
	}

#define ULAssertEqualRect(__rectA, __rectB, __description, __other...)					{\
		CGRect __safeValueA = (__rectA);\
		CGRect __safeValueB = (__rectB);\
		\
		XCTAssertTrue(CGRectEqualToRect(__safeValueA, __safeValueB), __description, ##__other);\
	}

#define ULAssertEqualEdgeInsets(__insetsA, __insetsB, __description, __other...)		{\
		RKEdgeInsets __safeValueA = (__insetsA);\
		RKEdgeInsets __safeValueB = (__insetsB);\
		\
		XCTAssertTrue((__safeValueA.top == __safeValueB.top && __safeValueA.left == __safeValueB.left && __safeValueA.right == __safeValueB.right && __safeValueA.bottom == __safeValueB.bottom), __description, ##__other);\
	}

#define ULAssertEqualStructs(__structA, __structB, __description, __other...)			{\
		typeof(__structA) __structValueA = __structA;\
		typeof(__structB) __structValueB = __structB;\
		\
		XCTAssertTrue([[NSValue value:&__structValueA withObjCType:@encode(typeof(__structValueA))] isEqualToValue: [NSValue value:&__structValueB withObjCType:@encode(typeof(__structValueB))]], __description, ##__other);\
	}
