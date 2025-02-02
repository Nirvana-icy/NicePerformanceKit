//
//  NPKLaunchManager.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import "NPKBaseMessageHandler.h"

NS_ASSUME_NONNULL_BEGIN

/// 首页展示之后发送该通知用于启动渲染之后的同步和异步启动任务
FOUNDATION_EXPORT NSString * const NPKLaunchManagerShouldStartTaskAfterRenderNotification;

@interface NPKLaunchEngine : NPKBaseMessageHandler

// 获取单例实例
+ (NPKLaunchEngine *)sharedInstance;

//  点击图标  --T1-->  main  --T2-->  didBecomeActive  --T3-->  didAppear   --T4-->  首页可交互  -- idle time --
//     preMain        ｜   postMain        |        首页创建      |     接口请求，页面绘制  |
//  系统库加载，类初始化等 ｜ 初始化各种SDK      |                     |                     ｜                            <= 优化前
//  ----------------------------------------------------------------------------------------------------------
//  无用代码 +load治理   ｜  初始化极少SDK     ｜   布局精简，数据预取  ｜     骨架屏(Option)    ｜    调度延迟的任务项           => 优化后
//                       first runloop     |   second runloop.. |                      |
//                         syncTasks       ｜                   ｜
//                  headTasks   tailTasks  |                    |                      | main thread idle tasks
//                         asyncTasks      |                    |                      | idle async tasks
- (void)startWithConfigClazz:(Class)npkLaunchConfigClazz options:(nullable NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END
