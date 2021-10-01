//
//  NPKBadPerfCase.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/7/29.
//

#import "NPKBadPerfCase.h"
#import "NPKSignpostLog.h"

@implementation NPKBadPerfCase

+ (void)generateMainThreadLag {
    dispatch_async(dispatch_get_main_queue(), ^{
        NPKLog(@"Test Foreground Main Thread Lag...Lag with 5s...Begin.");
        os_signpost_id_t spid = _npk_time_profile_spid_generate();
        npk_time_profile_begin("generateMainThreadLag", spid);
        NSDate *lastDate = [NSDate date];
        while (1) {
            NSDate *currentDate = [NSDate date];
            if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 5.) {
                break;
            }
        }
        npk_time_profile_end("generateMainThreadLag", spid);
        NPKLog(@"Test Foreground Main Thread Lag...Lag with 5s...End.");
    });
}

@end
