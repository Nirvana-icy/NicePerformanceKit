//
//  NPKMockLaunchTaskC.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/14.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKMockLaunchTaskC.h"
#import <NicePerformanceKit/NPKSignpostLog.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@implementation NPKMockLaunchTaskC

- (void)runWithOptions:(NSDictionary *)options {
//    os_signpost_id_t spid = _npk_time_profile_spid_generate();
//    npk_time_profile_begin("TaskC", spid + 2);
//    sleep(0.8);
//    npk_time_profile_end("TaskC", spid + 2);
//    npk_time_profile("TaskC", sleep(1.));
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    npk_time_profile_begin("TaskC", spid + 3);
    [NPKBadPerfCase generateLagWithTime:0.6f];
    npk_time_profile_end("TaskC", spid + 3);
}

@end
