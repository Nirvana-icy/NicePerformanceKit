//
//  NPKBadPerfCase.h
//  NicePerformanceKit
//
//  Created by JinglongBi on 2021/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKBadPerfCase : NSObject

+ (void)generateMainThreadLag;
+ (void)generateLagWithTime:(NSTimeInterval)time;

+ (nullable UIImage *)resizeImageWithContentOfFile:(NSString *)contentOfFile
                                        expectSize:(CGSize)expectSize;

@end

NS_ASSUME_NONNULL_END
