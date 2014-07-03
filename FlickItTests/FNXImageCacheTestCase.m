//
//  FNXImageCacheTestCase.m
//  FlickIt
//
//  Created by Bill Weakley on 7/3/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FNXImageCache.h"

@interface FNXImageCacheTestCase : XCTestCase

@end

@implementation FNXImageCacheTestCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - helper methods

- (FNXImageCache *)createUniqueInstance {
    
    return [[FNXImageCache alloc] init];
    
}

- (FNXImageCache *)getSharedInstance {
    
    return [FNXImageCache sharedImageCache];
    
}

#pragma mark - tests

- (void)testSingletonSharedInstanceCreated {
    
    XCTAssertNotNil([self getSharedInstance]);
    
}

- (void)testSingletonUniqueInstanceCreated {
    
    XCTAssertNotNil([self createUniqueInstance]);
    
}

- (void)testSingletonReturnsSameSharedInstanceTwice {
    
    FNXImageCache *s1 = [self getSharedInstance];
    XCTAssertEqual(s1, [self getSharedInstance]);
    
}

- (void)testSingletonSharedInstanceSeparateFromUniqueInstance {
    
    FNXImageCache *s1 = [self getSharedInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testSingletonReturnsSeparateUniqueInstances {
    
    FNXImageCache *s1 = [self createUniqueInstance];
    XCTAssertNotEqual(s1, [self createUniqueInstance]);
}

- (void)testAddImageMakesIsCachedReturnTrue {
    FNXImageCache *s1 = [self getSharedInstance];
    UIImage *image = [[UIImage alloc] init];
    [s1 addImage:image forURL:@"test"];
    XCTAssertTrue([s1 isCached:@"test"]);
}

- (void)testGetImageReturnsImageThatWasAdded {
    FNXImageCache *s1 = [self getSharedInstance];
    UIImage *image = [[UIImage alloc] init];
    [s1 addImage:image forURL:@"test"];
    XCTAssertEqualObjects(image, [s1 getImageForURL:@"test"]);
}

@end
