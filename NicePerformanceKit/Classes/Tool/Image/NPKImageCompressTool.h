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

/// 压缩图片并保存在指定路径，压缩失败返回nil。
/// @param image 待压缩的UIImage
/// @param outputImageURL 保存压缩后图片的磁盘地址
/// @param expectSize 压缩后图片的尺寸
/// @param quality 压缩质量
+ (BOOL)saveCompressedImage:(UIImage *)image
             outputImageURL:(NSURL *)outputImageURL
             withExpectSize:(CGSize)expectSize
                    quality:(CGFloat)quality;

@end

NS_ASSUME_NONNULL_END
