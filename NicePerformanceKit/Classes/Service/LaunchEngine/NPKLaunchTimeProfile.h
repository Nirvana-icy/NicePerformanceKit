//
//  AAAANPKLaunchTimeProfile.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//  点击图标  --T1-->  main  --T2-->  didBecomeActive  --T3-->  didAppear   --T4-->  首页可交互  -- idle time --
//     preMain        ｜   postMain        |        首页创建      |     接口请求，页面绘制  |
//  系统库加载，类初始化等 ｜ 初始化各种SDK      |                     |                     ｜                            <= 优化前
//  ----------------------------------------------------------------------------------------------------------
//  无用代码 +load治理   ｜  初始化极少SDK     ｜   布局精简，数据预取  ｜     骨架屏(Option)    ｜    调度延迟的任务项           => 优化后
//                       first runloop     |   second runloop.. |                      |
//                         syncTasks       ｜                   ｜
//                  headTasks   tailTasks  |                    |                      | main thread idle tasks
//                         asyncTasks      |                    |                      | idle async tasks

@interface NPKLaunchTimeProfile : NSObject

// 接入启动引擎，启动引擎内部已经打点。不需手工打点。
+ (void)markDidFinishLaunchTime;

// 接入启动引擎，在首页viewDidAppear时发送 NPKLaunchManagerShouldStartTaskAfterRenderNotification 通知会触发启动引擎内部埋点。无需手工埋点。
+ (void)markDidAppearTime;

// 首页请求，渲染完成时，需手工埋点。
+ (void)markHomePageTTITime;

/// 获取启动链路 T1 时间，单位秒
+ (NSTimeInterval)timeT1;

/// 获取启动链路 T2 时间，单位秒
+ (NSTimeInterval)timeT2;

+ (NSTimeInterval)timeT3;

/// 获取启动耗时，单位秒
+ (NSTimeInterval)launchTime;

/// 获取启动耗时描述，eg. 启动耗时: 2.15s = 0.43s + 1.72s  + 0.53s
+ (NSString *)launchTimeSummary;

/// 当前距离启动的时间，单位秒
+ (NSTimeInterval)currentTimeSinceLaunch;

/// 获取进程创建时间，单位秒
+ (NSTimeInterval)processStartTimeSince1970;

@end

NS_ASSUME_NONNULL_END
