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
#import "NPKImageCompressTool.h"
#import "NPKLaunchManager.h"
#import "NPKLaunchTaskService.h"
#import "appletrace.h"
#import "NPKSignpostLog.h"

FOUNDATION_EXPORT double NicePerformanceKitVersionNumber;
FOUNDATION_EXPORT const unsigned char NicePerformanceKitVersionString[];

