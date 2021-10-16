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
@property (nonatomic, strong) NSArray *threadTraceArr;

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

/*!
@property      exceptionType
@abstract      The name of the Mach exception that terminated the app.
@see           sys/exception_types.h
*/
@property (nonatomic, copy) NSNumber *exceptionType;

/*!
@property      exceptionTypeName
@abstract      The name of the Mach exception that terminated the app. Convert from exceptionType.
@see           sys/exception_types.h
*/
@property (nonatomic, copy) NSString *exceptionTypeName;

/*!
@property      exceptionCode
@abstract      Processor specific information about the exception encoded into one or more 64-bit hexadecimal numbers
@see           sys/exception_types.h
*/
@property (nonatomic, copy) NSNumber *exceptionCode;

/*!
@property      signal
@abstract      The signal associated with this crash.
@see           sys/signal.h
*/
@property (nonatomic, copy) NSNumber *signal;

/*!
@property      signalName
@abstract      The signalName associated with this crash. Convert from signal.
@see           sys/signal.h
*/
@property (nonatomic, copy) NSString *signalName;

/*!
@property      terminationReason
@abstract      The termination reason associated with this crash.
@discussion    Exit reason information specified when a process is terminated. Key system components, both inside and outside of a process, will terminate the process upon encountering a fatal error (e.g. a bad code signature, a missing dependent library, or accessing privacy sensitive information without the proper entitlement).
*/
@property (nonatomic, copy) NSString *terminationReason;

/*!
@property      virtualMemoryRegionInfo
@abstract      Details about memory that the app incorrectly accessed in relation to other sections of the app’s virtual memory address space.
@discussion    This property is set when a bad memory access crash occurs.
*/
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
