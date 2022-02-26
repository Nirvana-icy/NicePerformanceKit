//
//  AAAANPKLaunchTimeProfile.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/19.
//

#import "NPKLaunchTimeProfile.h"
#import "NPKBaseUtil.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

static double _processStartTime;
static double _beforeMainTime;
static double _didFinishLaunchTime;
static double _didAppearTime;

@implementation NPKLaunchTimeProfile

void static __attribute__((constructor)) before_main() {
    if (0 == _beforeMainTime) {
        _beforeMainTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
    }
}

+ (void)markDidFinishLaunchTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (0 == _didFinishLaunchTime) {
            _didFinishLaunchTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
        }
    });
}

+ (void)markDidAppearTime {
    if (0 == _didAppearTime) {
        _didAppearTime = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
    }
}

+ (NSString *)launchTimeSummary {
    return [NSString stringWithFormat:@"启动耗时: %.2fs = %.2fs + %.2fs + 0.2fs", [NPKLaunchTimeProfile launchTime],
             [NPKLaunchTimeProfile timeT1],
             [NPKLaunchTimeProfile timeT2],
             [NPKLaunchTimeProfile timeT3]];
}

+ (NSTimeInterval)timeT1 {
    return _beforeMainTime - [NPKLaunchTimeProfile processStartTimeSince1970];
}

+ (NSTimeInterval)timeT2 {
    return _didFinishLaunchTime - _beforeMainTime;
}

+ (NSTimeInterval)timeT3 {
    if (0 == _didAppearTime) {
        return _didAppearTime - _didFinishLaunchTime;
    } else {
        return 0;
    }
}

+ (NSTimeInterval)launchTime {
    if (0 == [NPKLaunchTimeProfile timeT3]) {
        return _didFinishLaunchTime - [NPKLaunchTimeProfile processStartTimeSince1970];
    } else {
        return _didAppearTime - [NPKLaunchTimeProfile processStartTimeSince1970];
    }
}

+ (NSTimeInterval)currentTimeSinceLaunch {
    return [NPKLaunchTimeProfile currentTimeSince1970] - [NPKLaunchTimeProfile processStartTimeSince1970];
}

+ (NSTimeInterval)currentTimeSince1970 {
    return CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970;
}

+ (NSTimeInterval)processStartTimeSince1970 {
    if (0 == _processStartTime) {
        struct kinfo_proc kProcInfo;
        if ([self processInfoForPID:[[NSProcessInfo processInfo] processIdentifier] procInfo:&kProcInfo]) {
            _processStartTime = round(kProcInfo.kp_proc.p_un.__p_starttime.tv_sec + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec * 0.000001);
        }
    }
    return _processStartTime;
}

+ (BOOL)processInfoForPID:(int)pid procInfo:(struct kinfo_proc*)procInfo {
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(*procInfo);
    return sysctl(cmd, sizeof(cmd)/sizeof(*cmd), procInfo, &size, NULL, 0) == 0;
}

@end
