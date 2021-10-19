//
//  NPKLaunchManager.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKLaunchEngine : NSObject

// 获取单例实例
+ (NPKLaunchEngine *)sharedInstance;

// did_launch    > root_onload       >   view_appear > idle_time
//     first runloop                 |   second runloop
//            syncTasks
// headTasks             tailTasks   |         >  idleTasks
//            asyncTasks
- (void)startWithOptions:(NSDictionary *)options;

@end

NS_ASSUME_NONNULL_END
