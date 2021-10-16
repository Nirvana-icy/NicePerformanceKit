//
//  NPKMockMXDiagnosticPayload.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import <Foundation/Foundation.h>
#import "NPKBaseDefine.h"

#if NPK_METRICKIT_SUPPORTED
#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(14))
@interface NPKMockMXDiagnosticPayload : MXDiagnosticPayload

- (instancetype)initWithDiagnostics:(NSDictionary *)diagnostics
                     timeStampBegin:(NSDate *)timeStampBegin
                       timeStampEnd:(NSDate *)timeStampEnd
                 applicationVersion:(NSString *)applicationVersion;

@property(readonly, strong, nullable) NSArray<MXCPUExceptionDiagnostic *> *cpuExceptionDiagnostics;

@property(readonly, strong, nullable)
    NSArray<MXDiskWriteExceptionDiagnostic *> *diskWriteExceptionDiagnostics;

@property(readonly, strong, nullable) NSArray<MXHangDiagnostic *> *hangDiagnostics;

@property(readonly, strong, nullable) NSArray<MXCrashDiagnostic *> *crashDiagnostics;

@property(readonly, strong, nonnull) NSDate *timeStampBegin;

@property(readonly, strong, nonnull) NSDate *timeStampEnd;

@end

NS_ASSUME_NONNULL_END

#endif
