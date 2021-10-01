//
//  NPKPerfEntryWindow.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKPerfEntryWindow : UIWindow

+ (instancetype)sharedInstance;

- (void)updatePerfInfo:(NSString *)perfInfo;

- (void)updatePerfInfo:(NSString *)perfInfo withFlash:(BOOL)isNeedFlash;

@end

NS_ASSUME_NONNULL_END
