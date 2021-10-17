//
//  NPKLaunchProtocol.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/10/14.
//

#import <Foundation/Foundation.h>

@protocol NPKLaunchProtocol <NSObject>

@optional

- (void)runWithOptions:(NSDictionary *)options;

- (void)runAfterPrepared;

@end
