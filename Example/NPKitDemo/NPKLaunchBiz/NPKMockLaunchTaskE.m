//
//  NPKMockLaunchTaskE.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/15.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKMockLaunchTaskE.h"
#import <NicePerformanceKit/NPKSignpostLog.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@implementation NPKMockLaunchTaskE

- (void)runWithOptions:(NSDictionary *)options {
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    npk_time_profile_begin("TaskE", spid + 5);
    [NPKBadPerfCase generateLagWithTime:0.9f];
    npk_time_profile_end("TaskE", spid + 5);
}

@end
