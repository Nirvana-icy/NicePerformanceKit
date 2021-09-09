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

+ (BOOL)saveCompressedImage:(UIImage *)image
             outputImageURL:(NSURL *)outputImageURL
             withExpectSize:(CGSize)expectSize
                    quality:(CGFloat)quality {
    
    BOOL bResult = NO;
    
    if (!image || quality < 0 || quality > 1.0) {
        return bResult;
    }
    
    NSData *jpgImageData = UIImageJPEGRepresentation(image, quality);
    
    if (image.size.width > expectSize.width ) {
        CGImageSourceRef jpgImageSrcRef = CGImageSourceCreateWithData((__bridge CFTypeRef)(jpgImageData), NULL);
        CFDictionaryRef dicOptionsRef = (__bridge CFDictionaryRef) @{(id)kCGImageSourceCreateThumbnailFromImageIfAbsent : @(YES),
                                                                     (id)kCGImageSourceThumbnailMaxPixelSize : @(MAX(expectSize.width, expectSize.height)),
                                                                     (id)kCGImageSourceShouldCache : @(YES),
                                                                     (id)kCGImageSourceCreateThumbnailWithTransform: @(YES)
        };
        
        CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(jpgImageSrcRef, 0, dicOptionsRef);
        NSDictionary *options = @{(id)kCGImageDestinationLossyCompressionQuality : @(quality)};
        CGImageDestinationRef destImageRef = CGImageDestinationCreateWithURL((__bridge CFURLRef)outputImageURL, kUTTypeJPEG, 1, nil);
        
        CGImageDestinationAddImage(destImageRef, imageRef, (CFDictionaryRef)options);
        bResult = CGImageDestinationFinalize(destImageRef);
        CFRelease(destImageRef);
        
        if (imageRef != nil) {
            CFRelease(imageRef);
        }
        CFRelease(jpgImageSrcRef);
    } else {
        bResult = [jpgImageData writeToFile:outputImageURL.path atomically:YES];
    }
    
    return bResult;
}

@end
