//
//  NPKLaunchConfig.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/20.
//

#import "NPKLaunchConfig.h"
#import <NicePerformanceKit/NPKLaunchTaskModel.h>

@implementation NPKLaunchConfig

//- (NSArray *)defaultLaunchList {
//    NSAssert(NO, @"You should override this method after inheriting NPKLaunchConfig.");
//    return nil;
//}

- (NSArray *)defaultLaunchList {
    return @[
        @{
            @"name": @"head_sync_task",
            @"type": @(NPKLaunchTaskTypeSync),
            @"taskClassList":@[
                    @"NPKMockLaunchTaskA",
                    @"NPKMockLaunchTaskB",
                    @"NPKPerfMonitorInitTask",
                    @"NPKMockLaunchTaskC",
                    @"NPKMockLaunchTaskD",
                    @"NPKMockLaunchTaskE",
                ]
        },
        @{
            @"name": @"async_tasks",
            @"type": @(NPKLaunchTaskTypeAsync),
            @"taskClassList":@[
                    
                ]
        },
        @{
            @"name": @"async_barrier_task",
            @"type": @(NPKLaunchTaskTypeBarrier),
            @"taskClassList":@[
                
                ]
        },
        @{
            @"name": @"tail_task",
            @"type": @(NPKLaunchTaskTypeAsyncAfterRender),
            @"taskClassList":@[
                
                ]
        },
    ];
}

//- (NSArray *)defaultLaunchList {
//    return @[
//        @{
//            @"name": @"head_sync_task",
//            @"type": @(NPKLaunchTaskTypeSync),
//            @"taskClassList":@[
//                    @"NPKMockLaunchTaskA",
//                ]
//        },
//        @{
//            @"name": @"async_tasks",
//            @"type": @(NPKLaunchTaskTypeAsync),
//            @"taskClassList":@[
//                    @"NPKMockLaunchTaskB",
//                    @"NPKPerfMonitorInitTask",
//                    @"NPKMockLaunchTaskC",
//                ]
//        },
//        @{
//            @"name": @"async_barrier_task",
//            @"type": @(NPKLaunchTaskTypeBarrier),
//            @"taskClassList":@[
//                @"NPKMockLaunchTaskD",
//                ]
//        },
//        @{
//            @"name": @"tail_task",
//            @"type": @(NPKLaunchTaskTypeAsyncAfterRender),
//            @"taskClassList":@[
//                @"NPKMockLaunchTaskE"
//                ]
//        },
//    ];
//}

@end
