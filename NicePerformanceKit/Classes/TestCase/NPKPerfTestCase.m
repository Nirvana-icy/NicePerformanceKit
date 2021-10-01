//
//  NPKPerfTestCase.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/29.
//

#import "NPKPerfTestCase.h"

@implementation NPKPerfTestCase

static bool g_testCPUOrNot = false;

+ (void)costCPUALot {
    if (g_testCPUOrNot) {
        g_testCPUOrNot = false;
        return;
    }
    g_testCPUOrNot = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (g_testCPUOrNot) {
#if !TARGET_OS_OSX
            UIColor *blueColor = [UIColor blueColor];
            blueColor = nil;
#else
            NSColor *blueColor = [NSColor blueColor];
            blueColor = nil;
#endif
            sleep(0.05);
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (g_testCPUOrNot) {
#if !TARGET_OS_OSX
            UIColor *redColor = [UIColor redColor];
            redColor = nil;
#else
            NSColor *redColor = [NSColor redColor];
            redColor = nil;
#endif
            sleep(0.05);
        }
    });
}

@end
