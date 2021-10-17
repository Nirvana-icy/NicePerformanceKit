//
//  NPKLaunchHeadTaskB.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/14.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKMockLaunchTaskB.h"
#import <NicePerformanceKit/NPKSignpostLog.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@implementation NPKMockLaunchTaskB

- (void)runWithOptions:(NSDictionary *)options {
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    npk_time_profile_begin("TaskB", spid + 1);
    [NPKBadPerfCase generateLagWithTime:0.8f];
    npk_time_profile_end("TaskB", spid + 1);
}

@end
