//
//  NPKLaunchManager.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/6.
//

#import "NPKLaunchEngine.h"
#import <dlfcn.h>
#import <mach-o/getsect.h>
#import <objc/runtime.h>
#import "NPKLaunchConfig.h"
#import "NPKLaunchTaskModel.h"
#import "NPKLaunchProtocol.h"
#import "AAAANPKLaunchTimeProfile.h"
#import "NPKitDisplayWindow.h"

@interface NPKLaunchEngine()

@property (nonatomic, strong, readonly) __kindof NPKLaunchConfig *launchConfig;
@property (nonatomic, strong) NSDictionary *appOptions;
@property (nonatomic, strong) NSMutableArray *taskArray;
@property (nonatomic, strong) NSMutableDictionary *launchTasks;
@property (nonatomic, strong) NPKLaunchTaskModel *taskAfterRender;
@property (nonatomic, strong) NSLock *launchLock;
//@property (nonatomic, strong) NPKLaunchTaskService *launchService;

@end

@implementation NPKLaunchEngine
@synthesize launchConfig = _launchConfig;

- (void)startWithOptions:(NSDictionary *)options {
    [AAAANPKLaunchTimeProfile setDidFinishLaunchCallbackTime:CACurrentMediaTime()];
    
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"NPKLaunchManager should launch with main thread!");
    
    if (!self.launchConfig) {
        NSAssert(NO, @"Launch config can not be nil!");
        return;
    }
    self.appOptions = options;
    [self startLaunchTasks:[self.launchConfig defaultLaunchList]];
    
    [AAAANPKLaunchTimeProfile setDidFinishLaunchFinishTime:CACurrentMediaTime()];
    
    [[NPKitDisplayWindow sharedInstance] showToast:[AAAANPKLaunchTimeProfile launchTimeSummary] withDuration:10.f];
}

#pragma mark - Private Methods

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
                    self.taskAfterRender = task;
                    break;
                default:
                    break;
            }
        }
    }];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf startSyncGroupTask:weakSelf.taskAfterRender];
    });
}

/// 同步执行队列
- (void)startSyncGroupTask:(NPKLaunchTaskModel *)task {
    for (NSString *initTask in task.taskClassList) {
        [self executeTask:initTask];
    }
}

/// 异步队列
- (void)startAsyncGroupTask:(NPKLaunchTaskModel *)task {
    dispatch_queue_t queue = dispatch_queue_create("com.npk.launchqueue.async",
                                                   DISPATCH_QUEUE_CONCURRENT);
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
    dispatch_queue_t queue = dispatch_queue_create("com.npk.launchqueue.barrier",
                                                   DISPATCH_QUEUE_CONCURRENT);
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
        [task runWithOptions:self.appOptions];
    }
}

#pragma mark - Getter

static NPKLaunchEngine * _sharedManager = nil;

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
        _launchConfig = [NPKLaunchConfig new];
//        Class configClass = nil;
//
//        Dl_info info;
//        dladdr(&_sharedManager, &info);
//#ifdef __LP64__
//        uint64_t addr = 0;
//        const uint64_t mach_header = (uint64_t)info.dli_fbase;
//        const struct section_64 *section = getsectbynamefromheader_64((void *)mach_header, "__DATA", "npk_launch_plug");
//#else
//        uint32_t addr = 0;
//        const uint32_t mach_header = (uint32_t)info.dli_fbase;
//        const struct section *section = getsectbynamefromheader((void *)mach_header, "__DATA", "npk_launch_plug");
//#endif
//        if (section == NULL) {
//            NSAssert(NO, @"Error: [NPKPluginsManager readMachOSectionDataFromObj] can't find Section from Mach-O. Please make sure that you have already write __Data named %s to the Mach-O.", "npk_export_plug");
//            return nil;
//        }
//        for (addr = section->offset; addr < section->offset + section->size; addr += sizeof(NPKLaunchConfigPluginMeta)) {
//            NPKLaunchConfigPluginMeta *pluginMeta = (NPKLaunchConfigPluginMeta *)(mach_header + addr);
//            if (!pluginMeta) continue;
//            NSString *className = [NSString stringWithUTF8String:pluginMeta->cls];
//            Class class = NSClassFromString(className);
//            if (!class) {
//                NSAssert(NO, @"Error: [NPKPluginsManager readMachOSectionDataFromObj]  %@ not exist!", className);
//                return nil;
//            } else {
//                configClass = class;
//            }
//        }
//        if ([configClass conformsToProtocol:@protocol(NPKLaunchConfigProtocol)]) {
//            _launchConfig = [configClass new];
//        }
        
    }
    return _launchConfig;
}

+ (NPKLaunchEngine *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NPKLaunchEngine new];
    });
    return _sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if(_sharedManager == nil){
        _sharedManager = [super allocWithZone:zone];
    }
    return _sharedManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone{
    return _sharedManager;
}

@end
