//
//  NPKMockMXCallStackTree.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import <MetricKit/MetricKit.h>
#import "NPKBaseDefine.h"

#if NPK_METRICKIT_SUPPORTED
#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(14))
@interface NPKMockMXCallStackTree : MXCallStackTree

- (instancetype)initWithStringData:(NSString *)stringData;

@property(readonly, strong, nonnull) NSData *jsonData;

NS_ASSUME_NONNULL_END

@end

#endif
