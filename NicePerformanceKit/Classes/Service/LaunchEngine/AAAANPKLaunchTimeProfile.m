//
//  AAAANPKLaunchTimeProfile.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/19.
//

#import "AAAANPKLaunchTimeProfile.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

static NSTimeInterval _loadTime;
static NSTimeInterval _didFinishLaunchCallbackTime;
static NSTimeInterval _didFinishLaunchFinishTime;

@implementation AAAANPKLaunchTimeProfile

+ (void)load {
    _loadTime = NSDate.date.timeIntervalSince1970;
}

+ (void)setDidFinishLaunchCallbackTime:(double)callBacktime {
    _didFinishLaunchCallbackTime = callBacktime;
}

+ (void)setDidFinishLaunchFinishTime:(double)finishTime {
    _didFinishLaunchFinishTime = finishTime;
}

+ (NSString *)launchTimeSummary {
    return [NSString stringWithFormat:@"启动耗时: %.1fs = %.1fs + %.1fs", [AAAANPKLaunchTimeProfile launchTime],
             [AAAANPKLaunchTimeProfile timeT1],
             [AAAANPKLaunchTimeProfile timeT2]];
}

+ (NSTimeInterval)timeT1 {
    return _didFinishLaunchCallbackTime - [AAAANPKLaunchTimeProfile processStartTime];
}

+ (NSTimeInterval)timeT2 {
    return _didFinishLaunchFinishTime - _didFinishLaunchCallbackTime;
}

+ (NSTimeInterval)launchTime {
    return _didFinishLaunchFinishTime - [AAAANPKLaunchTimeProfile processStartTime];
}

/// 获取进程创建时间
/// @discuss 优先取进程创建时间。如果获取失败，以+load方法调用时间兜底。
/// @ref  https://tech.meituan.com/2018/12/06/waimai-ios-optimizing-startup.html
/// @return timeIntervalSince1970  单位秒
+ (NSTimeInterval)processStartTime {
    struct kinfo_proc kProcInfo;
    if ([self processInfoForPID:[[NSProcessInfo processInfo] processIdentifier] processInfo:&kProcInfo]) {
        return kProcInfo.kp_proc.p_un.__p_starttime.tv_sec + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec * 0.000001;
    } else {
        return _loadTime;
    }
}

+ (BOOL)processInfoForPID:(int)pid processInfo:(struct kinfo_proc *)processInfo {
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(* processInfo);
    return sysctl(cmd, sizeof(cmd)/sizeof(*cmd), processInfo, &size, NULL, 0) == 0;
}

@end
