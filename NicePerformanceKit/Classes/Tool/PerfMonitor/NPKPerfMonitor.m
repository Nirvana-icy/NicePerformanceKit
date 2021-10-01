//
//  NPKPerfMonitor.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/21.
//

#import "NPKPerfMonitor.h"
#import "NPKSysResCostInfo.h"
#import "NPKPerfEntryWindow.h"

@interface NPKPerfMonitor ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign, readwrite) float appCPU;
@property (nonatomic, assign, readwrite) float systemCPU;
@property (nonatomic, assign, readwrite) float appMemory;
@property (nonatomic, assign, readwrite) float gpuUsage;
//@property (nonatomic, copy, readwrite) NSString *gpuInfo;

@end

@implementation NPKPerfMonitor

+ (instancetype)sharedInstance {
    static NPKPerfMonitor *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKPerfMonitor new];
    });
    return _sharedInstance;
}

- (void)start {
    if (!_timer) {
        _queue = dispatch_queue_create("com.npk.perf.monitor.queue", DISPATCH_QUEUE_SERIAL);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(_timer, ^{
            NSString *currentPerfInfo = [NSString stringWithFormat:@"%@\n%@", [NPKSysResCostInfo sysLoadInfo], [NPKSysResCostInfo appCostInfo]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NPKPerfEntryWindow sharedInstance] updatePerfInfo:currentPerfInfo];
            });
        });
        
        dispatch_resume(_timer);
    }
}

- (void)stop {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        _queue = nil;
    }
}

@end