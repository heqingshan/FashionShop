
#import <UIKit/UIKit.h>
#import "FSCache.h"
#import "FSBaseViewController.h"

/*!
 @class FSStartViewController
 @discussion 启动图片类
 @superclass UIViewController
 */
@interface FSStartViewController : FSBaseViewController {
    /*!@var splashImageView 启动图片背景视图*/ 
    UIImageView *splashImageView;
    /*!@var fileCache  缓存object到临时目录的文件中
     主要用于缓存网络数据*/ 
    FSFileCache *fileCache;
}

/*!
 @method showBootImage:
 @discussion 显示启动图片
 @param isLandscape
 */ 
-(void)showBootImage:(BOOL)isLandscape;  

@end
