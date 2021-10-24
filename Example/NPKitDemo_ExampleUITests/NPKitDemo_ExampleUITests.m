//
//  NPKitDemo_ExampleUITests.m
//  NPKitDemo_ExampleUITests
//
//  Created by JinglongBi on 2021/10/9.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NPKitDemo_ExampleUITests : XCTestCase

@end

@implementation NPKitDemo_ExampleUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 14.0, tvOS 13.0, watchOS 7.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] initWithWaitUntilResponsive:YES]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
