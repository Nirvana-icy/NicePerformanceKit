//
//  NPKLagMonitor.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/22.
//

#import "NPKLagMonitor.h"

@interface NPKLagMonitor ()

@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation NPKLagMonitor

+ (instancetype)sharedInstance {
    static NPKLagMonitor *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKLagMonitor new];
        _sharedInstance.queue = dispatch_queue_create("com.niceperformancekit.lag.monitor.queue", DISPATCH_QUEUE_SERIAL);
        _sharedInstance.semaphore = dispatch_semaphore_create(0);
        _sharedInstance.lock = [NSLock new];
        _sharedInstance.isMonitoring = NO;
        _sharedInstance.timeOutInterval = 3.f;
    });
    return _sharedInstance;
}

- (void)start {
    if (self.isMonitoring) {
        return;
    }
    self.isMonitoring = YES;
    dispatch_async(self.queue, ^{
        while (YES == self.isMonitoring) {
            __block BOOL timeOut = YES;
            NSLog(@"npk__set_timeout_yes.");
            dispatch_async(dispatch_get_main_queue(), ^{
                timeOut = NO;
                NSLog(@"npk__set_timeout_no.");
                dispatch_semaphore_signal(self.semaphore);
            });
            [NSThread sleepForTimeInterval:self.timeOutInterval];
            
            if (timeOut) {
                NSLog(@"npk___lag__");
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
