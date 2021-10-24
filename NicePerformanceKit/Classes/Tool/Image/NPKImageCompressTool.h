//
//  NPKImageCompressTool.h
//  AFDownloadRequestOperation
//
//  Created by JinglongBi on 2021/9/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPKImageCompressTool : NSObject

+ (nullable UIImage *)resizeImageWithImageURL:(NSURL *)imageURL
                                   expectSize:(CGSize)expectSize;

/// 压缩图片并保存在指定路径，成功返回 YES。
/// @param image 待压缩的UIImage
/// @param outputImageURL 保存压缩后图片的磁盘地址
/// @param expectSize 压缩后图片的尺寸
/// @param quality 压缩质量
+ (BOOL)compresseImage:(UIImage *)image
    withOutputImageURL:(NSURL *)outputImageURL
            expectSize:(CGSize)expectSize
               quality:(CGFloat)quality;

@end

NS_ASSUME_NONNULL_END
