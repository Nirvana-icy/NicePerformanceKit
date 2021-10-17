//
//  NPKMockLaunchTaskD.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/14.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKMockLaunchTaskD.h"
#import <NicePerformanceKit/NPKSignpostLog.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@implementation NPKMockLaunchTaskD

- (void)runWithOptions:(NSDictionary *)options {
//    npk_time_profile("TaskD", [NPKBadPerfCase generateLagWithTime:0.6f]);
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    npk_time_profile_begin("TaskD", spid + 4);
    sleep(1.);
    npk_time_profile_end("TaskD", spid + 4);
}

@end
