#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NPKBaseDefine.h"
#import "NPKDispatchQueuePool.h"
#import "NPKWeakProxy.h"
#import "NPKLaunchConfig.h"
#import "NPKLaunchConfigPluginDefinition.h"
#import "NPKLaunchManager.h"
#import "NPKLaunchProtocol.h"
#import "NPKLaunchTaskModel.h"
#import "NPKLaunchTaskService.h"
#import "NPKCallStackTree.h"
#import "NPKDiagnosticPayloadModel.h"
#import "NPKDiagnosticReportModel.h"
#import "NPKMetricKitReport.h"
#import "NPKFPSMonitor.h"
#import "NPKLagMonitor.h"
#import "NPKPerfEntryWindow.h"
#import "NPKPerfMonitor.h"
#import "NPKSysResCostInfo.h"
#import "NPKBadPerfCase.h"
#import "NPKMetricKitReportTestCase.h"
#import "NPKMockMXCallStackTree.h"
#import "NPKMockMXCrashDiagnostic.h"
#import "NPKMockMXDiagnosticPayload.h"
#import "NPKMockMXMetaData.h"
#import "NPKPerfTestCase+GCD.h"
#import "NPKPerfTestCase.h"
#import "NPKImageCompressTool.h"
#import "appletrace.h"
#import "NPKSignpostLog.h"

FOUNDATION_EXPORT double NicePerformanceKitVersionNumber;
FOUNDATION_EXPORT const unsigned char NicePerformanceKitVersionString[];

