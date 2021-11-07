//
//  AAAANPKLaunchTimeProfile.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAAANPKLaunchTimeProfile : NSObject


/// 设置didFinishLaunchCallbackTime 时间
/// @param callBacktime  请传入 NSDate.date.timeIntervalSince1970
+ (void)setDidFinishLaunchCallbackTime:(NSTimeInterval)callBacktime;

/// 设置didFinishLaunchFinishTime 时间
/// @param finishTime  NSDate.date.timeIntervalSince1970
+ (void)setDidFinishLaunchFinishTime:(NSTimeInterval)finishTime;


/// 获取T1阶段时间 单位秒
/// @return T1阶段时间 单位秒
+ (NSTimeInterval)timeT1;

/// 获取T2阶段时间 单位秒
/// @return T2阶段时间 单位秒
+ (NSTimeInterval)timeT2;

/// 获取启动耗时（T1 + T2） 单位秒
/// @return 启动耗时（T1 + T2） 单位秒
+ (NSTimeInterval)launchTime;

/// 启动时间综述字符串
/// @return 启动时间    eg. 启动耗时: 2.1s = 0.2s + 1.9s
+ (NSString *)launchTimeSummary;

@end

NS_ASSUME_NONNULL_END
