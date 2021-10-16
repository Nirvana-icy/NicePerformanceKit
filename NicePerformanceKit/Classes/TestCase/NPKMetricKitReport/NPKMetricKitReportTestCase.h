//
//  NPKMetricKitReportTests.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKBaseDefine.h"

#if NPK_METRICKIT_SUPPORTED
#import <MetricKit/MetricKit.h>
#import "NPKMockMXCallStackTree.h"
#import "NPKMockMXMetaData.h"
#import "NPKMockMXCrashDiagnostic.h"
#import "NPKMockMXDiagnosticPayload.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(14))
@interface NPKMetricKitReportTestCase : NSObject

#pragma mark - Diagnostic Creation Helpers

- (NPKMockMXDiagnosticPayload *)createCrashDiagnosticPayload;

@end

NS_ASSUME_NONNULL_END

#endif
