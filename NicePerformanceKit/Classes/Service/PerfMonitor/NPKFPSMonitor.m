//
//  NPKFPS.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKFPSMonitor.h"
#import "NPKWeakProxy.h"

@interface NPKFPSMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger beginTime;

@end

@implementation NPKFPSMonitor

+ (NPKFPSMonitor *)sharedInstance {
    static dispatch_once_t onceToken;
    static NPKFPSMonitor *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NPKFPSMonitor alloc] init];
    });
    return _sharedInstance;
}

#pragma mark -- Help Methods

- (void)startMonitoring {
    if ([NSThread isMainThread]) {
        [self _startMonitoring];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _startMonitoring];
        });
    }
}

- (void)_startMonitoring {
    if (self.displayLink.paused) {
        self.displayLink.paused = NO;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopMonitoring {
    if (self.displayLink.paused == NO) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
    }
}

- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:[NPKWeakProxy proxyWithTarget:self] selector:@selector(displayLinkTick:)];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

#pragma mark -- Event Handle

- (void)displayLinkTick:(CADisplayLink *)link {
    if (_beginTime == 0) {
        _beginTime = link.timestamp;
        return;
    }
    _count++;

    NSTimeInterval interval = link.timestamp - _beginTime;
    if (interval < 1) {
        return;
    }
    
    self.currentFPS = _count / interval;
    
    _beginTime = link.timestamp;
    _count = 0;
}

@end
