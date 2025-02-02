//
//  NPKAppDelegate.m
//  NPKitDemo
//
//  Created by jinglong.bi@me.com on 09/09/2021.
//  Copyright (c) 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKAppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <NicePerformanceKit/NPKLaunchEngine.h>
#import <NicePerformanceKit/NPKMetricKitReport.h>
#import <NicePerformanceKit/NPKitDisplayWindow.h>
#import "NPKitDemo_Example-Swift.h"

@interface NPKAppDelegate ()

<
UNUserNotificationCenterDelegate,
NPKMetricKitReportDelegate,
NPKitDisplayWindowDelegate
>

@property (nonatomic, strong) NPKDanmakuMsgViewController *npkDanmukuMsgViewController;

@end

@implementation NPKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NPKitDisplayWindow sharedInstance] bind:self];
    
    [[NPKLaunchEngine sharedInstance] startWithOptions:launchOptions];
    
    if (@available(iOS 14, *)) {
        [[NPKMetricKitReport sharedInstance] bind:self];
    }
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (@available(iOS 14, *)) {
        [[NPKMetricKitReport sharedInstance] unbind:self];
    }
    [[NPKitDisplayWindow sharedInstance] unbind:self];
}

#pragma mark -- NPKitDisplayWindowDelegate

- (void)handleNPKitDisplayMessage:(NSString *)message withMsgLevel:(NPKitMsgLevel)npkMsgLevel {
    [self.npkDanmukuMsgViewController sendCommonDanmakuWithMsg:message];
}

- (NPKDanmakuMsgViewController *)npkDanmukuMsgViewController {
    if (!_npkDanmukuMsgViewController) {
        _npkDanmukuMsgViewController = [NPKDanmakuMsgViewController new];
        [[NPKitDisplayWindow sharedInstance] addSubview:_npkDanmukuMsgViewController.danmakuView];
        [_npkDanmukuMsgViewController.danmakuView play];
    }
    return _npkDanmukuMsgViewController;
}

#pragma mark - NPKMetricKitManagerDelegate

- (void)handleNPKMetricPayloads {
    
}

- (void)didReceiveNPKDiagnosticReportModel:(NPKDiagnosticReportModel *)npkDiagnosticReportModel {
    // 线下：本地通知/UI展示
    [self sendNPKLocalNotificationWithSubTitle:npkDiagnosticReportModel.reportSummary
                                          body:@""];
    // 线上：埋点上报/API上传
}

- (void)sendNPKLocalNotificationWithSubTitle:(NSString *)subTitle
                                        body:(NSString *)body {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"[NPK] 性能诊断报告";
    content.subtitle = subTitle;
//    content.body = @"这是通知body这是通知body这是通知body这是通知body这是通知body这是通知body";
    // 通知的提示声音，这里用的默认的声音
    content.sound = [UNNotificationSound defaultSound];
    // 标识符
    content.categoryIdentifier = @"com.npk.mx.report";
    // 2、创建通知触发
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.f repeats:NO];
    
    // 3、创建通知请求
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"com.npk.mx.report.request" content:content trigger:trigger];
    // 4、将请求加入通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NPKLog(@"已成功加推送%@", notificationRequest.identifier);
        }
    }];
}

#pragma mark - iOS10 推送代理

//不实现，通知不会有提示
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

// 对通知进行响应
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    if ([response.notification.request.content.categoryIdentifier isEqualToString:@"com.npk.mx.report"]) {
//        [self handleResponse:response];
    }
    completionHandler();
}

@end
