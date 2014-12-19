/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

#define CROP_SIZE_TAG "cropSize"
#define IMAGE_IS_LAZY_TAG "imageIsLazyTag"


@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)success failure:(SDWebImageFailureBlock)failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.contentMode = UIViewContentModeScaleAspectFill;
    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

-(void) setImageUrl:(NSURL *)imageUrl resizeWidth:(CGSize)size placeholderImage:(UIImage *)placeholder
{
    if (placeholder) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.image = placeholder;
    }
    [self setImageUrl:imageUrl resizeWidth:size];
}

-(void) setImageUrl:(NSURL *)imageUrl resizeWidth:(CGSize)size
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    objc_setAssociatedObject(self, CROP_SIZE_TAG,[NSValue valueWithCGSize:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, IMAGE_IS_LAZY_TAG,[NSNumber numberWithBool:TRUE], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (imageUrl)
    {
        [manager downloadWithURL:imageUrl delegate:self];
    }
}

-(UIImage *) cropImageIfNeed:(UIImage *)source
{
    if (!self)
        return nil;
     NSValue * cropSizeValue = objc_getAssociatedObject(self, CROP_SIZE_TAG);
    CGSize cropSize = [cropSizeValue CGSizeValue];
    if (source.size.width<= cropSize.width ||
        source.size.height <= cropSize.height)
        return source;
    float aspect = source.size.width/source.size.height;
    float targetasp = cropSize.width/cropSize.height;
    float targetWidth = 0;
    float targetHeight = 0;
    if (targetasp > aspect)
    {
        targetHeight = cropSize.height;
        targetWidth = cropSize.height *aspect;
    } else
    {
        targetWidth = cropSize.width;
        targetHeight = cropSize.width /aspect;
    }
    CGSize itemSize = CGSizeMake((int)targetWidth, (int)targetHeight);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [source drawInRect:imageRect];
    UIImage* target =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return target;
}


- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    NSNumber * isLazyInt = objc_getAssociatedObject(self, IMAGE_IS_LAZY_TAG);
    
    if (self.image != image) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    self.alpha = 0.4;
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1.0f;
    } completion:nil];
    
    if ([isLazyInt boolValue])
    {
        UIImage *cropImage = image;
        
        [self setImage:cropImage];
        [self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:FALSE];
    }
    else
    {
        self.image = image;
        [self setNeedsLayout];
    }

}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    NSNumber * isLazyInt = objc_getAssociatedObject(self, IMAGE_IS_LAZY_TAG);
    
    //图片从网站下载成功则改变其显示模式
    if (self.image != image) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if ([isLazyInt boolValue])
    {
        UIImage *cropImage = image;
        
        [self setImage:cropImage];
        [self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:FALSE];
    }
    else
    {
        self.image = image;
        [self setNeedsLayout];
    }
}

@end
