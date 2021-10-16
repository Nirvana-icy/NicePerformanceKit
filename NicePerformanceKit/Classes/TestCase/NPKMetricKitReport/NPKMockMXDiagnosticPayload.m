//
//  NPKMockMXDiagnosticPayload.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKMockMXDiagnosticPayload.h"
#if NPK_METRICKIT_SUPPORTED

@interface NPKMockMXDiagnosticPayload ()

@property(readwrite, strong, nullable) NSArray<MXCPUExceptionDiagnostic *> *cpuExceptionDiagnostics;
@property(readwrite, strong, nullable)
    NSArray<MXDiskWriteExceptionDiagnostic *> *diskWriteExceptionDiagnostics;
@property(readwrite, strong, nullable) NSArray<MXHangDiagnostic *> *hangDiagnostics;
@property(readwrite, strong, nullable) NSArray<MXCrashDiagnostic *> *crashDiagnostics;
@property(readwrite, strong, nonnull) NSDate *timeStampBegin;
@property(readwrite, strong, nonnull) NSDate *timeStampEnd;

@end

@implementation NPKMockMXDiagnosticPayload

@synthesize cpuExceptionDiagnostics = _cpuExceptionDiagnostics;
@synthesize diskWriteExceptionDiagnostics = _diskWriteExceptionDiagnostics;
@synthesize hangDiagnostics = _hangDiagnostics;
@synthesize crashDiagnostics = _crashDiagnostics;
@synthesize timeStampEnd = _timeStampEnd;
@synthesize timeStampBegin = _timeStampBegin;

- (instancetype)initWithDiagnostics:(NSDictionary *)diagnostics
                     timeStampBegin:(NSDate *)timeStampBegin
                       timeStampEnd:(NSDate *)timeStampEnd
                 applicationVersion:(NSString *)applicationVersion {
  self = [super init];
  _timeStampBegin = timeStampBegin;
  _timeStampEnd = timeStampEnd;
  _crashDiagnostics = [diagnostics objectForKey:@"crashes"];
  _hangDiagnostics = [diagnostics objectForKey:@"hangs"];
  _cpuExceptionDiagnostics = [diagnostics objectForKey:@"cpuExceptionDiagnostics"];
  _diskWriteExceptionDiagnostics = [diagnostics objectForKey:@"diskWriteExceptionDiagnostics"];
  return self;
}

@end

#endif
