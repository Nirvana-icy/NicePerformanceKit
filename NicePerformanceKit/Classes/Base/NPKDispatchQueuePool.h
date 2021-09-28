//
//  NPKDispatchQueuePool.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKDispatchQueuePool : NSObject

- (instancetype)initWithName:(nullable NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos;

/// Pool's name.
@property (nullable, nonatomic, readonly) NSString *name;

/// Get a serial queue from pool.
- (dispatch_queue_t)queue;

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

/// Get a serial queue from global queue pool with a specified qos.
/// @param qos qos of the queue
extern dispatch_queue_t NPKDispatchQueueGetForQoS(NSQualityOfService qos);

NS_ASSUME_NONNULL_END
