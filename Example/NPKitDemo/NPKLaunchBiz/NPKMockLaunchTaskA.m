//
//  NPKMockLaunchTaskA.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/14.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKMockLaunchTaskA.h"
#import <NicePerformanceKit/NPKSignpostLog.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@implementation NPKMockLaunchTaskA

- (void)runWithOptions:(NSDictionary *)options {
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    npk_time_profile_begin("TaskA", spid + 1);
    [NPKBadPerfCase generateLagWithTime:1.f];
    npk_time_profile_end("TaskA", spid + 1);
}

@end
