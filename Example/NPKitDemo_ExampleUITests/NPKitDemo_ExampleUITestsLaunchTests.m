//
//  NPKitDemo_ExampleUITestsLaunchTests.m
//  NPKitDemo_ExampleUITests
//
//  Created by JinglongBi on 2021/10/9.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NPKitDemo_ExampleUITestsLaunchTests : XCTestCase

@end

@implementation NPKitDemo_ExampleUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
    return YES;
}

- (void)setUp {
    self.continueAfterFailure = NO;
}

- (void)testLaunch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Insert steps here to perform after app launch but before taking a screenshot,
    // such as logging into a test account or navigating somewhere in the app

    XCTAttachment *attachment = [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
    attachment.name = @"Launch Screen";
    attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
    [self addAttachment:attachment];
}

@end
