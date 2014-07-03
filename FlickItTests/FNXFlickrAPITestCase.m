//
//  FNXFlickrAPITestCase.m
//  FlickIt
//
//  Created by Bill Weakley on 7/3/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FNXFlickrAPI.h"

@interface FNXFlickrAPITestCase : XCTestCase

@end

@implementation FNXFlickrAPITestCase

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

- (FNXFlickrAPI *)createInstance {
    
    return [[FNXFlickrAPI alloc] init];
    
}

- (void)testInitDoesNotReturnNil
{
    XCTAssertNotNil([self createInstance]);
}

@end
