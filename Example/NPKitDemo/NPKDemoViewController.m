//
//  NPKDemoViewController.m
//  NPKitDemo
//
//  Created by jinglong.bi@me.com on 09/09/2021.
//  Copyright (c) 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKDemoViewController.h"
#import <MetricKit/MetricKit.h>
#import <Masonry/Masonry.h>
#import <NicePerformanceKit/NPKBaseDefine.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>
#import <NicePerformanceKit/NPKPerfTestCase+GCD.h>
#import <NicePerformanceKit/NPKSysResCostInfo.h>
#import <NicePerformanceKit/NPKLagMonitor.h>

@interface NPKDemoViewController ()

<
MXMetricManagerSubscriber,
NPKLagMonitorDelegate
>

@property (nonatomic, strong) MXMetricManager *metricManager;
@property (nonatomic, strong) UIButton *triggerLagBtn;
@property (nonatomic, strong) UIButton *triggerGCDTestBtn;
@property (nonatomic, strong) UIButton *costCPUAlotBtn;

@end

@implementation NPKDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupView];
    [NPKLagMonitor sharedInstance].delegatet = self;
    // 1. 获取MetricManager单例
    if (@available(iOS 14.0, *)) {
        self.metricManager = [MXMetricManager sharedManager];
        
        MXDiagnosticPayload *diagnostic = [[MXDiagnosticPayload alloc] init];
        NSArray *array = [diagnostic  crashDiagnostics];
        NPKLog(@"%@", array);
        // 2. 为MetricManager单例添加订阅者
        [self.metricManager addSubscriber:self];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// 4. 移除订阅者
- (void)dealloc {
    [self.metricManager removeSubscriber:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)triggerLagBtnTapped {
    [NPKBadPerfCase generateMainThreadLag];
}

- (void)triggerGCDTestBtnTapped {
    [NPKPerfTestCase gcdDispatchAsyncToConcurrentQueue];
}

- (void)costCPUALotBtnTapped {
    [NPKPerfTestCase costCPUALot];
}

- (void)setupView {
    [self.view addSubview:self.triggerLagBtn];
    [self.view addSubview:self.triggerGCDTestBtn];
    [self.view addSubview:self.costCPUAlotBtn];
    
    [self.triggerLagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.triggerGCDTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.triggerLagBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.costCPUAlotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.triggerGCDTestBtn.mas_bottom).offset(20);
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

- (UIButton *)triggerGCDTestBtn {
    if (!_triggerGCDTestBtn) {
        _triggerGCDTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_triggerGCDTestBtn setBackgroundColor:[UIColor systemGreenColor]];
        [_triggerGCDTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_triggerGCDTestBtn setTitle:@"Thread Count Test" forState:UIControlStateNormal];
        _triggerGCDTestBtn.layer.cornerRadius = 4.f;
        _triggerGCDTestBtn.clipsToBounds = YES;
        [_triggerGCDTestBtn addTarget:self action:@selector(triggerGCDTestBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _triggerGCDTestBtn;
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

@end
