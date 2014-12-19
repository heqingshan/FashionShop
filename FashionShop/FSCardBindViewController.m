//
//  FSCardBindViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-11.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCardBindViewController.h"
#import "FSCardRequest.h"
#import "FSCardInfo.h"
#import "NSString+Extention.h"

@interface FSCardBindViewController ()

@end

@implementation FSCardBindViewController
@synthesize currentUser;
@synthesize completeCallBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTitle];
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    [self prepareView];
}

-(void)updateTitle
{
    if ([currentUser.isBindCard boolValue]) {
        self.title = NSLocalizedString(@"Card Info Query", nil);
    }
    else {
        self.title = NSLocalizedString(@"Bind Member Card", nil);
    }
}

-(void)prepareView
{
    //设置背景图片
    if ([UIDevice isRunningOniPhone5]) {
        _bgImageView.image = [[UIImage imageNamed:@"bind_card__5_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:200];
    }
    else{
        _bgImageView.image = [[UIImage imageNamed:@"bind_card_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:200];
    }
    
    _bgImageView.frame = CGRectMake(0, 0, APP_WIDTH, APP_HIGH-NAV_HIGH-TAB_HIGH);
    
    if (![currentUser.isBindCard boolValue]) {
        _bindView.hidden = NO;
        _resultView.hidden = YES;
        _bindView.layer.cornerRadius = 10;
        _bindView.layer.borderWidth = 1;
        _bindView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        CGRect _rect = _bindView.frame;
        _rect.origin.y = 15;
        _bindView.frame = _rect;
        
        UIImage *image = [UIImage imageNamed:@"btn_bg.png"];
        [_btnBindCard setBackgroundImage:image forState:UIControlStateNormal];
        
        [_cardNumField becomeFirstResponder];
    }
    else {
        _bindView.hidden = YES;
        _resultView.hidden = YES;
        _resultView.layer.cornerRadius = 10;
        _resultView.layer.borderWidth = 1;
        _resultView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        CGRect _rect = _resultView.frame;
        _rect.origin.y = 15;
        _resultView.frame = _rect;
        
        FSCardRequest *request = [[FSCardRequest alloc] init];
        request.userToken = currentUser.uToken;
        request.routeResourcePath = RK_REQUEST_USER_CARD_DETAIL;
        [self beginLoading:_resultView];
        __block FSCardBindViewController *blockSelf = self;
        [request send:[FSCardInfo class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:_resultView];
            if (!resp.isSuccess)
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(NO);
                }
                [self reportError:resp.message];
            }
            else
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(YES);
                }
                //显示绑定成功界面
                _cardNumField.text = @"";
                _cardPwField.text = @"";
                currentUser.isBindCard = @YES;
                if ([_cardNumField isFirstResponder]) {
                    [_cardNumField resignFirstResponder];
                }
                if ([_cardPwField isFirstResponder]) {
                    [_cardPwField resignFirstResponder];
                }
                FSCardInfo *info = (FSCardInfo*)resp.responseData;
                [self updateResultView:info];
                
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [_dic setValue:info.cardNo forKey:@"卡号"];
                [_dic setValue:@"会员卡页面" forKey:@"来源页面"];
                [[FSAnalysis instance] logEvent:MEMBER_CARDINFO_SHOW withParameters:_dic];
            }
        }];
    }
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setBindView:nil];
    [self setResultView:nil];
    [self setCardNumField:nil];
    [self setCardPwField:nil];
    [self setCardLevel:nil];
    [self setCardNum:nil];
    [self setCardPoint:nil];
    [self setBgImageView:nil];
    [self setBtnBindCard:nil];
    [super viewDidUnload];
}

- (IBAction)bindCard:(id)sender {
    if ([self checkInput])
    {
        FSCardRequest *request = [[FSCardRequest alloc] init];
        FSUser *localUser = [FSUser localProfile];
        request.userToken = localUser.uToken;
        request.cardNo = _cardNumField.text;
        request.passWord = _cardPwField.text;
        request.routeResourcePath = RK_REQUEST_USER_CARD_BIND;
        [self beginLoading:self.view];
        __block FSCardBindViewController *blockSelf = self;
        [request send:[FSCardInfo class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (!resp.isSuccess)
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(NO);
                }
                [self reportError:resp.errorDescrip];
            }
            else
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(YES);
                }
                [self reportError:resp.message];
                //显示绑定成功界面
                _cardNumField.text = @"";
                _cardPwField.text = @"";
                currentUser.isBindCard = @YES;
                [self updateResultView:resp.responseData];
                [self updateTitle];
                [self prepareView];
                
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [_dic setValue:request.cardNo forKey:@"卡号"];
                [_dic setValue:@"会员卡绑定页" forKey:@"来源页面"];
                [[FSAnalysis instance] logEvent:MEMBER_CARD_BIND withParameters:_dic];
            }
            [self endLoading:self.view];
        }];
    }
}

-(void)updateResultView:(FSCardInfo*)_cardInfo
{
    _bindView.hidden = YES;
    _resultView.hidden = NO;
    _cardLevel.text = [NSString stringWithFormat:@"%@-%@", _cardInfo.type, _cardInfo.cardLevel];
    _cardNum.text = _cardInfo.cardNo;
    _cardPoint.text = [NSString stringWithFormat:@"%@", _cardInfo.amount];
    currentUser.cardInfo = _cardInfo;
}

-(BOOL) checkInput
{
    if ([NSString isNilOrEmpty:_cardNumField.text])
    {
        [self reportError:NSLocalizedString(@"Member Card Num Input Tip", nil)];
        return NO;
    }
    if ([NSString isNilOrEmpty:_cardPwField.text]) {
        [self reportError:NSLocalizedString(@"Member Card Pwd Input Tip", nil)];
        return NO;
    }
    return YES;
}

- (IBAction)unBindCard:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt",nil) message:NSLocalizedString(@"Prompt Of UnBindCard", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}

-(void)popViewControllerAnimated:(BOOL)flag completion: (void (^)(void))completion
{
    [self.navigationController popViewControllerAnimated:flag];
    if (completion) {
        completion();
    }
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        FSCardRequest *request = [[FSCardRequest alloc] init];
        request.userToken = currentUser.uToken;
        request.routeResourcePath = RK_REQUEST_USER_CARD_UNBIND;
        [self beginLoading:self.view];
        [request send:[FSModelBase class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (!resp.isSuccess)
            {
                [self reportError:resp.description];
            }
            else
            {
                [self reportError:resp.message];
                //显示绑定界面
                currentUser.isBindCard = @NO;
                [self updateTitle];
                [self prepareView];
            }
            [self endLoading:self.view];
        }];
    }
}

@end
