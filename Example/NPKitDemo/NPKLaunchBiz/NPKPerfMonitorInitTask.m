//
//  NPKPerfMonitorInitTask.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/14.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKPerfMonitorInitTask.h"
#import <NicePerformanceKit/NPKSignpostLog.h>
#import "NPKLagMonitor.h"
#import "NPKPerfMonitor.h"

@implementation NPKPerfMonitorInitTask

- (void)runWithOptions:(NSDictionary *)options {
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    npk_time_profile_begin("PerfMonitor", spid + 2);
    [[NPKLagMonitor sharedInstance] start];
    [[NPKPerfMonitor sharedInstance] start];
    npk_time_profile_end("PerfMonitor", spid + 2);
}

@end
