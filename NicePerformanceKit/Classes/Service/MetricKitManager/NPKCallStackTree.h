//
//  NPKCallStackTree.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import <NicePerformanceKit/NPKBaseDefine.h>

#if NPK_METRICKIT_SUPPORTED
#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKCallStackTree : NSObject

- (instancetype)initWithMXCallStackTree:(MXCallStackTree *)callStackTree API_AVAILABLE(ios(14.0));
- (NSArray *)getArrayRepresentation;
- (NSArray *)getFramesOfBlamedThread;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#endif  // NPK_METRICKIT_SUPPORTED
