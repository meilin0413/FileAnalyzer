//
//  NSString+pathAnalyzeTest.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/26.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+pathAnlyze.h"
@interface NSString_pathAnalyzeTest : XCTestCase

@end

@implementation NSString_pathAnalyzeTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDeletePathComponentBeforeMeet
{
    NSString *path = @"agdag";
    NSString *result = [path deletePathComponentBeforeMeet:@""];
    NSString *expectedResult = @"agdag";
    XCTAssertEqualObjects(result, expectedResult);
    path = @"/gabog/noab/gae/noab";
    expectedResult = @"/gabog";
    result = [path deletePathComponentBeforeMeet:@"noab"];
    XCTAssertEqualObjects(expectedResult, result);
    
}

@end
