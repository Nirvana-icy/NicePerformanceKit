//
//  NPKLaunchConfig.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/20.
//

#import <Foundation/Foundation.h>
#import <NicePerformanceKit/NPKLaunchTaskModel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NPKLaunchConfigProtocol <NSObject>

- (NSArray *)defaultLaunchList;

@end

@interface NPKLaunchConfig : NSObject <NPKLaunchConfigProtocol>

- (NSArray *)defaultLaunchList;

// 上次启动是否成功
+ (BOOL)isLastLaunchSuccess;

// 成功与否标志位。初始为NO，启动成功Runloop空闲时标记为YES。
// 如果业务使用此标记位，需在首页渲染完毕后触发 NPKLaunchManagerShouldStartTaskAfterRenderNotification 通知。
+ (void)setLastTimeLaunchSuccess:(BOOL)b_success;

// 获取上次启动 远程开关的状态
+ (BOOL)isLastLaunchSpeedUp;

//  记录上次启动 远程开关的状态
+ (void)setLastTimeLaunchSpeedUp:(BOOL)b_enable;

@end

NS_ASSUME_NONNULL_END
