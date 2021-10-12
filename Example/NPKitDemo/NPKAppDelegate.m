//
//  NPKAppDelegate.m
//  NPKitDemo
//
//  Created by jinglong.bi@me.com on 09/09/2021.
//  Copyright (c) 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKAppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "NPKLagMonitor.h"
#import "NPKPerfMonitor.h"
#import "NPKMetricKitManager.h"

@interface NPKAppDelegate ()

<
UNUserNotificationCenterDelegate,
NPKMetricKitManagerDelegate
>

@end

@implementation NPKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NPKLagMonitor sharedInstance] start];
    [[NPKPerfMonitor sharedInstance] start];
    
    if (@available(iOS 14, *)) {
        [[NPKMetricKitManager sharedInstance] bind:self];
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
}

#pragma mark - NPKMetricKitManagerDelegate

- (void)handleNPKMetricPayloads {
    
}

- (void)handleNPKDiagnosticPayloads:(NSArray<NPKDiagnosticPayloadModel *> *)npkDiagnosticPayloads {
    // 线下：本地通知/UI展示
    NSString *subTitle = [NSString stringWithFormat:@"Payload Count: %lu", (unsigned long)npkDiagnosticPayloads.count];
    [self sendNPKLocalNotificationWithSubTitle:subTitle
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
