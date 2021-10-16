//
//  NPKPerfTestCase+GCD.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/29.
//

#import "NPKPerfTestCase+GCD.h"
#import "NPKSysResCostInfo.h"
#import "NPKDispatchQueuePool.h"

@implementation NPKPerfTestCase (GCD)

+ (void)gcdDispatchAsyncToConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.npk.gcd.concureent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 1000; i++) {
        NSLog(@"npk__调度");
        
        dispatch_async(queue, ^{
            NSLog(@"npk__%@  %d   Thread Count:%lu", [NSThread currentThread], i, (unsigned long)[NPKSysResCostInfo currentAppThreadCount]);
        });
    }
}

+ (void)gcdDispatchAsyncToQueuePool {
    for (int i = 0; i < 1000; i++) {
        NSLog(@"npk__调度");
        dispatch_queue_t queue = NPKDispatchQueueGetForQoS(NSQualityOfServiceUtility);  //dispatch_queue_create("com.npk.gcd.concureent.queue", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(queue, ^{
            NSLog(@"npk__%@  %d   Thread Count:%lu", [NSThread currentThread], i, (unsigned long)[NPKSysResCostInfo currentAppThreadCount]);
        });
    }
}

+ (void)gcdDispatchAsyncToSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.npk.gcd.serial.queue", NULL);
    NSLog(@"npk__执行前");
    
    for (int i = 0; i < 10; i++) {
        NSLog(@"npk__调度");
        
        dispatch_async(queue, ^{
            NSLog(@"npk__%@  %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"npk__end");
}

+ (void)gcdDispatchSyncToSerialQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.npk.gcd.serial.queue", NULL);
    NSLog(@"npk__执行前");
    
    for (int i = 0; i < 10; i++) {
        NSLog(@"npk__调度");
        
        dispatch_sync(queue, ^{
            NSLog(@"npk__%@  %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"npk__end");
}

@end
