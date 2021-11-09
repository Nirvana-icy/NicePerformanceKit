//
//  NPKitDisplayWindow.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NPKitMsgLevel) {
    NPKitMsgLevelDefault = 0,  // 展示5秒
    NPKitMsgLevelHigh,
    NPKitMsgLevelMiddle,
    NPKitMsgLevelLow
};

@protocol NPKitDisplayWindowDelegate <NSObject>

// NPKitDisplayWindow 默认实现简易 信息展示。支持外部通过代理实现 信息展示的扩展。
- (void)handleNPKitDisplayMessage:(NSString *)message withMsgLevel:(NPKitMsgLevel)npkMsgLevel;

@end


@interface NPKitDisplayWindow : UIWindow

+ (instancetype)sharedInstance;

- (void)updatePerfInfo:(NSString *)perfInfo;

// show message in NPKitDisplayWindow with default 5 second
- (void)showMessage:(NSString *)message;

// show message in NPKEntryWindow with NPKitMsgLevel
- (void)message:(NSString *)message withMsgLevel:(NPKitMsgLevel)npkMsgLevel;

- (void)bind:(id<NPKitDisplayWindowDelegate>)obj;
- (void)unbind:(id<NPKitDisplayWindowDelegate>)obj;

@end

NS_ASSUME_NONNULL_END
