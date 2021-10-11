//
//  NPKMetricKitManager.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/11.
//

#import "NPKMetricKitManager.h"
#import "NPKCallStackTree.h"

#if NPK_METRICKIT_SUPPORTED

@interface NPKMetricKitManager ()

@property (nonatomic, strong) NSMutableArray *mxPayloadsHandlers;

@end

@implementation NPKMetricKitManager

+ (instancetype)sharedInstance API_AVAILABLE(ios(14)) {
    static NPKMetricKitManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKMetricKitManager new];
        [[MXMetricManager sharedManager] addSubscriber:_sharedInstance];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mxPayloadsHandlers = [NSMutableArray array];
    }
    return self;
}

- (void)bind:(id<NPKMetricKitManagerDelegate>)obj {
    if (![self.mxPayloadsHandlers containsObject:obj] && obj) {
        [self.mxPayloadsHandlers addObject:obj];
    }
}

- (void)unbind:(id<NPKMetricKitManagerDelegate>)obj {
    if ([self.mxPayloadsHandlers containsObject:obj]) {
        [self.mxPayloadsHandlers removeObject:obj];
    }
}

- (void)didReceiveMetricPayloads:(NSArray<MXMetricPayload *> *)payloads API_AVAILABLE(ios(14)) {
    // Todo:
    // applicationExitMetrics
    // memoryMetrics
    [self.mxPayloadsHandlers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(id<NPKMetricKitManagerDelegate>)obj respondsToSelector:@selector(handleNPKMetricPayloads)]) {
            [(id<NPKMetricKitManagerDelegate>)obj handleNPKMetricPayloads];
        }
    }];
}

- (void)didReceiveDiagnosticPayloads:(NSArray<MXDiagnosticPayload *> *)payloads API_AVAILABLE(ios(14)) {
    for (MXDiagnosticPayload *diagnosticPayload in payloads) {
        // process payload
        [self processMXDiagnosticPayload:diagnosticPayload];
    }
    
    [self.mxPayloadsHandlers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(id<NPKMetricKitManagerDelegate>)obj respondsToSelector:@selector(handleNPKDiagnosticReport)]) {
            [(id<NPKMetricKitManagerDelegate>)obj handleNPKDiagnosticReport];
        }
    }];
}

# pragma mark -- helper

- (void)processMXDiagnosticPayload:(MXDiagnosticPayload *)diagnosticPayload API_AVAILABLE(ios(14)) {
    if (!diagnosticPayload) return;
    // cpuException
    // crash
    // diskWriteException
    // hang
}

/*
 * Helper method to convert threads for a MetricKit fatal diagnostic event to an array of threads.
 */
- (NSArray *)convertThreadsToArray:(MXCallStackTree *)mxCallStackTree API_AVAILABLE(ios(14)) {
    NPKCallStackTree *tree = [[NPKCallStackTree alloc] initWithMXCallStackTree:mxCallStackTree];
    return [tree getArrayRepresentation];
}

/*
 * Helper method to convert threads for a MetricKit nonfatal diagnostic event to an array of frames.
 */
- (NSArray *)convertThreadsToArrayForNonfatal:(MXCallStackTree *)mxCallStackTree
API_AVAILABLE(ios(14)) {
    NPKCallStackTree *tree = [[NPKCallStackTree alloc] initWithMXCallStackTree:mxCallStackTree];
    return [tree getFramesOfBlamedThread];
}

/*
 * Helper method to convert metadata for a MetricKit diagnostic event to a dictionary. MXMetadata
 * has a dictionaryRepresentation method but it is deprecated.
 */
- (NSDictionary *)convertMetadataToDictionary:(MXMetaData *)metadata API_AVAILABLE(ios(14)) {
    NSError *error = nil;
    NSDictionary *metaDataDictionary =
    [NSJSONSerialization JSONObjectWithData:[metadata JSONRepresentation] options:0 error:&error];
    return metaDataDictionary;
}

@end

#endif  // NPK_METRICKIT_SUPPORTED
