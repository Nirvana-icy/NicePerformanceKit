//
//  NPKDiagnosticReportModel.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import "NPKDiagnosticReportModel.h"

@interface NPKDiagnosticReportModel ()

@property (readwrite, nonatomic, strong) NSArray<NPKDiagnosticPayloadModel *> *npkDiagnosticPayloadModelArr;

@end

@implementation NPKDiagnosticReportModel

- (instancetype)initWithNPKDiagnosticPayloadModelArr:(NSArray<NPKDiagnosticPayloadModel *> *)payloadModelArr {
    self = [super init];
    if (self) {
        _npkDiagnosticPayloadModelArr = payloadModelArr;
    }
    return self;
}

- (NSString *)reportSummary {
    NSUInteger numOfCrash = 0;
    for (NPKDiagnosticPayloadModel *payloadModel in self.npkDiagnosticPayloadModelArr) {
        numOfCrash += payloadModel.crashDiagnosticModelArr.count;
    }
    NSString *summary = [NSString stringWithFormat:@"Crash: %lu.", numOfCrash];
    return summary;
}

@end
