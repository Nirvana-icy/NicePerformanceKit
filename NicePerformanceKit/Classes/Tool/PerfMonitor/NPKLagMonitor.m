//
//  NPKLagMonitor.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/22.
//

#import "NPKLagMonitor.h"
#import "NPKBaseDefine.h"

@interface NPKLagMonitor ()

@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, assign, readwrite) NSUInteger lagCount;

@end

@implementation NPKLagMonitor

+ (instancetype)sharedInstance {
    static NPKLagMonitor *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKLagMonitor new];
        _sharedInstance.queue = dispatch_queue_create("com.npk.lag.monitor.queue", DISPATCH_QUEUE_SERIAL);
        _sharedInstance.semaphore = dispatch_semaphore_create(0);
        _sharedInstance.lock = [NSLock new];
        _sharedInstance.isMonitoring = NO;
        _sharedInstance.timeOutInterval = 0.5f;
    });
    return _sharedInstance;
}

- (void)start {
    if (self.isMonitoring) {
        return;
    }
    self.isMonitoring = YES;
    self.lagCount = 0;
    dispatch_async(self.queue, ^{
        while (YES == self.isMonitoring) {
            __block BOOL timeOut = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                timeOut = NO;
                dispatch_semaphore_signal(self.semaphore);
            });
            [NSThread sleepForTimeInterval:self.timeOutInterval];
            
            if (timeOut) {
                self.lagCount += 1;
                NPKLog(@"App lag now. Total: %lu", (unsigned long)self.lagCount);
                if ([self.delegatet respondsToSelector:@selector(lagDetectWithStackInfo:lagCount:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegatet lagDetectWithStackInfo:@"" lagCount:self.lagCount];
                    });
                }
            }
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        }
    });
}

- (void)stop {
    if (NO == self.isMonitoring) {
        return;
    }
    self.isMonitoring = NO;
}

@end
