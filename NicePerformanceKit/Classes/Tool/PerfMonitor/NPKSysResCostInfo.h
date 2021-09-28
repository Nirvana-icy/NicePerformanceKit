//
//  NPKSysResCostInfo.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKSysResCostInfo : NSObject

+ (NSString *)appCostInfo;

+ (NSString *)sysLoadInfo;

+ (float)currentAppMemory;

+ (float)currentSystemCpuUsage;

+ (float)currentAppCpuUsage;

+ (NSUInteger)currentAppThreadCount;

@end

NS_ASSUME_NONNULL_END
