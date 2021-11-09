//
//  NPKImageProcessTestVC.m
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/10/21.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

#import "NPKImageProcessTestVC.h"
#import <Masonry/Masonry.h>
#import <NicePerformanceKit/NPKSignpostLog.h>
#import <NicePerformanceKit/NPKImageCompressTool.h>
#import <NicePerformanceKit/NPKBadPerfCase.h>

@interface NPKImageProcessTestVC ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *loadImgTestBtn;
@property (nonatomic, strong) UIButton *showOriginImgWithFileBtn;
@property (nonatomic, strong) UIButton *showOriginImgWithNameBtn;
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
    [self.view addSubview:self.loadImgTestBtn];
    [self.view addSubview:self.showOriginImgWithFileBtn];
    [self.view addSubview:self.showOriginImgWithNameBtn];
    [self.view addSubview:self.showResizedImgWithBadCase];
    [self.view addSubview:self.showResizedImgBtn];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom).offset(15);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(240, 320));
    }];
    
    [self.loadImgTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.showOriginImgWithFileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loadImgTestBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.showOriginImgWithNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showOriginImgWithFileBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.showResizedImgWithBadCase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showOriginImgWithNameBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
    
    [self.showResizedImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showResizedImgWithBadCase.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 50));
    }];
}

- (void)uiImageInitTestBtnTapped {
    // @0.0s init image with content of file in bundle.
    npk_signpost_emit_event("Image_Process_Test", "uiImageInitTestBtnTapped");
    os_signpost_id_t spid = _npk_time_profile_spid_generate();
    NSBundle *imageBundle = [NSBundle mainBundle];
    NSString *imagePath = [imageBundle pathForResource:@"IMG_6340" ofType:@"png"];
    npk_time_profile_begin("init_image_with_content_of_file_in_bundle", spid);
    self.imgView.image = [UIImage imageWithContentsOfFile:imagePath];
    npk_time_profile_end("init_image_with_content_of_file_in_bundle", spid);
    
    // @0.2s set image to nil
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        npk_signpost_emit_event("Image_Process_Test", "@0.2s set image to nil");
        self.imgView.image = nil;
    });
    
    // @0.5s init image with name in bundle
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        os_signpost_id_t spid = _npk_time_profile_spid_generate();
        npk_time_profile_begin("init_image_with_name_in_bundle", spid);
        self.imgView.image = [UIImage imageNamed:@"IMG_6340.png"];
        npk_time_profile_end("init_image_with_name_in_bundle", spid);
    });
    
    // @0.7s set image to nil
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        npk_signpost_emit_event("Image_Process_Test", "@0.7s set image to nil");
        self.imgView.image = nil;
    });
    
    // @1.0s init image with name in assets
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        os_signpost_id_t spid = _npk_time_profile_spid_generate();
        npk_time_profile_begin("init_image_with_name_in_assets", spid);
        self.imgView.image = [UIImage imageNamed:@"IMG_6340_in_Assets.png"];
        npk_time_profile_end("init_image_with_name_in_assets", spid);
    });
}

- (void)showOriginImgBtnTapped {
    self.imgView.image = [UIImage imageNamed:@"IMG_6340.png"];
}

- (void)showOriginImgWithContentOfFileBtnTapped {
    NSBundle *imageBundle = [NSBundle mainBundle];
    NSString *imagePath = [imageBundle pathForResource:@"IMG_6340" ofType:@"png"];
    self.imgView.image = [UIImage imageWithContentsOfFile:imagePath];
}

- (void)showResizedImgWithBadCaseTapped {
    NSURL *imgURL = [[NSBundle mainBundle] URLForResource:@"IMG_6340" withExtension:@"png"];
    UIImage *resizedImage = [NPKBadPerfCase resizeImageWithContentOfFile:imgURL.path expectSize:CGSizeMake(600.f, 800.f)];
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

- (UIButton *)loadImgTestBtn {
    if (!_loadImgTestBtn) {
        _loadImgTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadImgTestBtn setBackgroundColor:[UIColor systemBlueColor]];
        [_loadImgTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loadImgTestBtn setTitle:@"Init UIImage Perf Test" forState:UIControlStateNormal];
        _loadImgTestBtn.layer.cornerRadius = 4.f;
        _loadImgTestBtn.clipsToBounds = YES;
        [_loadImgTestBtn addTarget:self action:@selector(uiImageInitTestBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadImgTestBtn;
}

- (UIButton *)showOriginImgWithNameBtn {
    if (!_showOriginImgWithNameBtn) {
        _showOriginImgWithNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showOriginImgWithNameBtn setBackgroundColor:[UIColor systemRedColor]];
        [_showOriginImgWithNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showOriginImgWithNameBtn setTitle:@"Show Origin Image With Name" forState:UIControlStateNormal];
        _showOriginImgWithNameBtn.layer.cornerRadius = 4.f;
        _showOriginImgWithNameBtn.clipsToBounds = YES;
        [_showOriginImgWithNameBtn addTarget:self action:@selector(showOriginImgBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showOriginImgWithNameBtn;
}

- (UIButton *)showOriginImgWithFileBtn {
    if (!_showOriginImgWithFileBtn) {
        _showOriginImgWithFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showOriginImgWithFileBtn setBackgroundColor:[UIColor systemRedColor]];
        [_showOriginImgWithFileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showOriginImgWithFileBtn setTitle:@"Show Origin Image With File" forState:UIControlStateNormal];
        _showOriginImgWithFileBtn.layer.cornerRadius = 4.f;
        _showOriginImgWithFileBtn.clipsToBounds = YES;
        [_showOriginImgWithFileBtn addTarget:self action:@selector(showOriginImgWithContentOfFileBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showOriginImgWithFileBtn;
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
