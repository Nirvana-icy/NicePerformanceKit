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

@interface NPKitDisplayWindow () <NPKitDisplayWindowDelegate>

@property (nonatomic, strong) UILabel *perfInfoLabel;
@property (nonatomic, strong) UILabel *messageInfoLabel;

@property (nonatomic, strong) NSMutableArray *npkToastHandlerArr;

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
        
        [self bind:self];
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)bind:(id<NPKitDisplayWindowDelegate>)obj {
    if (![self.npkToastHandlerArr containsObject:obj] && obj) {
        [self.npkToastHandlerArr addObject:obj];
    }
}

- (void)unbind:(id<NPKitDisplayWindowDelegate>)obj {
    if ([self.npkToastHandlerArr containsObject:obj]) {
        [self.npkToastHandlerArr removeObject:obj];
    }
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

- (void)showMessage:(NSString *)message {
    [self message:message withMsgLevel:NPKitMsgLevelDefault];
}

- (void)message:(NSString *)message withMsgLevel:(NPKitMsgLevel)npkMsgLevel {
    if ([NSThread isMainThread]) {
        [self _showMessage:message withMsgLevel:npkMsgLevel];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _showMessage:message withMsgLevel:npkMsgLevel];
        });
    }
}

- (void)_showMessage:(NSString *)message withMsgLevel:(NPKitMsgLevel)npkMsgLevel {
    [self.npkToastHandlerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([(id<NPKitDisplayWindowDelegate>)obj respondsToSelector:@selector(handleNPKitDisplayMessage:withMsgLevel:)]) {
            [(id<NPKitDisplayWindowDelegate>)obj handleNPKitDisplayMessage:message withMsgLevel:npkMsgLevel];
        }
    }];
}

// todo  移动控件位置
//- (void)pan:(UIPanGestureRecognizer *)pan {
//
//}

#pragma mark - NPKitDisplayWindowDelegate

- (void)handleNPKitDisplayMessage:(NSString *)message withMsgLevel:(NPKitMsgLevel)npkMsgLevel {
    CGPoint defaultEntryPostion = kDefaultEntryStartPosition;
    self.frame = CGRectMake(defaultEntryPostion.x, defaultEntryPostion.y, kDefaultEntryWidth, 2 * kDefaultEntryHeight);
    self.messageInfoLabel.text = message;
    self.messageInfoLabel.hidden = NO;
    // 默认展示5秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.messageInfoLabel.text = nil;
        self.messageInfoLabel.hidden = YES;
        self.frame = CGRectMake(defaultEntryPostion.x, defaultEntryPostion.y, kDefaultEntryWidth, kDefaultEntryHeight);
    });
}

#pragma mark - Getter

- (NSMutableArray *)npkToastHandlerArr {
    if (!_npkToastHandlerArr) {
        _npkToastHandlerArr = [NSMutableArray array];
    }
    return _npkToastHandlerArr;
}

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

- (UILabel *)messageInfoLabel {
    if (!_messageInfoLabel) {
        _messageInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDefaultEntryHeight, kDefaultEntryWidth, kDefaultEntryHeight)];
        _messageInfoLabel.textAlignment = NSTextAlignmentCenter;
        _messageInfoLabel.backgroundColor = [UIColor grayColor];
        _messageInfoLabel.textColor = [UIColor redColor];
        _messageInfoLabel.font = [UIFont systemFontOfSize:11.f];
        _messageInfoLabel.adjustsFontSizeToFitWidth = YES;
        _messageInfoLabel.minimumScaleFactor = 0.6f;
        [self.rootViewController.view addSubview:_messageInfoLabel];
    }
    return _messageInfoLabel;
}

@end
