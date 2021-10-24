//
//  NPKImageProcessTestVC.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/21.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKImageProcessTestVC.h"
#import <Masonry/Masonry.h>
#import <NicePerformanceKit/NPKImageCompressTool.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@interface NPKImageProcessTestVC ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *showOriginImgBtn;
@property (nonatomic, strong) UIButton *showResizedImgWithBadCase;
@property (nonatomic, strong) UIButton *showResizedImgBtn;

@end

@implementation NPKImageProcessTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView {
    self.navigationItem.title = @"Image Process Test";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.showOriginImgBtn];
    [self.view addSubview:self.showResizedImgWithBadCase];
    [self.view addSubview:self.showResizedImgBtn];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 400));
    }];
    
    [self.showOriginImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.showResizedImgWithBadCase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showOriginImgBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.showResizedImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showResizedImgWithBadCase.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
}

- (void)showOriginImgBtnTapped {
    self.imgView.image = [UIImage imageNamed:@"IMG_6340.png"];
}

- (void)showResizedImgWithBadCaseTapped {
    NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340" withExtension:@"png"];
    UIImage *resizedImage = [NPKBadPerfCase resizeImageWithImageURL:imgURL expectSize:CGSizeMake(600.f, 800.f)];
    self.imgView.image = resizedImage;
}

- (void)showResizedImgBtnTapped {
    NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340" withExtension:@"png"];
    UIImage *resizedImage = [NPKImageCompressTool resizeImageWithImageURL:imgURL expectSize:CGSizeMake(600.f, 800.f)];
    self.imgView.image = resizedImage;
}

#pragma mark -- Getter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UIButton *)showOriginImgBtn {
    if (!_showOriginImgBtn) {
        _showOriginImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showOriginImgBtn setBackgroundColor:[UIColor systemRedColor]];
        [_showOriginImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showOriginImgBtn setTitle:@"Show Origin Image" forState:UIControlStateNormal];
        _showOriginImgBtn.layer.cornerRadius = 4.f;
        _showOriginImgBtn.clipsToBounds = YES;
        [_showOriginImgBtn addTarget:self action:@selector(showOriginImgBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showOriginImgBtn;
}

- (UIButton *)showResizedImgWithBadCase {
    if (!_showResizedImgWithBadCase) {
        _showResizedImgWithBadCase = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showResizedImgWithBadCase setBackgroundColor:[UIColor systemRedColor]];
        [_showResizedImgWithBadCase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showResizedImgWithBadCase setTitle:@"Resized Image by ImageContext" forState:UIControlStateNormal];
        _showResizedImgWithBadCase.layer.cornerRadius = 4.f;
        _showResizedImgWithBadCase.clipsToBounds = YES;
        [_showResizedImgWithBadCase addTarget:self action:@selector(showResizedImgWithBadCaseTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showResizedImgWithBadCase;
}

- (UIButton *)showResizedImgBtn {
    if (!_showResizedImgBtn) {
        _showResizedImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showResizedImgBtn setBackgroundColor:[UIColor systemGreenColor]];
        [_showResizedImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showResizedImgBtn setTitle:@"Resized Image by ImageIO." forState:UIControlStateNormal];
        _showResizedImgBtn.layer.cornerRadius = 4.f;
        _showResizedImgBtn.clipsToBounds = YES;
        [_showResizedImgBtn addTarget:self action:@selector(showResizedImgBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showResizedImgBtn;
}

@end
