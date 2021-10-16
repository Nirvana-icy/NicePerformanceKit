//
//  NPKFPS.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKFPSMonitor.h"

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

- (instancetype)init{
    self = [super init];
    if (self) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

#pragma mark -- Help Methods

- (void)startMonitoring{
     _displayLink.paused = NO;
}

- (void)pauseMonitoring{
    _displayLink.paused = YES;
}

- (void)removeMonitoring{
    [self pauseMonitoring];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
}

#pragma mark -- Event Handle

- (void)displayLinkTick:(CADisplayLink *)link{
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

- (void)dealloc{
    [self removeMonitoring];
}

@end
