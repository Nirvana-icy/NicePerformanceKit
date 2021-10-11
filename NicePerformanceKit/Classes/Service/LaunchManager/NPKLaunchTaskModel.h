//
//  NPKLaunchTaskModel.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 启动任务类型
typedef NS_ENUM(NSUInteger, NPKLaunchTaskType) {
    NPKLaunchTaskTypeSync,             // 同步任务(启动链路中可存在多个)
    NPKLaunchTaskTypeAsync,            // 异步任务(启动链路中可存在多个)
    NPKLaunchTaskTypeBarrier,          // 异步栅栏任务(该异步队列中所有的任务都执行完毕后才会执行后续的任务,启动链路中可存在多个)
    /* 业务侧需要在首页展示之后发送NPKLaunchManagerShouldStartTaskAfterRenderNotification通知才会触发该任务队列 */
    NPKLaunchTaskTypeAsyncAfterRender  // 首页展示之后执行的任务(启动链路中只能存在一个)
};

@interface NPKLaunchTaskModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <NSString *> *taskClassList;
@property (nonatomic, assign) NPKLaunchTaskType type;

@end

NS_ASSUME_NONNULL_END
