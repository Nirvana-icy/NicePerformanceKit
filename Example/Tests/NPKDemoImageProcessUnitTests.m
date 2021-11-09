//
//  NPKDemoImageProcessUnitTests.m
//  NPKitDemo_Tests
//
//  Created by JinglongBi on 2021/11/8.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

@import XCTest;

#import <NicePerformanceKit/NPKImageCompressTool.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@interface NPKDemoImageProcessUnitTests : XCTestCase

@end

@implementation NPKDemoImageProcessUnitTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testUIImageWithContentOfFile API_AVAILABLE(ios(13)) {
    // This is an example of a performance test case.
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340" withExtension:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imgURL.path];
    }];
}

- (void)testUIImageWithName API_AVAILABLE(ios(13)) {
    // This is an example of a performance test case.
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        UIImage *image = [UIImage imageNamed:@"IMG_6340.png"];
    }];
}

- (void)testUIImageWithNameInAssets API_AVAILABLE(ios(13)) {
    // This is an example of a performance test case.
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        UIImage *image = [UIImage imageNamed:@"IMG_6340_in_Assets"];
    }];
}

- (void)testResizeImgWithContentOfFileByImageIO API_AVAILABLE(ios(13)) {
    // This is an example of a performance test case.
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340" withExtension:@"png"];
        UIImage *resizedImage = [NPKImageCompressTool resizeImageWithImageURL:imgURL expectSize:CGSizeMake(600.f, 800.f)];
    }];
}

- (void)testResizeImageWithContentOfFileByUIImageContext API_AVAILABLE(ios(13)) {
    // This is an example of a performance test case.
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340" withExtension:@"png"];
        UIImage *resizedImage = [NPKBadPerfCase resizeImageWithContentOfFile:imgURL.path expectSize:CGSizeMake(600.f, 800.f)];
    }];
}
//
//- (void)testResizeImageWithContentOfFileInAssetsByUIImageContext API_AVAILABLE(ios(13)) {
//    // This is an example of a performance test case.
//    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
//        NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340_in_Assets" withExtension:@"png"];
//        UIImage *resizedImage = [NPKBadPerfCase resizeImageWithContentOfFile:imgURL.path expectSize:CGSizeMake(600.f, 800.f)];
//    }];
//}

@end
