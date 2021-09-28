//
//  NPKViewController.m
//  NPKitDemo
//
//  Created by jinglong.bi@me.com on 09/09/2021.
//  Copyright (c) 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKViewController.h"
#import "NPKTester.h"
#import "NPKSysResCostInfo.h"
#import "NPKTester.h"

@interface NPKViewController ()

@end

@implementation NPKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self addMainObserver];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self gcdDispatchSyncToSerialQueue];
//    [self gcdDispatchAsyncToSerialQueue];
    [self gcdDispatchAsyncToConcurrentQueue];
    [NPKTester generateMainThreadLag];
}

- (void)gcdDispatchAsyncToConcurrentQueue {
    dispatch_queue_t queue = dispatch_queue_create("com.npk.gcd.concureent.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"npk__执行前");
    
    for (int i = 0; i < 1000; i++) {
        NSLog(@"npk__调度");
        
        dispatch_async(queue, ^{
            NSLog(@"npk__%@  %d   Thread Count:%lu", [NSThread currentThread], i, (unsigned long)[NPKSysResCostInfo currentAppThreadCount]);
        });
    }
    
    NSLog(@"npk__end");
}

- (void)gcdDispatchAsyncToSerialQueue {
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

- (void)gcdDispatchSyncToSerialQueue {
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

- (void)runloopTest {
    sleep(1);
    self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"NPK__蓝色");
    sleep(1);
    CGFloat randomAlpha = (arc4random() % 100) * 0.01;
    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:randomAlpha];
    NSLog(@"NPK__白色__randomAlpha");
    sleep(1);
    NSLog(@"3rd sleep(1) end");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CGFloat randomAlpha = (arc4random() % 100) * 0.01;
//        self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:randomAlpha];
//        NSLog(@"NPK__白色");
//    });
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGFloat randomAlpha = (arc4random() % 100) * 0.01;
        self.view.backgroundColor = [UIColor redColor];//[UIColor colorWithWhite:0.5 alpha:randomAlpha];
        NSLog(@"NPK__红色");
    });
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGFloat randomAlpha = (arc4random() % 100) * 0.01;
        self.view.backgroundColor = [UIColor yellowColor];//[UIColor colorWithWhite:0.5 alpha:randomAlpha];
        NSLog(@"NPK__黄色");
        sleep(1);
        NSLog(@"4th sleep(1) end");
    });
    
    [NPKTester generateMainThreadLag];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        CGFloat randomAlpha = (arc4random() % 100) * 0.01;
        self.view.backgroundColor = [UIColor blueColor];//[UIColor colorWithWhite:0.5 alpha:randomAlpha];
        NSLog(@"NPK__蓝色");
        sleep(1);
        NSLog(@"5th sleep(1) end");
    });
}

- (void)addMainObserver {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"NPK__kCFRunLoopEntry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"NPK__kCFRunLoopBeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"NPK__kCFRunLoopBeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"NPK__kCFRunLoopBeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"NPK__kCFRunLoopAfterWaiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"NPK__kCFRunLoopExit");
                break;
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
}

@end
