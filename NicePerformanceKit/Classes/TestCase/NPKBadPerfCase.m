//
//  NPKBadPerfCase.m
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/7/29.
//

#import "NPKBadPerfCase.h"
#import "NPKSignpostLog.h"

@implementation NPKBadPerfCase

+ (void)generateMainThreadLag {
    dispatch_async(dispatch_get_main_queue(), ^{
        NPKLog(@"Test Foreground Main Thread Lag...Lag with 5s...Begin.");
        os_signpost_id_t spid = _npk_time_profile_spid_generate();
        npk_time_profile_begin("generateMainThreadLag", spid);
        NSDate *lastDate = [NSDate date];
        while (1) {
            NSDate *currentDate = [NSDate date];
            if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > 5.) {
                break;
            }
        }
        npk_time_profile_end("generateMainThreadLag", spid);
        NPKLog(@"Test Foreground Main Thread Lag...Lag with 5s...End.");
    });
}

+ (void)generateLagWithTime:(NSTimeInterval)time {
    NSDate *lastDate = [NSDate date];
    while (1) {
        NSDate *currentDate = [NSDate date];
        if (([currentDate timeIntervalSince1970] - [lastDate timeIntervalSince1970]) > time) {
            break;
        }
    }
}

+ (nullable UIImage *)resizeImageWithContentOfFile:(NSString *)contentOfFile
                                        expectSize:(CGSize)expectSize {
    if (contentOfFile.length <= 0 || expectSize.width <= 0 || expectSize.height <= 0) {
        return nil;
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:contentOfFile];
    UIImage *resultImage = nil;
    
    UIGraphicsBeginImageContext(expectSize);
    [image drawInRect:CGRectMake(0, 0, expectSize.width, expectSize.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
