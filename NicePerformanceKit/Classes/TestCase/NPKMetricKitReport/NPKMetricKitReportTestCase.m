//
//  NPKMetricKitReportTests.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKMetricKitReportTestCase.h"

#if NPK_METRICKIT_SUPPORTED

NS_ASSUME_NONNULL_BEGIN

@implementation NPKMetricKitReportTestCase

#pragma mark - Diagnostic Creation Helpers

- (NPKMockMXDiagnosticPayload *)createCrashDiagnosticPayload {
 NSDictionary *diagnostics = @{@"crashes" : @[[self createCrashDiagnostic], [self createCrashDiagnostic]]};
 return [[NPKMockMXDiagnosticPayload alloc] initWithDiagnostics:diagnostics
                                                    timeStampBegin:[NSDate date]
                                                      timeStampEnd:[NSDate dateWithTimeIntervalSinceNow:1]
                                                applicationVersion:@"1.0.1"];
}

- (NPKMockMXCallStackTree *)createMockCallStackTree {
  NSString *callStackTreeString =
      @"{\n  \"callStacks\" : [\n    {\n      \"threadAttributed\" : true,\n      "
      @"\"callStackRootFrames\" : [\n        {\n          \"binaryUUID\" : "
      @"\"6387F46B-BE42-4575-8BFA-782CAAE676AA\",\n          \"offsetIntoBinaryTextSegment\" : "
      @"123,\n          \"sampleCount\" : 20,\n          \"binaryName\" : \"testBinaryName\",\n    "
      @"      \"address\" : 74565\n        }\n      ]\n    }\n  ],\n  \"callStackPerThread\" : "
      @"true\n}";
  return [[NPKMockMXCallStackTree alloc] initWithStringData:callStackTreeString];
}

- (NPKMockMXMetaData *)createMockMetaData {
  return [[NPKMockMXMetaData alloc] initWithRegionFormat:@"CN"
                                                  osVersion:@"iPhone OS 14.2 (18B92)"
                                                 deviceType:@"iPhone10,3"
                                    applicationBuildVersion:@"1"
                                       platformArchitecture:@"arm64"];
}

- (NPKMockMXCrashDiagnostic *)createCrashDiagnostic {
  return [[NPKMockMXCrashDiagnostic alloc]
        initWithCallStackTree:[self createMockCallStackTree]
            terminationReason:@"Namespace SIGNAL, Code 0xb"
      virtualMemoryRegionInfo:
          @"0 is not in any region.  Bytes before following region: 4000000000 REGION TYPE         "
          @"             START - END             [ VSIZE] PRT\\/MAX SHRMOD  REGION DETAIL UNUSED "
          @"SPACE AT START ---> __TEXT                 0000000000000000-0000000000000000 [   32K] "
          @"r-x\\/r-x SM=COW  ...pp\\/Test"
                exceptionType:@1
                exceptionCode:@1
                       signal:@11
                     metaData:[self createMockMetaData]
           applicationVersion:@"1.0.1"];
}

@end

NS_ASSUME_NONNULL_END

#endif
