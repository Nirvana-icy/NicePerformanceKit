//
//  NPKCommonUnitTests.m
//  NPKCommonUnitTests
//
//  Created by jinglong.bi@me.com on 09/09/2021.
//  Copyright (c) 2021 jinglong.bi@me.com. All rights reserved.
//

@import XCTest;
#import <NicePerformanceKit/NPKPerfTestCase+GCD.h>

@interface NPKCommonUnitTests : XCTestCase

@end

@implementation NPKCommonUnitTests

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

- (void)testExample API_AVAILABLE(ios(13))
{
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        [NPKPerfTestCase gcdDispatchAsyncToConcurrentQueue];
    }];
}

- (void)testThreadsPool API_AVAILABLE(ios(13))
{
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        [NPKPerfTestCase gcdDispatchAsyncToQueuePool];
    }];
}

- (void)testDateFormatterPerf API_AVAILABLE(ios(13))
{
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        NSDateFormatter *newDateForMatter = [[NSDateFormatter alloc] init];
        [newDateForMatter setDateFormat:@"yyyy-MM-dd"];
        NSString *str = [newDateForMatter stringFromDate:[NSDate date]];
    }];
}

- (void)testTimeIntervalPerf API_AVAILABLE(ios(13))
{
    [self measureWithMetrics:@[[XCTClockMetric new], [XCTMemoryMetric new], [XCTCPUMetric new]] block:^{
        time_t timeInterval = [NSDate date].timeIntervalSince1970;
        struct tm *cTime = localtime(&timeInterval);
        NSString *str = [NSString stringWithFormat:@"%d-%02d-%02d", cTime->tm_year + 1900, cTime->tm_mon + 1, cTime->tm_mday];
    }];
}

@end

