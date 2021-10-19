//
//  NPKitDisplayWindow.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKitDisplayWindow : UIWindow

+ (instancetype)sharedInstance;

- (void)updatePerfInfo:(NSString *)perfInfo;

// show toast in NPKitDisplayWindow with default 5 second
- (void)showToast:(NSString *)toastInfo;

// show toast in NPKEntryWindow with custom duration
- (void)showToast:(NSString *)toastInfo withDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
