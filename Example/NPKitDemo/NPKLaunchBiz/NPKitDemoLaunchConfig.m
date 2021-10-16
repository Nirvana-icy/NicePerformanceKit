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
            @"name": @"head_sync_task",
            @"type": @(NPKLaunchTaskTypeSync),
            @"taskClassList":@[
                    @"NPKLaunchHeadTaskA",
                    @"NPKLaunchHeadTaskB",
                ]
        },
        @{
            @"name": @"sync_tasks",
            @"type": @(NPKLaunchTaskTypeAsync),
            @"taskClassList":@[
                    @"NPKLaunchHeadTaskA",
                    @"NPKLaunchHeadTaskB",
                ]
        },
        @{
            @"name": @"async_barrier_task",
            @"type": @(NPKLaunchTaskTypeBarrier),
            @"taskClassList":@[
                    @"NPKLaunchHeadTaskA",
                    @"NPKLaunchHeadTaskB",
                ]
        },
        @{
            @"name": @"tail_task",
            @"type": @(NPKLaunchTaskTypeAsyncAfterRender),
            @"taskClassList":@[
                    @"NPKLaunchHeadTaskA",
                ]
        },
    ];
}

@end
