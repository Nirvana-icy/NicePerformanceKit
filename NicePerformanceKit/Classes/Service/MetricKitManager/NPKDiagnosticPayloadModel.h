//
//  NPKDiagnosticPayloadModel.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/12.
//

#import <Foundation/Foundation.h>
#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKBaseDiagnosticModel : NSObject

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *buildVersion;
@property (nonatomic, strong) NSArray *stack;

/*
 * Helper method to convert threads for a MetricKit fatal diagnostic event to an array of threads.
 */
+ (NSArray *)convertThreadsToArray:(MXCallStackTree *)mxCallStackTree API_AVAILABLE(ios(14));

/*
 * Helper method to convert threads for a MetricKit nonfatal diagnostic event to an array of frames.
 */
+ (NSArray *)convertThreadsToArrayForNonfatal:(MXCallStackTree *)mxCallStackTree
API_AVAILABLE(ios(14));

@end

@interface NPKCrashDiagnosticModel : NPKBaseDiagnosticModel

@property (nonatomic, copy) NSString *exceptionName;
@property (nonatomic, copy) NSNumber *exceptionCode;
@property (nonatomic, copy) NSNumber *signal;
@property (nonatomic, copy) NSString *terminationReason;
@property (nonatomic, copy) NSString *virtualMemoryRegionInfo;

- (instancetype)initWithMXCrashDiagnostic:(MXCrashDiagnostic *)crashDiagnostic API_AVAILABLE(ios(14));
    
+ (NSString *)getExceptionName:(NSNumber *)exceptionType;

@end

@interface NPKHangDiagnosticModel : NPKBaseDiagnosticModel

@end

@interface NPKDiagnosticPayloadModel : NSObject

//@property (readonly, nonatomic, strong, nullable) NSArray<MXCPUExceptionDiagnostic *> *cpuExceptionDiagnostics;
//@property (readonly, nonatomic, strong, nullable) NSArray<MXDiskWriteExceptionDiagnostic *> *diskWriteExceptionDiagnostics;
@property (nonatomic, strong, nullable) NSArray<NPKCrashDiagnosticModel *> *crashDiagnosticModelArr;
@property (nonatomic, strong, nullable) NSArray<NPKHangDiagnosticModel *> *hangDiagnosticModelArr;

@property (nonatomic, strong) NSDate *timeStampBegin;
@property (nonatomic, strong) NSDate *timeStampEnd;

//@property (readonly, nonatomic, strong) NSString *appVersion;
//@property (readonly, nonatomic, strong) NSString *buildVersion;
//@property (readonly, nonatomic, strong) NSString *deviceType;
//@property (readonly, nonatomic, strong) NSString *osVersion;

- (instancetype)initWithMXDiagnosticPayload:(MXDiagnosticPayload *)diagnosticPayload API_AVAILABLE(ios(14));

@end

NS_ASSUME_NONNULL_END
