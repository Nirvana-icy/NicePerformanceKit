//
//  NPKLaunchManager.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/6.
//

#import "NPKLaunchManager.h"
#import "NPKLaunchTaskService.h"

@interface NPKLaunchManager()

@property (nonatomic, strong) NPKLaunchTaskService *launchService;

@end

@implementation NPKLaunchManager

static NPKLaunchManager * _sharedInstance = nil;

+ (NPKLaunchManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKLaunchManager new];
    });
    return _sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if(_sharedInstance == nil){
        _sharedInstance = [super allocWithZone:zone];
    }
    return _sharedInstance;
}

#pragma mark - Getter

- (NPKLaunchTaskService *)launchService {
    if (nil == _launchService) {
        _launchService = [NPKLaunchTaskService new];
    }
    return _launchService;;
}

@end
