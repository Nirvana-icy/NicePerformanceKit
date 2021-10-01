//
//  NPKPerfTestCase+GCD.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/29.
//

#import "NPKPerfTestCase.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPKPerfTestCase (GCD)

+ (void)gcdDispatchAsyncToConcurrentQueue;
+ (void)gcdDispatchAsyncToSerialQueue;
+ (void)gcdDispatchSyncToSerialQueue;

@end

NS_ASSUME_NONNULL_END
