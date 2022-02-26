//
//  NPKLaunchManager.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/6.
//

#import "NPKLaunchEngine.h"
#import "NPKLaunchConfig.h"
#import "NPKLaunchTaskModel.h"
#import "NPKLaunchProtocol.h"
#import "NPKLaunchTimeProfile.h"
#import "NPKDispatchQueuePool.h"
#import "NPKBaseDefine.h"

NSString * const NPKLaunchManagerShouldStartTaskAfterRenderNotification = @"NPKLaunchManagerShouldStartTaskAfterRenderNotification";

@interface NPKLaunchEngine()

@property (nonatomic, strong, readonly) __kindof NPKLaunchConfig *launchConfig;
@property (nonatomic, strong) Class npkLaunchConfigClazz;
@property (nonatomic, strong) NSDictionary *appOptions;
@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, strong) NSMutableDictionary *launchTasks;
@property (nonatomic, strong) NPKLaunchTaskModel *asyncTaskAfterReader;
@property (nonatomic, strong) NPKLaunchTaskModel *mainThreadIdleTaskAfterRender;
@property (nonatomic, strong) NSLock *launchLock;

@end

@implementation NPKLaunchEngine
@synthesize launchConfig = _launchConfig;

- (void)startWithConfigClazz:(Class)npkLaunchConfigClazz options:(NSDictionary *)options {
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"NPKLaunchManager should launch with main thread!");
    [NPKLaunchTimeProfile markDidFinishLaunchTime];
    
    self.npkLaunchConfigClazz = npkLaunchConfigClazz;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveAfterRenderNotification:)
                                                 name:NPKLaunchManagerShouldStartTaskAfterRenderNotification
                                               object:nil];
    
    if (!self.launchConfig) {
        NSAssert(NO, @"Launch config can not be nil!");
        return;
    }
    self.appOptions = options;
    [self startLaunchTasks:[self.launchConfig defaultLaunchList]];
}

#pragma mark - Notifications

- (void)didReceiveAfterRenderNotification:(NSNotification *)notifi {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NPKLaunchManagerShouldStartTaskAfterRenderNotification
                                                  object:nil];
    [NPKLaunchTimeProfile markDidAppearTime];
    [self registRunloopIdleCallback];
}

#pragma mark - Private Methods

- (void)registRunloopIdleCallback {
    //注册kCFRunLoopBeforeTimers回调
    CFRunLoopRef mainRunloop = [[NSRunLoop mainRunLoop] getCFRunLoop];
    CFRunLoopActivity activities = kCFRunLoopAllActivities;
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, activities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        if (activity == kCFRunLoopBeforeWaiting) {
            if (self.asyncTaskAfterReader) {
                [self startAsyncGroupTask:self.asyncTaskAfterReader];
            }
            
            if (self.mainThreadIdleTaskAfterRender) {
                [self startSyncGroupTask:self.mainThreadIdleTaskAfterRender];
            }
            CFRunLoopRemoveObserver(mainRunloop, observer, kCFRunLoopCommonModes);
            // 标记此次启动状态
            [NPKLaunchConfig setLastTimeLaunchSuccess:YES];
#ifdef DEBUG
            [self sendMessage:[NPKLaunchTimeProfile launchTimeSummary] withMsgLevel:NPKMsgLevelHigh];
            NPKLog(@"Launch Time Summary: %@", [NPKLaunchTimeProfile launchTimeSummary]);
#endif
        }
    });
    CFRunLoopAddObserver(mainRunloop, observer, kCFRunLoopCommonModes);
}

- (void)startLaunchTasks:(NSArray *)launchTasks {
    if (!launchTasks || !launchTasks.count) {
        NSAssert(NO, @"Launch Tasks Can't Be Empty!");
        return;
    }
    
    [launchTasks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NPKLaunchTaskModel *task = [[NPKLaunchTaskModel alloc] initWithDict:obj];
        [self.taskArray addObject:task];
    }];
    
    [self.taskArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NPKLaunchTaskModel *task = (NPKLaunchTaskModel *)obj;
        if ([task isKindOfClass:[NPKLaunchTaskModel class]]) {
            switch (task.type) {
                case NPKLaunchTaskTypeSync:
                    [self startSyncGroupTask:task];
                    break;
                case NPKLaunchTaskTypeAsync:
                    [self startAsyncGroupTask:task];
                    break;
                case NPKLaunchTaskTypeBarrier:
                    [self startBarrierGroupTask:task];
                    break;
                case NPKLaunchTaskTypeAsyncAfterRender:
                    self.asyncTaskAfterReader = task;
                    break;
                case NPKLaunchTaskTypeMainThreadIdleAfterRender:
                    self.mainThreadIdleTaskAfterRender = task;
                    break;
                default:
                    break;
            }
        }
    }];
}

/// 同步执行队列
- (void)startSyncGroupTask:(NPKLaunchTaskModel *)task {
    for (NSString *initTask in task.taskClassList) {
        [self executeTask:initTask];
    }
}

/// 异步队列
- (void)startAsyncGroupTask:(NPKLaunchTaskModel *)task {
    dispatch_queue_t queue = NPKDispatchQueueGetForQoS(NSQualityOfServiceUtility);
    
    __weak typeof(self) weakSelf = self;
    for (NSString *initTask in task.taskClassList) {
        dispatch_async(queue, ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf executeTask:initTask];
        });
    }
}

/// 栅栏队列
- (void)startBarrierGroupTask:(NPKLaunchTaskModel *)task {
    // 高优先级
    dispatch_queue_t queue = NPKDispatchQueueGetForQoS(NSQualityOfServiceUserInteractive);
    dispatch_group_t group = dispatch_group_create();
    
    __weak typeof(self) weakSelf = self;
    for (NSString *initTask in task.taskClassList) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf executeTask:initTask];
            dispatch_group_leave(group);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

/// 执行任务
- (void)executeTask:(NSString *)clazz {
    if (!clazz) {
        NSAssert(NO, @"Launch task class can not be nil!");
        return;
    }
    
    Class launchCls = NSClassFromString(clazz);
    if (!launchCls) {
        NSAssert(NO, @"Launch entry class does not exit!");
        return;
    }
    
    [self.launchLock lock];
    id<NPKLaunchProtocol> task = self.launchTasks[clazz];
    if (!task) {
        task = [[launchCls alloc] init];
        self.launchTasks[clazz] = task;
    } else {
        NSAssert(NO, @"Duplicated for launch task [%@]!", clazz);
    }
    [self.launchLock unlock];
    
    if ([task respondsToSelector:@selector(runWithOptions:)]) {
        NSTimeInterval startTime = CACurrentMediaTime();
        [task runWithOptions:self.appOptions];
        NSTimeInterval endTime = CACurrentMediaTime();
        NPKLog(@"启动耗时：Launch task %@ cost %0.3fms. %@.", clazz, (endTime - startTime) * 1000, [NSThread currentThread].isMainThread ? @"Main Thread" : @"");
    }
}

#pragma mark - Getter

//- (NPKLaunchTaskService *)launchService {
//    if (!_launchService) {
//        _launchService = [NPKLaunchTaskService new];
//    }
//    return _launchService;;
//}

- (NSMutableArray *)taskArray {
    if (!_taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

- (NSMutableDictionary *)launchTasks {
    if (!_launchTasks) {
        _launchTasks = [NSMutableDictionary dictionary];
    }
    return _launchTasks;
}

- (NSLock *)launchLock {
    if (!_launchLock) {
        _launchLock = [NSLock new];
    }
    return _launchLock;
}

- (__kindof NPKLaunchConfig *)launchConfig {
    if (!_launchConfig) {
        _launchConfig = [_npkLaunchConfigClazz new];
        NSAssert([_launchConfig isKindOfClass:[NPKLaunchConfig class]], @"npkLaunchConfigClazz should be subclass of NPKLaunchConfig.");
    }
    return _launchConfig;
}

+ (NPKLaunchEngine *)sharedInstance {
    static NPKLaunchEngine * _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NPKLaunchEngine new];
    });
    return _sharedManager;
}

@end
