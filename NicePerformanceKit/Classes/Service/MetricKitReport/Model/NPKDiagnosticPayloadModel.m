//
//  NPKDiagnosticPayloadModel.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/12.
//

#import "NPKDiagnosticPayloadModel.h"
#import "NPKCallStackTree.h"

@implementation NPKBaseDiagnosticModel

+ (NSArray *)convertThreadsToArray:(MXCallStackTree *)mxCallStackTree {
    NPKCallStackTree *tree = [[NPKCallStackTree alloc] initWithMXCallStackTree:mxCallStackTree];
    return [tree getArrayRepresentation];
}

+ (NSArray *)convertThreadsToArrayForNonfatal:(MXCallStackTree *)mxCallStackTree {
    NPKCallStackTree *tree = [[NPKCallStackTree alloc] initWithMXCallStackTree:mxCallStackTree];
    return [tree getFramesOfBlamedThread];
}

@end

@implementation NPKCrashDiagnosticModel

- (instancetype)initWithMXCrashDiagnostic:(MXCrashDiagnostic *)crashDiagnostic {
    self = [super init];
    if (self) {
        self.appVersion = crashDiagnostic.applicationVersion;
        self.buildVersion = crashDiagnostic.metaData.applicationBuildVersion;
        self.threadTraceArr = [NPKBaseDiagnosticModel convertThreadsToArray:crashDiagnostic.callStackTree];
        
        self.exceptionType = crashDiagnostic.exceptionType;
        self.exceptionTypeName = [NPKCrashDiagnosticModel getExceptionName:crashDiagnostic.exceptionType];
        self.exceptionCode = crashDiagnostic.exceptionCode;
        
        self.signal = crashDiagnostic.signal;
        self.signalName = [NPKCrashDiagnosticModel getSignalName:crashDiagnostic.signal];
        
        self.terminationReason = crashDiagnostic.terminationReason;
        self.virtualMemoryRegionInfo = crashDiagnostic.virtualMemoryRegionInfo;
    }
    return self;
}

// @see    sys/exception_types.h
+ (NSString *)getExceptionName:(NSNumber *)exceptionType {
  int exception = [exceptionType intValue];
  switch (exception) {
    case EXC_BAD_ACCESS:
      return @"EXC_BAD_ACCESS";
    case EXC_BAD_INSTRUCTION:
      return @"EXC_BAD_INSTRUCTION";
    case EXC_ARITHMETIC:
      return @"EXC_ARITHMETIC";
    case EXC_SOFTWARE:
      return @"EXC_SOFTWARE";
    case EXC_CRASH:
      return @"EXC_CRASH";
    case SIGSYS:
      return @"SIGSYS";
    case EXC_RESOURCE:
      return @"EXC_RESOURCE";
    default:
      return @"UNKNOWN";
  }
  return @"UNKNOWN";
}

// @see    sys/signal.h
+ (NSString *)getSignalName:(NSNumber *)signal {
  int exception = [signal intValue];
  switch (exception) {
    case SIGABRT:
      return @"SIGABRT";
    case SIGBUS:
      return @"SIGBUS";
    case SIGFPE:
      return @"SIGFPE";
    case SIGILL:
      return @"SIGILL";
    case SIGSEGV:
      return @"SIGSEGV";
    case SIGSYS:
      return @"SIGSYS";
    case SIGTRAP:
      return @"SIGTRAP";
    case SIGHUP:
      return @"SIGHUP";
    default:
      return @"UNKNOWN";
  }
  return @"UNKNOWN";
}

@end

@implementation NPKHangDiagnosticModel

@end

@implementation NPKDiagnosticPayloadModel

- (instancetype)initWithMXDiagnosticPayload:(MXDiagnosticPayload *)diagnosticPayload API_AVAILABLE(ios(14)) {
    NPKDiagnosticPayloadModel *model = [NPKDiagnosticPayloadModel new];
    
    if (diagnosticPayload.crashDiagnostics.count > 0) {
        NSMutableArray<NPKCrashDiagnosticModel *> *crashDiagnosticModelArr = [NSMutableArray array];
        for (MXCrashDiagnostic *crashDiagnostic in diagnosticPayload.crashDiagnostics) {
            NPKCrashDiagnosticModel *crashDiagnosticModel = [[NPKCrashDiagnosticModel alloc] initWithMXCrashDiagnostic:crashDiagnostic];
            [crashDiagnosticModelArr addObject:crashDiagnosticModel];
        }
        model.crashDiagnosticModelArr = [crashDiagnosticModelArr copy];
    }
    
    return model;
}

@end
