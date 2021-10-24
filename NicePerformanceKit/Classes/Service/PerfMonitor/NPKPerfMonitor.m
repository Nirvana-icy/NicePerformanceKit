//
//  NPKPerfMonitor.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/21.
//

#import "NPKPerfMonitor.h"
#import "NPKitDisplayWindow.h"
#import "NPKSysResCostInfo.h"
#import "NPKFPSMonitor.h"
#import "NPKLagMonitor.h"

@interface NPKPerfMonitor ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign, readwrite) float appCPU;
@property (nonatomic, assign, readwrite) float systemCPU;
@property (nonatomic, assign, readwrite) float appMemory;
@property (nonatomic, assign, readwrite) float gpuUsage;
@property (nonatomic, assign, readwrite) float fps;
//@property (nonatomic, copy, readwrite) NSString *gpuInfo;
@property (nonatomic, strong) NPKFPSMonitor *fpsMonitor;

@property (nonatomic, assign) NSUInteger lastLagCount;

@end

@implementation NPKPerfMonitor

+ (instancetype)sharedInstance {
    static NPKPerfMonitor *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKPerfMonitor new];
        _sharedInstance.lastLagCount = 0;
    });
    return _sharedInstance;
}

- (void)start {
    if (!_timer) {
        _queue = dispatch_queue_create("com.npk.perf.monitor.queue", DISPATCH_QUEUE_SERIAL);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) * 0.1);
        [[NPKFPSMonitor sharedInstance] startMonitoring];

        dispatch_source_set_event_handler(_timer, ^{
            [self renderUIWithCurrentSystemInfo];
        });
        
        dispatch_resume(_timer);
    }
}

- (void)renderUIWithCurrentSystemInfo {
    float currentFPS = [NPKFPSMonitor sharedInstance].currentFPS;
    float currentAppCpuUsage = [NPKSysResCostInfo currentAppCpuUsage];
    float currentAppMemory = [NPKSysResCostInfo currentAppMemory];
    NSUInteger currentThreadCount = [NPKSysResCostInfo currentAppThreadCount];
    NSUInteger currentLagCount = [[NPKLagMonitor sharedInstance] lagCount];
    // 基础性能信息
    NSString *currentPerfInfo = [NSString stringWithFormat:@"CPU: %0.1f RAM: %0.1f 线程: %lu FPS:%0.1f", currentAppCpuUsage, currentAppMemory, (unsigned long)currentThreadCount, currentFPS];
    // 性能告警信息生成
    // todo 可配置
    NSString *warningInfo = @"";
    if (currentLagCount > self.lastLagCount) {
        self.lastLagCount = currentLagCount;
        warningInfo = [warningInfo stringByAppendingFormat:@"%@" , [NSString stringWithFormat:@"卡顿: %0lu", (unsigned long)currentLagCount]];
    }
    if (currentAppCpuUsage > 80.f) {
        warningInfo = [warningInfo stringByAppendingFormat:@" %@" , [NSString stringWithFormat:@"CPU: %0.1f", currentAppCpuUsage]];
    }
    if (currentFPS < 45.f) {
        warningInfo = [warningInfo stringByAppendingFormat:@" %@" , [NSString stringWithFormat:@"FPS: %0.f", currentFPS]];
    }
    if (currentAppMemory > 150.f) {
        warningInfo = [warningInfo stringByAppendingFormat:@" %@" , [NSString stringWithFormat:@"RAM: %0.f", currentAppMemory]];
    }
    if (currentThreadCount > 36) {
        warningInfo = [warningInfo stringByAppendingFormat:@" %@" , [NSString stringWithFormat:@"线程: %0lu", (unsigned long)currentThreadCount]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NPKitDisplayWindow sharedInstance] updatePerfInfo:currentPerfInfo];
        if (warningInfo.length > 0) {
            [[NPKitDisplayWindow sharedInstance] showToast:warningInfo];
        }
    });
}

- (void)stop {
    if (_timer) {
        dispatch_source_cancel(_timer);
        [_fpsMonitor stopMonitoring];
        _timer = nil;
        _queue = nil;
    }
}

@end
