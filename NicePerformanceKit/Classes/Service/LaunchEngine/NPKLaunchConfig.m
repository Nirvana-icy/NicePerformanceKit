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
    return @[
//        @{
//            @"name": @"async_tasks",
//            @"type": @(NPKLaunchTaskTypeAsync),
//            @"taskClassList":@[
//                ]
//        },
//        @{
//            @"name": @"head_sync_task",
//            @"type": @(NPKLaunchTaskTypeSync),
//            @"taskClassList":@[
//                ]
//        },
//        @{
//            @"name": @"tail_async_barrier_task",
//            @"type": @(NPKLaunchTaskTypeBarrier),
//            @"taskClassList":@[
//                ]
//        },
//        @{
//            @"name": @"tail_sync_task",
//            @"type": @(NPKLaunchTaskTypeSync),
//            @"taskClassList":@[
//                ]
//        },
//        @{
//            @"name": @"idle_async_task",
//            @"type": @(NPKLaunchTaskTypeAsyncAfterRender),
//            @"taskClassList":@[
//                ]
//        },
//        @{
//            @"name": @"idle_sync_task",
//            @"type": @(NPKLaunchTaskTypeMainThreadIdle),
//            @"taskClassList":@[
//                ]
//        }
    ];
}

+ (BOOL)isLastLaunchSuccess {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"_npk_last_time_launch_state"] boolValue];
}

+ (void)setLastTimeLaunchSuccess:(BOOL)b_success {
    [[NSUserDefaults standardUserDefaults] setBool:b_success forKey:@"_npk_last_time_launch_state"];
}

+ (BOOL)isLastLaunchSpeedUp {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"_npk_last_time_speed_up"] boolValue];
}

+ (void)setLastTimeLaunchSpeedUp:(BOOL)b_speedUp {
    [[NSUserDefaults standardUserDefaults] setBool:b_speedUp forKey:@"_npk_last_time_speed_up"];
}

@end
