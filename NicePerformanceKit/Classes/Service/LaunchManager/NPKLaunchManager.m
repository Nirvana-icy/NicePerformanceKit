//
//  NPKLaunchManager.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/6.
//

#import "NPKLaunchManager.h"
#import <dlfcn.h>
#import <mach-o/getsect.h>
#import <objc/runtime.h>
#import "NPKLaunchConfig.h"
#import "NPKLaunchConfigPluginDefinition.h"
#import "NPKLaunchTaskModel.h"
//#import "NPKLaunchTaskService.h"

@interface NPKLaunchManager()

/// 启动配置 (通过NPK_LAUNCH_MANAGER_CONFIFG_REGISTER()动态注入)
@property (nonatomic, strong, readonly) __kindof NPKLaunchConfig *launchConfig;
//@property (nonatomic, strong) NPKLaunchTaskService *launchService;

@end

@implementation NPKLaunchManager
@synthesize launchConfig = _launchConfig;

- (void)startWithOptions:(NSDictionary *)options {
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"NPKLaunchManager should launch with main thread!");
    
    if (!self.launchConfig) {
        NSAssert(NO, @"Launch config can not be nil!");
        return;
    }
    [self startLaunchTasks:[self.launchConfig defaultLaunchList]];
}

#pragma mark - Private Methods

- (void)startLaunchTasks:(NSArray *)launchTasks {
    if (!launchTasks || !launchTasks.count) {
        NSAssert(NO, @"Launch Tasks Can't Be Empty!");
        return;
    }
}

#pragma mark - Getter

static NPKLaunchManager * _sharedManager = nil;

//- (NPKLaunchTaskService *)launchService {
//    if (!_launchService) {
//        _launchService = [NPKLaunchTaskService new];
//    }
//    return _launchService;;
//}

- (__kindof NPKLaunchConfig *)launchConfig {
    if (!_launchConfig) {
        Class configClass = nil;
        
        Dl_info info;
        dladdr(&_sharedManager, &info);
#ifdef __LP64__
        uint64_t addr = 0;
        const uint64_t mach_header = (uint64_t)info.dli_fbase;
        const struct section_64 *section = getsectbynamefromheader_64((void *)mach_header, "__DATA", "npk_launch_plug");
#else
        uint32_t addr = 0;
        const uint32_t mach_header = (uint32_t)info.dli_fbase;
        const struct section *section = getsectbynamefromheader((void *)mach_header, "__DATA", "npk_launch_plug");
#endif
        if (section == NULL) {
            NSAssert(NO, @"Error: [NPKPluginsManager readMachOSectionDataFromObj] can't find Section from Mach-O. Please make sure that you have already write __Data named %s to the Mach-O.", "npk_export_plug");
            return nil;
        }
        for (addr = section->offset; addr < section->offset + section->size; addr += sizeof(NPKLaunchConfigPluginMeta)) {
            NPKLaunchConfigPluginMeta *pluginMeta = (NPKLaunchConfigPluginMeta *)(mach_header + addr);
            if (!pluginMeta) continue;
            NSString *className = [NSString stringWithUTF8String:pluginMeta->cls];
            Class class = NSClassFromString(className);
            if (!class) {
                NSAssert(NO, @"Error: [NPKPluginsManager readMachOSectionDataFromObj]  %@ not exist!", className);
                return nil;
            } else {
                configClass = class;
            }
        }
        if ([configClass conformsToProtocol:@protocol(NPKLaunchConfigProtocol)]) {
            _launchConfig = [configClass new];
        }
        
    }
    return _launchConfig;
}

+ (NPKLaunchManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [NPKLaunchManager new];
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
