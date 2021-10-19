//
//  NPKLaunchConfig.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/20.
//

#import "NPKLaunchConfig.h"
#import <NicePerformanceKit/NPKLaunchTaskModel.h>

@implementation NPKLaunchConfig

- (NSArray *)defaultLaunchList {
    BOOL b_optimEnable = YES;
    
    if (b_optimEnable) {
        return [self newLaunchList];
    } else {
        return [self oldLaunchList];
    }
}

- (NSArray *)oldLaunchList {
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

- (NSArray *)newLaunchList {
    return @[
        @{
            @"name": @"head_sync_task",
            @"type": @(NPKLaunchTaskTypeSync),
            @"taskClassList":@[
                ]
        },
        @{
            @"name": @"async_tasks",
            @"type": @(NPKLaunchTaskTypeAsync),
            @"taskClassList":@[
                ]
        },
        @{
            @"name": @"tail_async_barrier_task",
            @"type": @(NPKLaunchTaskTypeBarrier),
            @"taskClassList":@[
                @"NPKMockLaunchTaskA",
                @"NPKMockLaunchTaskB",
                @"NPKPerfMonitorInitTask",
                @"NPKMockLaunchTaskC",
                @"NPKMockLaunchTaskD",
                ]
        },
        @{
            @"name": @"idle_task",
            @"type": @(NPKLaunchTaskTypeAsyncAfterRender),
            @"taskClassList":@[
                @"NPKMockLaunchTaskE"
                ]
        },
    ];
}

@end
