//
//  NPKPerfMonitor.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKPerfMonitor : NSObject

@property (nonatomic, assign, readonly) float appCPU;
@property (nonatomic, assign, readonly) float systemCPU;
@property (nonatomic, assign, readonly) float appMemory;
@property (nonatomic, assign, readonly) float gpuUsage;
@property (nonatomic, assign, readonly) float fps;
//@property (nonatomic, copy, readonly) NSString *gpuInfo;

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
