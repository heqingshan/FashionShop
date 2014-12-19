
#import "FSStartViewController.h"
#import "FSCommonRequest.h"
#import "UIDevice+Extention.h"
#import "FSCommon.h"

@interface FSStartViewController()
{
    FSCommon *vData;
}

@end

@implementation FSStartViewController

- (void)loadView {
	CGRect appFrame = [[UIScreen mainScreen] bounds];
	UIView *lView = [[UIView alloc] initWithFrame:appFrame];
	self.view = lView;
    fileCache = [[FSFileCache alloc] initWithFileName:@"bootImages.dat"];
	[self showBootImage:NO];
    [self checkVersion];
}

//进行版本检测
-(void)checkVersion
{
    //请求网络数据，此处可更改为版本更新检查
    FSCommonRequest *request = [[FSCommonRequest alloc] init];
    [request setRouteResourcePath:RK_REQUEST_CHECK_VERSION];
    [request send:[FSCommon class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        if (resp.isSuccess)
        {
            vData = resp.responseData;
            
            theApp.versionData = vData;
            vData.code = 0;
            //http://111.207.166.195/fileupload/img/promotion/20130507/89919e95-ec9b-426e-b620-7ff15bf64c7f_320x0.jpg
            //http://111.207.166.195/fileupload/img/customerportrait/000/010/4f965d2c-1bd0-4f5a-97ad-b3d94de52d54_100x100.jpg
            //http://111.207.166.195/fileupload/img/product/20130405/bd2e5e86-62c3-4cc5-af18-fffa11e7613a_320x0.jpg
            vData.startimage = @"http://111.207.166.195/fileupload/img/product/20130405/bd2e5e86-62c3-4cc5-af18-fffa11e7613a_320x0.jpg";
            vData.startimage_iphone5 = @"http://111.207.166.195/fileupload/img/promotion/20130507/89919e95-ec9b-426e-b620-7ff15bf64c7f_320x0.jpg";
            if (vData) {
                [self dealWithStartImage];
            }
            id value = [[NSUserDefaults standardUserDefaults] objectForKey:@"Not Show Again"];
            if (value && [value boolValue]) {
                return ;
            }
            UIAlertView *alert = nil;
            switch (vData.type) {
                case 0://已是最新版本，不用更新
                {
                    //do nothing
                }
                    break;
                case 1://可选更新。有三个选项：取消、确认更新和不再提醒
                {
                    alert = [[UIAlertView alloc] initWithTitle:vData.title message:vData.desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",@"不再提醒", nil];
                    [alert show];
                }
                    break;
                case 2://强制更新。只有一个更新按钮：强制更新
                {
                    alert = [[UIAlertView alloc] initWithTitle:vData.title message:vData.desc delegate:self cancelButtonTitle:@"强制更新" otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
            theApp.versionData = vData;
        }
    }];
}

-(void)dealWithStartImage
{
    if (vData.code == 401) {  //401：已是最新版本；
        //do nothing
    }
    else if(vData.code == 402) {  //402：请使用默认图片。
        if ([UIDevice isRunningOniPhone5]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"Default-568h.png" forKey:@"default_img_path"];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:@"Default.png" forKey:@"default_img_path"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(vData.code == 400) {    //有新图片
        FSFileCache *_fileCache = [[FSFileCache alloc] initWithFileName:@"bootImages.dat"];
        //读取新的图片信息
        NSError* error=nil;
        NSString *newPath = [UIDevice isRunningOniPhone5]?vData.startimage_iphone5:vData.startimage;
        NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:newPath] options:0 error:&error];
        if(data!=nil && error==nil){
            UIImage* image=[UIImage imageWithData:data];
            if(image!=nil){
                [_fileCache setObject:data forKey:newPath];
                [[NSUserDefaults standardUserDefaults] setObject:newPath forKey:@"default_img_path"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
}

-(void)showBootImage:(BOOL)isLandscape{
    [splashImageView removeFromSuperview];
    NSString *path = [[NSUserDefaults standardUserDefaults] objectForKey:@"default_img_path"];
    if (!path) {
        if ([UIDevice isRunningOniPhone5]) {
            splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
        }
        else{
            splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
        }
    }
    else {
        NSData* imageData=(NSData*)[fileCache objectForKey:path];
        UIImage* image = nil;
        if(imageData!=nil){
            image=[UIImage imageWithData:imageData];
        }
        if (image) {
            splashImageView = [[UIImageView alloc] initWithImage:image];
        }
        else{   //既无新的默认启动图片又没有特殊实效启动图片，则显示本地默认的启动图片
            if ([UIDevice isRunningOniPhone5]) {
                splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
            }
            else{
                splashImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
            }
        }
    }
    splashImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGH);
    [self.view addSubview:splashImageView];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (vData.type) {
        case 0://已是最新版本，不用更新
        {
            //do nothing
        }
            break;
        case 1://可选更新。有三个选项：取消、确认更新和不再提醒
        {
            if (buttonIndex == 0) {
                //do nothing
            }
            else if(buttonIndex == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vData.downLoadURL]];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"Not Show Again"];
            }
        }
            break;
        case 2://强制更新。只有一个更新按钮：强制更新
        {
            if (buttonIndex == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vData.downLoadURL]];
                [self exitApplication];
            }
        }
            break;
        default:
            break;
    }
}

//退出应用程序（OK）
- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:theApp.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    theApp.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

@end
