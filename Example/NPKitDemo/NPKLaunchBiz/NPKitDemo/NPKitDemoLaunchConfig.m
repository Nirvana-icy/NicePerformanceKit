//
//  NPKitDemoLaunchConfig.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/9/20.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKitDemoLaunchConfig.h"
#import <NicePerformanceKit/NPKLaunchConfigPluginDefinition.h>
#import <NicePerformanceKit/NPKLaunchTaskModel.h>

@implementation NPKitDemoLaunchConfig

/// 注册当前类为启动用的配置类
NPK_LAUNCH_PLUGIN(NPKitDemoLaunchConfig)

- (NSArray *)defaultLaunchList {
    return @[
        @{
            @"name": @"launch_sync",
            @"type": @(NPKLaunchTaskTypeSync),
            @"taskClassList":@[
                    @"NPKitCrashReportInitTask",
                    @"NPKitLoginInitTask",
                ]
        },
        @{
            @"name": @"async_barrier",
            @"type": @(NPKLaunchTaskTypeBarrier),
            @"taskClassList":@[
                    @"NPKitLoggerInitTask",
                    @"NPKitAmapInitTask",
                ]
        },
        @{
            @"name": @"sync_tasks",
            @"type": @(NPKLaunchTaskTypeSync),
            @"taskClassList":@[
                    @"NPKitXXXXInitTask",
                ]
        },
        @{
            @"name": @"free_time_async",
            @"type": @(NPKLaunchTaskTypeAsyncAfterRender),
            @"taskClassList":@[
                    @"NPKitXXXXInitTask",
                ]
        },
    ];
}

@end
