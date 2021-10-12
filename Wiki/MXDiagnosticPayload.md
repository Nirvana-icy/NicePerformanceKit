## MXDiagnosticPayload

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| cpuExceptionDiagnostics| NSArray<MXCPUExceptionDiagnostic *>  | | 
| diskWriteExceptionDiagnostics| NSArray<MXDiskWriteExceptionDiagnostic *>  | | 
| hangDiagnostics| NSArray<MXHangDiagnostic *>  | |
| crashDiagnostics| NSArray<MXCrashDiagnostic *>  | | 
| timeStampBegin| NSDate | |
| timeStampEnd | NSDate | | 

> NPKDiagnosticPayload

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| cpuExceptionDiagnostics| NSArray<NPKCPUExceptionDiagnostic *>  | | 
| diskWriteExceptionDiagnostics| NSArray<NPKDiskWriteExceptionDiagnostic *>  | | 
| hangDiagnostics| NSArray<NPKHangDiagnostic *>  | |
| crashDiagnostics| NSArray<NPKCrashDiagnostic *>  | | 
| timeStampBegin| NSDate | |
| timeStampEnd | NSDate | | 

---

> MXMetaData : NSObject

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| regionFormat | NSString  | | 
| osVersion | NSString  | iPhone OS 14.2 (18B92) | 
| deviceType | NSString  | iPhone10,3 | 
| applicationBuildVersion | NSString  |  | 
| platformArchitecture | NSString  |  | 

> MXDiagnostic : NSObject

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| metaData | MXMetaData  | | 
| applicationVersion | NSString  | | 

> MXCrashDiagnostic : MXDiagnostic

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| metaData| MXMetaData  | | 
| applicationVersion| NSString  | | 
| callStackTree| MXCallStackTree  | The application call stack tree associated with this crash.| 
| terminationReason| NSString  | The termination reason associated with this crash.| 
| virtualMemoryRegionInfo| NSString |This property is set when a bad memory access crash occurs. |
| exceptionType| NSNumber  |The name of the Mach exception that terminated the app. | 
| exceptionCode| NSNumber |Processor specific information about the exception encoded into one or more 64-bit hexadecimal numbers |
| signal| NSNumber |The signal associated with this crash. |

> NPKCrashDiagnosticModel

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| appVersion| NSString  | | 
| buildVersion| NSString  | | 
| binaryUUID| NSString  | | 
| exceptionName| NSString  |[self getExceptionName:crashDiagnostic.exceptionType] | 
| exceptionCode| NSNumber |Processor specific information about the exception encoded into one or more 64-bit hexadecimal numbers |
| signal| NSNumber |The signal associated with this crash. |
| terminationReason| NSString  | The termination reason associated with this crash.| 
| threads| NSArray     | [self convertThreadsToArray:crashDiagnostic.callStackTree] | 
| virtualMemoryRegionInfo| NSString |This property is set when a bad memory access crash occurs. |


> MXHangDiagnostic : MXDiagnostic

|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| callStackTree| MXCallStackTree  | The application call stack tree associated with the hang.| 
| hangDuration| NSMeasurement<NSUnitDuration *>  | Total hang duration for this diagnostic.| 

NPK扩展
|字段| 类型 | 备注 |
| :-:| :-: | :-: |
| threads| NSArray     | [self convertThreadsToArray:crashDiagnostic.callStackTree] | 
