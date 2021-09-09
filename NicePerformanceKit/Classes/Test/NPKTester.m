//
//  NPKTester.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/7/29.
//

#import "NPKTester.h"
#import <NicePerformanceKit/NPKSignpostLog.h>

@implementation NPKTester

+ (void)generateMainThreadLag {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"[Nice Performance Kit] Test Foreground Main Thread Lag...Lag with 5s...Begin.");
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
        NSLog(@"[Nice Performance Kit] Test Foreground Main Thread Lag...Lag with 5s...End.");
    });
}

@end
