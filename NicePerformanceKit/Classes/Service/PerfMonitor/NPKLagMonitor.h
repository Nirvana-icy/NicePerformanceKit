//
//  NPKLagMonitor.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NPKLagMonitorDelegate <NSObject>

- (void)lagDetectWithStackInfo:(NSString *)stackInfo lagCount:(NSUInteger)lagCount;

@end

@interface NPKLagMonitor : NSObject

/// 主线程卡顿判断阈值，默认3秒。
@property (nonatomic, assign) NSTimeInterval timeOutInterval;
@property (nonatomic, assign, readonly) NSUInteger lagCount;
@property (nonatomic, weak, nullable) id<NPKLagMonitorDelegate> delegatet;

+ (instancetype)sharedInstance;

- (void)start;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
