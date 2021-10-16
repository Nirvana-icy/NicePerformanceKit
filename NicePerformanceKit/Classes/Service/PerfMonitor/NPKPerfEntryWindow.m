//
//  NPKPerfEntryWindow.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/28.
//

#import "NPKPerfEntryWindow.h"
#import "NPKBaseDefine.h"

static CGFloat const kDefaultEntryWidth = 190;
static CGFloat const kDefaultEntryHeight = 18;

#define   kDefaultEntryStartPosition     CGPointMake(NPKScreenWidth - kDefaultEntryWidth - 10, 36)

@interface NPKPerfEntryWindow ()

@property (nonatomic, strong) UILabel *perfInfoLabel;

@end

@implementation NPKPerfEntryWindow

+ (instancetype)sharedInstance {
    static NPKPerfEntryWindow *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NPKPerfEntryWindow alloc] init];
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
    self.perfInfoLabel.text = perfInfo;
}

- (void)updatePerfInfo:(NSString *)perfInfo withFlash:(BOOL)isNeedFlash {
    self.perfInfoLabel.text = perfInfo;
    if (isNeedFlash) {
        self.perfInfoLabel.backgroundColor = [UIColor redColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.perfInfoLabel.backgroundColor = [UIColor grayColor];
        });
    }
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

@end
