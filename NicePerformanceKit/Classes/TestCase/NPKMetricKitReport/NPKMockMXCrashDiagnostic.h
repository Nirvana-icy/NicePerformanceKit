//
//  NPKMockMXCrashDiagnostic.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import <MetricKit/MetricKit.h>
#import "NPKBaseDefine.h"

#if NPK_METRICKIT_SUPPORTED
#import <MetricKit/MetricKit.h>
#import "NPKMockMXCallStackTree.h"
#import "NPKMockMXMetaData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPKMockMXCrashDiagnostic : MXCrashDiagnostic

- (instancetype)initWithCallStackTree:(NPKMockMXCallStackTree *)callStackTree
                    terminationReason:(NSString *)terminationReason
              virtualMemoryRegionInfo:(NSString *)virtualMemoryRegionInfo
                        exceptionType:(NSNumber *)exceptionType
                        exceptionCode:(NSNumber *)exceptionCode
                               signal:(NSNumber *)signal
                             metaData:(NPKMockMXMetaData *)metaData
                   applicationVersion:(NSString *)applicationVersion;

@property(readonly, strong, nonnull) NPKMockMXCallStackTree *callStackTree;

@property(readonly, strong, nonnull) NSString *terminationReason;

@property(readonly, strong, nonnull) NSString *virtualMemoryRegionInfo;

@property(readonly, strong, nonnull) NSNumber *exceptionType;

@property(readonly, strong, nonnull) NSNumber *exceptionCode;

@property(readonly, strong, nonnull) NSNumber *signal;

@property(readonly, strong, nonnull) NPKMockMXMetaData *metaData;

@property(readonly, strong, nonnull) NSString *applicationVersion;

@end

NS_ASSUME_NONNULL_END

#endif
