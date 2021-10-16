//
//  NPKDiagnosticReportModel.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/13.
//

#import <Foundation/Foundation.h>
#import "NPKDiagnosticPayloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPKDiagnosticReportModel : NSObject

@property (readonly, nonatomic, strong) NSArray<NPKDiagnosticPayloadModel *> *npkDiagnosticPayloadModelArr;

- (instancetype)initWithNPKDiagnosticPayloadModelArr:(NSArray<NPKDiagnosticPayloadModel *> *)payloadModelArr;

- (NSString *)reportSummary;

@end

NS_ASSUME_NONNULL_END
