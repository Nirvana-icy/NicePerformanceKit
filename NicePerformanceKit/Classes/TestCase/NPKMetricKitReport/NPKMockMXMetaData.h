//
//  NPKMockMXMetaData.h
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
@interface NPKMockMXMetaData : MXMetaData

- (instancetype)initWithRegionFormat:(NSString *)regionFormat
                           osVersion:(NSString *)osVersion
                          deviceType:(NSString *)deviceType
             applicationBuildVersion:(NSString *)applicationBuildVersion
                platformArchitecture:(NSString *)platformArchitecture;

@property(readonly, strong, nonnull) NSString *regionFormat;

@property(readonly, strong, nonnull) NSString *osVersion;

@property(readonly, strong, nonnull) NSString *deviceType;

@property(readonly, strong, nonnull) NSString *applicationBuildVersion;

@property(readonly, strong, nonnull) NSString *platformArchitecture;

- (NSData *)JSONRepresentation;

@end

NS_ASSUME_NONNULL_END

#endif
