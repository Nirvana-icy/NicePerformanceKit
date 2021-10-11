//
//  NPKLaunchConfig.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NPKLaunchConfigProtocol <NSObject>

- (NSArray *)defaultLaunchList;

@end

@interface NPKLaunchConfig : NSObject <NPKLaunchConfigProtocol>

- (NSArray *)defaultLaunchList;

@end

NS_ASSUME_NONNULL_END
