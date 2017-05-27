//
//  TableControllerTest.m
//  FileAnlyze
//
//  Created by Lily li on 2017/5/26.
//  Copyright © 2017年 Cisco. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TableController.h"

@interface TableControllerTest : XCTestCase
{
    TableController *control;
}

@end

@implementation TableControllerTest

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
- (void)testDateForNow
{
    NSString *expectedResult = @"1705.27";
    NSString *result = [TableController dateForNow];
   // NSString *result = @"1705.26";
    XCTAssertEqualObjects(expectedResult, result);
    
}
@end
