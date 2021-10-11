//
//  NPKMetricKitManager.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import "NPKBaseDefine.h"

#if NPK_METRICKIT_SUPPORTED
#import <MetricKit/MetricKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NPKMetricKitManagerDelegate <NSObject>

- (void)handleNPKMetricPayloads;
- (void)handleNPKDiagnosticReport;

@end

@interface NPKMetricKitManager : NSObject <MXMetricManagerSubscriber>

+ (instancetype)sharedInstance API_AVAILABLE(ios(14));

/*!
 *  @brief 绑定数据接收对象，支持绑定多个数据消费者。
 *  数据接收者可以根据自身需求对数据进行处理。
 *  例如，线下：本地通知/UI展示；线上：埋点上报/API上传
 *  @param obj npk metric kit report 数据接收对象
 */
- (void)bind:(id<NPKMetricKitManagerDelegate>)obj;

/*!
 *  @brief 解绑数据接受对象
 *  @param obj npk metric kit report 数据接收对象
 */
- (void)unbind:(id<NPKMetricKitManagerDelegate>)obj;

@end

NS_ASSUME_NONNULL_END

#endif  // NPK_METRICKIT_SUPPORTED
