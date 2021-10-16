//
//  NPKMockMXCrashDiagnostic.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKMockMXCrashDiagnostic.h"

#if NPK_METRICKIT_SUPPORTED

@interface NPKMockMXCrashDiagnostic ()

@property(readwrite, strong, nonnull) NPKMockMXCallStackTree *callStackTree;
@property(readwrite, strong, nonnull) NSString *terminationReason;
@property(readwrite, strong, nonnull) NSString *virtualMemoryRegionInfo;
@property(readwrite, strong, nonnull) NSNumber *exceptionType;
@property(readwrite, strong, nonnull) NSNumber *exceptionCode;
@property(readwrite, strong, nonnull) NSNumber *signal;
@property(readwrite, strong, nonnull) NPKMockMXMetaData *metaData;
@property(readwrite, strong, nonnull) NSString *applicationVersion;

@end

@implementation NPKMockMXCrashDiagnostic

@synthesize callStackTree = _callStackTree;
@synthesize terminationReason = _terminationReason;
@synthesize virtualMemoryRegionInfo = _virtualMemoryRegionInfo;
@synthesize exceptionType = _exceptionType;
@synthesize exceptionCode = _exceptionCode;
@synthesize signal = _signal;
@synthesize metaData = _metaData;
@synthesize applicationVersion = _applicationVersion;

- (instancetype)initWithCallStackTree:(NPKMockMXCallStackTree *)callStackTree
                    terminationReason:(NSString *)terminationReason
              virtualMemoryRegionInfo:(NSString *)virtualMemoryRegionInfo
                        exceptionType:(NSNumber *)exceptionType
                        exceptionCode:(NSNumber *)exceptionCode
                               signal:(NSNumber *)signal
                             metaData:(NPKMockMXMetaData *)metaData
                   applicationVersion:(NSString *)applicationVersion {
    self = [super init];
      _callStackTree = callStackTree;
      _terminationReason = terminationReason;
      _virtualMemoryRegionInfo = virtualMemoryRegionInfo;
      _exceptionCode = exceptionCode;
      _exceptionType = exceptionType;
      _signal = signal;
      _applicationVersion = applicationVersion;
      _metaData = metaData;
      return self;
}

@end

#endif
