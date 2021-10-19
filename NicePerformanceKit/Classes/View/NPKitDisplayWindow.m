//
//  NPKitDisplayWindow.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/28.
//

#import "NPKitDisplayWindow.h"
#import "NPKBaseDefine.h"

static CGFloat const kDefaultEntryWidth = 190;
static CGFloat const kDefaultEntryHeight = 18;

#define   kDefaultEntryStartPosition     CGPointMake(NPKScreenWidth - kDefaultEntryWidth - 10, 36)

@interface NPKitDisplayWindow ()

@property (nonatomic, strong) UILabel *perfInfoLabel;
@property (nonatomic, strong) UILabel *toastInfoLabel;

@end

@implementation NPKitDisplayWindow

+ (instancetype)sharedInstance {
    static NPKitDisplayWindow *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NPKitDisplayWindow alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        CGPoint defaultEntryPostion = kDefaultEntryStartPosition;
        self.frame = CGRectMake(defaultEntryPostion.x, defaultEntryPostion.y, kDefaultEntryWidth, kDefaultEntryHeight);
        self.backgroundColor = [UIColor grayColor];
        self.windowLevel = UIWindowLevelStatusBar + 10.f;
        self.rootViewController = [UIViewController new];
        [self.rootViewController.view addSubview:self.perfInfoLabel];
        self.hidden = NO;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)updatePerfInfo:(NSString *)perfInfo {
    if ([NSThread isMainThread]) {
        self.perfInfoLabel.text = perfInfo;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.perfInfoLabel.text = perfInfo;
        });
    }
}

- (void)showToast:(NSString *)toastInfo {
    [self showToast:toastInfo withDuration:5];
}

- (void)showToast:(NSString *)toastInfo withDuration:(NSTimeInterval)duration {
    if ([NSThread isMainThread]) {
        [self _showToast:toastInfo withDuration:duration];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _showToast:toastInfo withDuration:duration];
        });
    }
}

- (void)_showToast:(NSString *)toastInfo withDuration:(NSTimeInterval)duration {
    CGPoint defaultEntryPostion = kDefaultEntryStartPosition;
    self.frame = CGRectMake(defaultEntryPostion.x, defaultEntryPostion.y, kDefaultEntryWidth, 2 * kDefaultEntryHeight);
    self.toastInfoLabel.text = toastInfo;
    self.toastInfoLabel.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toastInfoLabel.text = nil;
        self.toastInfoLabel.hidden = YES;
        self.frame = CGRectMake(defaultEntryPostion.x, defaultEntryPostion.y, kDefaultEntryWidth, kDefaultEntryHeight);
    });
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
}

#pragma mark - Getter

- (UILabel *)perfInfoLabel {
    if (!_perfInfoLabel) {
        _perfInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDefaultEntryWidth, kDefaultEntryHeight)];
        _perfInfoLabel.textAlignment = NSTextAlignmentCenter;
        _perfInfoLabel.backgroundColor = [UIColor grayColor];
        _perfInfoLabel.textColor = [UIColor whiteColor];
        _perfInfoLabel.font = [UIFont systemFontOfSize:11.f];
        _perfInfoLabel.adjustsFontSizeToFitWidth = YES;
        _perfInfoLabel.minimumScaleFactor = 0.6f;
    }
    return _perfInfoLabel;
}

- (UILabel *)toastInfoLabel {
    if (!_toastInfoLabel) {
        _toastInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDefaultEntryHeight, kDefaultEntryWidth, kDefaultEntryHeight)];
        _toastInfoLabel.textAlignment = NSTextAlignmentCenter;
        _toastInfoLabel.backgroundColor = [UIColor grayColor];
        _toastInfoLabel.textColor = [UIColor redColor];
        _toastInfoLabel.font = [UIFont systemFontOfSize:11.f];
        _toastInfoLabel.adjustsFontSizeToFitWidth = YES;
        _toastInfoLabel.minimumScaleFactor = 0.6f;
        [self.rootViewController.view addSubview:_toastInfoLabel];
    }
    return _toastInfoLabel;
}

@end
