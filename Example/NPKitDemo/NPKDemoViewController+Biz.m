//
//  NPKDemoViewController+Biz.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/1.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKDemoViewController+Biz.h"
#import <MetricKit/MetricKit.h>
#import <NicePerformanceKit/NPKBaseDefine.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>
#import <NicePerformanceKit/NPKPerfTestCase.h>
#import <NicePerformanceKit/NPKPerfEntryWindow.h>

@implementation NPKDemoViewController (Biz)

- (void)lagDetectWithStackInfo:(NSString *)stackInfo
                      lagCount:(NSUInteger)lagCount {
    [[NPKPerfEntryWindow sharedInstance] updatePerfInfo:[NSString stringWithFormat:@"ANR: %lu", (unsigned long)lagCount] withFlash:YES];
}

// 3. 完善回调方法
- (void)didReceiveMetricPayloads:(NSArray<MXMetricPayload *> *)payloads {
    
    if (@available(iOS 13.0, *)){
        for (MXMetricPayload *payload in payloads) {
            NPKLog(@"[payload cpuMetrics]; = %@", [payload cpuMetrics]);
            
            if (@available(iOS 14.0, *)) {
                NPKLog(@"dictionaryRepresentation = %@", [payload dictionaryRepresentation]);
            } else {
                // Fallback on earlier versions
            }
            NPKLog(@"%@", payload);
        }
    }
}

- (void)didReceiveDiagnosticPayloads:(NSArray<MXDiagnosticPayload *> * _Nonnull)payloads API_AVAILABLE(ios(14.0)) {
    
    for (MXDiagnosticPayload *diagnosticPayload  in payloads) {
        NSLog(@"diagnosticPayload = %@", [diagnosticPayload dictionaryRepresentation]);
    }
    
    NSLog(@"payloads = %@", payloads);  
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
    
    [NPKBadPerfCase generateMainThreadLag];
    
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
