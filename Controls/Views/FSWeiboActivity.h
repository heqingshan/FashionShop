//
//  FSWeiboActivity.h
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "FSShareView.h"

@interface FSWeiboActivity : FSUIActivity<SinaWeiboDelegate,SinaWeiboRequestDelegate>


@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) UIImage *img;
@end
