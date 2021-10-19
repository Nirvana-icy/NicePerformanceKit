//
//  NPKFPS.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKFPSMonitor : NSObject

@property (nonatomic, assign) float currentFPS;

+ (NPKFPSMonitor *)sharedInstance;

- (void)startMonitoring;

- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
