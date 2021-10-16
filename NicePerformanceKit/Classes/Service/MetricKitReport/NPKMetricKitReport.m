//
//  NPKMetricKitReport.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/11.
//

#import "NPKMetricKitReport.h"
#import "NPKDiagnosticPayloadModel.h"

#if NPK_METRICKIT_SUPPORTED

@interface NPKMetricKitReport ()

@property (nonatomic, strong) NSMutableArray *npkMetricKitReportHandlerArr;

@end

@implementation NPKMetricKitReport

+ (instancetype)sharedInstance API_AVAILABLE(ios(14)) {
    static NPKMetricKitReport *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [NPKMetricKitReport new];
        [[MXMetricManager sharedManager] addSubscriber:_sharedInstance];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _npkMetricKitReportHandlerArr = [NSMutableArray array];
    }
    return self;
}

- (void)bind:(id<NPKMetricKitReportDelegate>)obj {
    if (![self.npkMetricKitReportHandlerArr containsObject:obj] && obj) {
        [self.npkMetricKitReportHandlerArr addObject:obj];
    }
}

- (void)unbind:(id<NPKMetricKitReportDelegate>)obj {
    if ([self.npkMetricKitReportHandlerArr containsObject:obj]) {
        [self.npkMetricKitReportHandlerArr removeObject:obj];
    }
}

- (void)didReceiveMetricPayloads:(NSArray<MXMetricPayload *> *)payloads API_AVAILABLE(ios(14)) {
    // Todo:
    // applicationExitMetrics
    // memoryMetrics
    [self.npkMetricKitReportHandlerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(id<NPKMetricKitReportDelegate>)obj respondsToSelector:@selector(handleNPKMetricPayloads)]) {
            [(id<NPKMetricKitReportDelegate>)obj handleNPKMetricPayloads];
        }
    }];
}

- (void)didReceiveDiagnosticPayloads:(NSArray<MXDiagnosticPayload *> *)payloads API_AVAILABLE(ios(14)) {
    if (payloads.count <= 0) return;
    
    NSMutableArray<NPKDiagnosticPayloadModel *> *npkDiagnosticPayloadModelArr = [NSMutableArray array];
    for (MXDiagnosticPayload *diagnosticPayload in payloads) {
        // process payload
        NPKDiagnosticPayloadModel *npkDiagnosticPayloadModel = [[NPKDiagnosticPayloadModel alloc] initWithMXDiagnosticPayload:diagnosticPayload];
        [npkDiagnosticPayloadModelArr addObject:npkDiagnosticPayloadModel];
    }
    NPKDiagnosticReportModel *npkDiagnosticReportModel = [[NPKDiagnosticReportModel alloc] initWithNPKDiagnosticPayloadModelArr:npkDiagnosticPayloadModelArr];
    [self.npkMetricKitReportHandlerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(id<NPKMetricKitReportDelegate>)obj respondsToSelector:@selector(didReceiveNPKDiagnosticReportModel:)]) {
            [(id<NPKMetricKitReportDelegate>)obj didReceiveNPKDiagnosticReportModel:npkDiagnosticReportModel];
        }
    }];
}

# pragma mark -- helper

/*
 * Helper method to convert metadata for a MetricKit diagnostic event to a dictionary. MXMetadata
 * has a dictionaryRepresentation method but it is deprecated.
 */
- (NSDictionary *)convertMetaDataToDictionary:(MXMetaData *)metaData API_AVAILABLE(ios(14)) {
    NSError *error = nil;
    NSDictionary *metaDataDictionary =
    [NSJSONSerialization JSONObjectWithData:[metaData JSONRepresentation] options:0 error:&error];
    return metaDataDictionary;
}

@end

#endif  // NPK_METRICKIT_SUPPORTED
