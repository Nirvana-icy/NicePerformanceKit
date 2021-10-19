//
//  AAAANPKLaunchTimeProfile.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/19.
//

#import "AAAANPKLaunchTimeProfile.h"

static double loadTime;
static double didFinishLaunchCallbackTime;
static double didFinishLaunchFinishTime;

@implementation AAAANPKLaunchTimeProfile

+ (void)load {
    loadTime = CACurrentMediaTime();
}

+ (void)setDidFinishLaunchCallbackTime:(double)callBacktime {
    didFinishLaunchCallbackTime = callBacktime;
}

+ (void)setDidFinishLaunchFinishTime:(double)finishTime {
    didFinishLaunchFinishTime = finishTime;
}

+ (NSString *)launchTimeSummary {
    return [NSString stringWithFormat:@"启动耗时: %.1fs = %.1fs + %.1fs", [AAAANPKLaunchTimeProfile launchTime],
             [AAAANPKLaunchTimeProfile timeT1],
             [AAAANPKLaunchTimeProfile timeT2]];
}

+ (double)timeT1 {
    return didFinishLaunchCallbackTime - loadTime;
}

+ (double)timeT2 {
    return didFinishLaunchFinishTime - didFinishLaunchCallbackTime;
}

+ (double)launchTime {
    return didFinishLaunchFinishTime - loadTime;
}

@end
