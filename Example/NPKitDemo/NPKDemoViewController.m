//
//  NPKDemoViewController.m
//  NPKitDemo
//
//  Created by jinglong.bi@me.com on 09/09/2021.
//  Copyright (c) 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKDemoViewController.h"
#import <objc/runtime.h>
#import <MetricKit/MetricKit.h>
#import <Masonry/Masonry.h>
#import <NicePerformanceKit/NPKBaseDefine.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>
#import <NicePerformanceKit/NPKPerfTestCase+GCD.h>
#import <NicePerformanceKit/NPKSysResCostInfo.h>
#import <NicePerformanceKit/NPKLagMonitor.h>
#import <NicePerformanceKit/NPKitDisplayWindow.h>
#import "SlowLargeTableViewController.h"
#import "NPKDemoViewController+Test.h"

@interface NPKDemoViewController ()

<
NPKLagMonitorDelegate
>

@property (nonatomic, strong) UIButton *triggerLagBtn;
@property (nonatomic, strong) UIButton *asyncToConcurrentQueueBtn;
@property (nonatomic, strong) UIButton *asynToQueuePoolTestBtn;
@property (nonatomic, strong) UIButton *costCPUAlotBtn;
@property (nonatomic, strong) UIButton *slowLargeTableBtn;
@property (nonatomic, strong) UIButton *makeCrashBtn;
@property (nonatomic, strong) UIButton *mockMetricKitReportBtn;

@end

@implementation NPKDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupView];
    [NPKLagMonitor sharedInstance].delegatet = self;
}

#pragma mark -- NPKLagMonitorDelegate

- (void)lagDetectWithStackInfo:(NSString *)stackInfo
                      lagCount:(NSUInteger)lagCount {
    [[NPKitDisplayWindow sharedInstance] showToast:[NSString stringWithFormat:@"ANR: %lu", (unsigned long)lagCount]];
}

#pragma mark -- Action

- (void)triggerLagBtnTapped {
    [NPKBadPerfCase generateMainThreadLag];
}

- (void)asyncToConcurrentQueueBtnTapped {
    [NPKPerfTestCase gcdDispatchAsyncToConcurrentQueue];
}

- (void)asyncToQueuePoolBtnTapped {
    [NPKPerfTestCase gcdDispatchAsyncToQueuePool];
}

- (void)costCPUALotBtnTapped {
    [NPKPerfTestCase costCPUALot];
}

- (void)slowLargeTableBtnTapped {
    [self.navigationController pushViewController:[SlowLargeTableViewController new]
                                         animated:YES];
}

- (void)makeCrashBtnTapped {
    volatile char *ptr = NULL;
    (void)*ptr;
}

- (void)mockMetricKitReportBtnTapped {
    [self sendMockMetricKitReport];
}

#pragma mark -- UI

- (void)setupView {
    [self.view addSubview:self.triggerLagBtn];
    [self.view addSubview:self.asyncToConcurrentQueueBtn];
    [self.view addSubview:self.asynToQueuePoolTestBtn];
    [self.view addSubview:self.costCPUAlotBtn];
    [self.view addSubview:self.slowLargeTableBtn];
    [self.view addSubview:self.makeCrashBtn];
    [self.view addSubview:self.mockMetricKitReportBtn];

    [self.triggerLagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];

    [self.asyncToConcurrentQueueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.triggerLagBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.asynToQueuePoolTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.asyncToConcurrentQueueBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.costCPUAlotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.asynToQueuePoolTestBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.slowLargeTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.costCPUAlotBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.makeCrashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slowLargeTableBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.mockMetricKitReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.makeCrashBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
}

#pragma mark -- Getter

- (UIButton *)triggerLagBtn {
    if (!_triggerLagBtn) {
        _triggerLagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_triggerLagBtn setBackgroundColor:[UIColor systemGreenColor]];
        [_triggerLagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_triggerLagBtn setTitle:@"Block Main Thread 5s" forState:UIControlStateNormal];
        _triggerLagBtn.layer.cornerRadius = 4.f;
        _triggerLagBtn.clipsToBounds = YES;
        [_triggerLagBtn addTarget:self action:@selector(triggerLagBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _triggerLagBtn;
}

- (UIButton *)asyncToConcurrentQueueBtn {
    if (!_asyncToConcurrentQueueBtn) {
        _asyncToConcurrentQueueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_asyncToConcurrentQueueBtn setBackgroundColor:[UIColor redColor]];
        [_asyncToConcurrentQueueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_asyncToConcurrentQueueBtn setTitle:@"Threads Storm Test" forState:UIControlStateNormal];
        _asyncToConcurrentQueueBtn.layer.cornerRadius = 4.f;
        _asyncToConcurrentQueueBtn.clipsToBounds = YES;
        [_asyncToConcurrentQueueBtn addTarget:self action:@selector(asyncToConcurrentQueueBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _asyncToConcurrentQueueBtn;
}

- (UIButton *)asynToQueuePoolTestBtn {
    if (!_asynToQueuePoolTestBtn) {
        _asynToQueuePoolTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_asynToQueuePoolTestBtn setBackgroundColor:[UIColor systemGreenColor]];
        [_asynToQueuePoolTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_asynToQueuePoolTestBtn setTitle:@"Async To Queue Pool" forState:UIControlStateNormal];
        _asynToQueuePoolTestBtn.layer.cornerRadius = 4.f;
        _asynToQueuePoolTestBtn.clipsToBounds = YES;
        [_asynToQueuePoolTestBtn addTarget:self action:@selector(asyncToQueuePoolBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _asynToQueuePoolTestBtn;
}

- (UIButton *)costCPUAlotBtn {
    if (!_costCPUAlotBtn) {
        _costCPUAlotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_costCPUAlotBtn setBackgroundColor:[UIColor systemGreenColor]];
        [_costCPUAlotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_costCPUAlotBtn setTitle:@"Cost CPU A Lot" forState:UIControlStateNormal];
        _costCPUAlotBtn.layer.cornerRadius = 4.f;
        _costCPUAlotBtn.clipsToBounds = YES;
        [_costCPUAlotBtn addTarget:self action:@selector(costCPUALotBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _costCPUAlotBtn;
}

- (UIButton *)slowLargeTableBtn {
    if (!_slowLargeTableBtn) {
        _slowLargeTableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_slowLargeTableBtn setBackgroundColor:[UIColor systemGreenColor]];
        [_slowLargeTableBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_slowLargeTableBtn setTitle:@"Slow Large Table" forState:UIControlStateNormal];
        _slowLargeTableBtn.layer.cornerRadius = 4.f;
        _slowLargeTableBtn.clipsToBounds = YES;
        [_slowLargeTableBtn addTarget:self action:@selector(slowLargeTableBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slowLargeTableBtn;
}

- (UIButton *)makeCrashBtn {
    if (!_makeCrashBtn) {
        _makeCrashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_makeCrashBtn setBackgroundColor:[UIColor redColor]];
        [_makeCrashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_makeCrashBtn setTitle:@"Tap To Crash" forState:UIControlStateNormal];
        _makeCrashBtn.layer.cornerRadius = 4.f;
        _makeCrashBtn.clipsToBounds = YES;
        [_makeCrashBtn addTarget:self action:@selector(makeCrashBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeCrashBtn;
}

- (UIButton *)mockMetricKitReportBtn {
    if (!_mockMetricKitReportBtn) {
        _mockMetricKitReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mockMetricKitReportBtn setBackgroundColor:[UIColor blueColor]];
        [_mockMetricKitReportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mockMetricKitReportBtn setTitle:@"Mock MetricKit Report" forState:UIControlStateNormal];
        _mockMetricKitReportBtn.layer.cornerRadius = 4.f;
        _mockMetricKitReportBtn.clipsToBounds = YES;
        [_mockMetricKitReportBtn addTarget:self action:@selector(mockMetricKitReportBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mockMetricKitReportBtn;
}

@end
