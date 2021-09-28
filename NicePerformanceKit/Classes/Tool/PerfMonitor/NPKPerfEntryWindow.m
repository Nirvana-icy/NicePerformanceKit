//
//  NPKPerfEntryWindow.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/9/28.
//

#import "NPKPerfEntryWindow.h"
#import "NPKBaseDefine.h"

static CGFloat const kDefaultEntryWidth = 120;
static CGFloat const kDefaultEntryHeight = 40;

#define   kDefaultEntryStartPosition     CGPointMake(NPKScreenWidth - kDefaultEntryWidth - 10, 50)

@interface NPKPerfEntryWindow ()

@property (nonatomic, strong) UILabel *perfInfoLabel;

@end

@implementation NPKPerfEntryWindow

- (instancetype)initWithStartPosition:(CGPoint)position {
    CGFloat startX = position.x;
    CGFloat startY = position.y;
    CGPoint defaultEntryPostion = kDefaultEntryStartPosition;
    if (startX <= 0 || startX > (NPKScreenWidth - kDefaultEntryWidth)) {
        startX = defaultEntryPostion.x;
    }
    if (startY <= 0 || startY > (NPKScreenHeight - kDefaultEntryHeight)) {
        startY = defaultEntryPostion.y;
    }
    self = [super init];
    if (self) {
        self.frame = CGRectMake(startX, startY, kDefaultEntryWidth, kDefaultEntryHeight);
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

- (void)pan:(UIPanGestureRecognizer *)pan {
    
}

#pragma mark - Getter

- (UILabel *)perfInfoLabel {
    if (!_perfInfoLabel) {
        _perfInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, kDefaultEntryWidth - 5, kDefaultEntryHeight)];
        _perfInfoLabel.backgroundColor = [UIColor grayColor];
        _perfInfoLabel.textColor = [UIColor whiteColor];
        _perfInfoLabel.font = [UIFont systemFontOfSize:11.f];
        _perfInfoLabel.numberOfLines = 2;
    }
    return _perfInfoLabel;
}

@end
