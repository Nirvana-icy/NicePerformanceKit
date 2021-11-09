//
//  AAAANPKLaunchTimeProfile.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AAAANPKLaunchTimeProfile : NSObject

+ (void)setDidFinishLaunchCallbackTime:(double)callBacktime;
+ (void)setDidFinishLaunchFinishTime:(double)finishTime;

+ (double)timeT1;
+ (double)timeT2;
+ (double)launchTime;

+ (NSString *)launchTimeSummary;

@end

NS_ASSUME_NONNULL_END
