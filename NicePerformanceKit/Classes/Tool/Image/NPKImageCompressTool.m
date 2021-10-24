//
//  NPKImageCompressTool.m
//  AFDownloadRequestOperation
//
//  Created by JinglongBi on 2021/9/8.
//

#import "NPKImageCompressTool.h"
#import <ImageIO/ImageIO.h>
#import <CoreServices/UTCoreTypes.h>

@implementation NPKImageCompressTool

+ (nullable UIImage *)resizeImageWithImageURL:(NSURL *)imageURL
                                   expectSize:(CGSize)expectSize {
    if (nil == imageURL || expectSize.width <= 0 || expectSize.height <= 0) {
        return nil;
    }
    
    CGImageSourceRef imgSrcRef = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, nil);
    if (nil == imgSrcRef) {
        return nil;
    }
    
    CFDictionaryRef resizedImgOptionRef = (__bridge CFDictionaryRef)@{
        (id)kCGImageSourceThumbnailMaxPixelSize : @(MAX(expectSize.width, expectSize.height)),
        (id)kCGImageSourceCreateThumbnailWithTransform : @(YES),
        (id)kCGImageSourceCreateThumbnailFromImageAlways : @(YES)
    };
    
    CGImageRef resizedImgRef = CGImageSourceCreateThumbnailAtIndex(imgSrcRef, 0, resizedImgOptionRef);
    UIImage *resizedImg = [[UIImage alloc] initWithCGImage:resizedImgRef];
    
    CFRelease(imgSrcRef);
    CFRelease(resizedImgRef);
    
    return resizedImg;
}

+ (BOOL)compresseImage:(UIImage *)image
    withOutputImageURL:(NSURL *)outputImageURL
            expectSize:(CGSize)expectSize
               quality:(CGFloat)quality {
    
    BOOL bResult = NO;

    if (!image || quality < 0 || quality > 1.0) {
        return bResult;
    }

    NSData *jpgImageData = UIImageJPEGRepresentation(image, quality);

    if (image.size.width > expectSize.width ) {
        CGImageSourceRef jpgImageSrcRef = CGImageSourceCreateWithData((__bridge CFTypeRef)(jpgImageData), NULL);
        CFDictionaryRef resizedImgOptionRef = (__bridge CFDictionaryRef) @{
            (id)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(YES),
            (id)kCGImageSourceThumbnailMaxPixelSize : @(MAX(expectSize.width, expectSize.height)),
//            (id)kCGImageSourceShouldCache : @(YES), // Specifies whether the image should be cached in a decoded form.
            (id)kCGImageSourceCreateThumbnailWithTransform: @(YES)
        };

        CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(jpgImageSrcRef, 0, resizedImgOptionRef);
        CFRelease(jpgImageSrcRef);
        
        NSDictionary *options = @{(id)kCGImageDestinationLossyCompressionQuality : @(quality)};
        CGImageDestinationRef destImageRef = CGImageDestinationCreateWithURL((__bridge CFURLRef)outputImageURL, kUTTypeJPEG, 1, nil);

        CGImageDestinationAddImage(destImageRef, imageRef, (CFDictionaryRef)options);
        bResult = CGImageDestinationFinalize(destImageRef);
        
        if (imageRef != nil) {
            CFRelease(imageRef);
        }
        CFRelease(destImageRef);
    } else {
        bResult = [jpgImageData writeToFile:outputImageURL.path atomically:YES];
    }
    
    return bResult;
}

@end
