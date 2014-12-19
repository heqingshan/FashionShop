//
//  FSProPostTitleViewController.m
//  FashionShop
//
//  Created by gong yi on 12/1/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProPostTitleViewController.h"
#import "FSProPostMainViewController.h"
#import "NSString+Extention.h"
#import "CL_VoiceEngine.h"
#import "FSAudioButton.h"
#import "FSAudioShowView.h"

#define TITLE_MAX_LENGTH 15

@interface FSProPostTitleViewController ()
{
    UIView                  *backView;
    TDDatePickerController  *_datePicker;
    TDDatePickerController  *_dateEndPicker;
    id                      activityObject;
    RecordState             _recordState;
    BOOL                    _isRecording;
    NSDate                  *_downTime;//按下时间
    NSInteger               _minRecordGap;//最小录制时间间隔
    UIImageView             *playImageView;
    UIImageView             *animateView;
    NSTimer                 *_timer;
    FSAudioShowView         *_audioShowView;//音量检测视图
}

@end

@implementation FSProPostTitleViewController

@synthesize delegate;

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
    [self decorateTapDismissKeyBoard];
    [self bindControl];
    [self initRecordButton];
    
    _minRecordGap = 4;
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    self.view.backgroundColor = APP_TABLE_BG_COLOR;
}

- (void)viewDidUnload {
    [self stopAllAudio];
    [self setLblName:nil];
    [self setLblDescName:nil];
    [self setLblPrice:nil];
    [self setTxtPrice:nil];
    [self setLbProDesc:nil];
    [self setTxtProDesc:nil];
    [self setLbProTime:nil];
    [self setTxtProEndTime:nil];
    [self setTxtProStartTime:nil];
    [self setLblDescVoice:nil];
    [self setBtnRecord:nil];
    [self setBtnReRecord:nil];
    [self setContentView:nil];
    [self setLbOriginalPrice:nil];
    [self setTxtOriginalPrice:nil];
    [self setLbUpccode:nil];
    [self setTxtUpccode:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_txtTitle becomeFirstResponder];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopAllAudio];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

#pragma mark - selfdef method

-(void)stopAllAudio
{
    if (theApp.audioPlayer.isPlaying) {
        [theApp.audioPlayer stop];
        _recordState = PTWaitPlay;
    }
}

-(void)initRecordButton
{
    UIImage *image = [UIImage imageNamed:@"audio_btn_normal.png"];
    [_btnRecord setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"audio_btn_sel.png"];
    [_btnRecord setBackgroundImage:image forState:UIControlStateHighlighted];
    
    int height = _btnRecord.frame.size.height/2;
    CGRect _rect = CGRectMake((_btnRecord.frame.size.width-height)/2 - 40, height/2, height, height);
    //添加播放图标
    playImageView = [[UIImageView alloc] initWithFrame:_rect];
    playImageView.hidden = YES;
    playImageView.image = [UIImage imageNamed:@"play_icon.png"];
    playImageView.contentMode = UIViewContentModeCenter;
    [_btnRecord addSubview:playImageView];
    
    //添加播放动画
    animateView = [[UIImageView alloc] initWithFrame:_rect];
    animateView.animationImages = [NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"audio_play0.png"],
                                   [UIImage imageNamed:@"audio_play1.png"],
                                   [UIImage imageNamed:@"audio_play2.png"],
                                   [UIImage imageNamed:@"audio_play3.png"],
                                   nil];
    animateView.animationDuration = 1.2;
    animateView.hidden = YES;
    animateView.contentMode = UIViewContentModeCenter;
    [_btnRecord addSubview:animateView];
    
    if (!_audioShowView) {
        int height = 120;
        _audioShowView = [[FSAudioShowView alloc] initWithFrame:CGRectMake((APP_WIDTH - height)/2, (APP_HIGH - height)/2 - 60, height, height)];
        [self.view addSubview:_audioShowView];
        _audioShowView.hidden = YES;
    }
}

-(void) decorateTapDismissKeyBoard
{
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
    [backView addGestureRecognizer:recognizer];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
}

- (void) bindControl
{
    if (self.navigationItem)
    {
        self.navigationItem.title = NSLocalizedString(@"PRO_POST_TITLE_LABEL", nil);
    }
    _lblName.font = ME_FONT(14);
    _lblName.textColor = [UIColor colorWithRed:76 green:86 blue:108];
    _lblName.textAlignment = NSTextAlignmentRight;
    _lblDescName.font = ME_FONT(14);
    _lblDescName.textColor = [UIColor colorWithRed:76 green:86 blue:108];
    _lblDescName.textAlignment = NSTextAlignmentRight;
    [_txtTitle setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
    _txtTitle.layer.borderWidth = 0.5;
    _txtTitle.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
    _txtTitle.placeholder = [NSString stringWithFormat:NSLocalizedString(@"only %d chars allowed", nil), TITLE_MAX_LENGTH];
    [_txtDesc setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
    _txtDesc.layer.borderWidth = 2;
    _txtDesc.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
    if (_publishSource==FSSourceProduct)
    {
        _txtDesc.placeholder = NSLocalizedString(@"Input Product Desc", nil);
        _lbUpccode.font = ME_FONT(14);
        _lbUpccode.textColor = [UIColor colorWithRed:76 green:86 blue:108];;
        _lbUpccode.textAlignment = NSTextAlignmentRight;
        [_txtUpccode setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
        _txtUpccode.layer.borderWidth = 1;
        _txtUpccode.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
        _txtUpccode.delegate = self;
        
        _lbOriginalPrice.font = ME_FONT(14);
        _lbOriginalPrice.textColor = [UIColor colorWithRed:76 green:86 blue:108];;
        _lbOriginalPrice.textAlignment = NSTextAlignmentRight;
        [_txtOriginalPrice setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
        _txtOriginalPrice.layer.borderWidth = 1;
        _txtOriginalPrice.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
        _txtOriginalPrice.delegate = self;
        
        _lblPrice.font = ME_FONT(14);
        _lblPrice.textColor = [UIColor colorWithRed:76 green:86 blue:108];;
        _lblPrice.textAlignment = NSTextAlignmentRight;
        [_txtPrice setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
        _txtPrice.layer.borderWidth = 1;
        _txtPrice.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
        _txtPrice.delegate = self;
        
        _lbProDesc.font = ME_FONT(14);
        _lbProDesc.textColor = [UIColor colorWithRed:76 green:86 blue:108];;
        _lbProDesc.textAlignment = NSTextAlignmentRight;
        [_txtProDesc setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
        _txtProDesc.layer.borderWidth = 1;
        _txtProDesc.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
        _txtProDesc.delegate = self;
        
        _lbProTime.font = ME_FONT(14);
        _lbProTime.textColor = [UIColor colorWithRed:76 green:86 blue:108];;
        _lbProTime.textAlignment = NSTextAlignmentRight;
        [_txtProStartTime setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
        _txtProStartTime.layer.borderWidth = 1;
        _txtProStartTime.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
        _txtProStartTime.tag = 1;
        
        [_txtProEndTime setBackgroundColor:[UIColor colorWithRed:247 green:247 blue:247]];
        _txtProEndTime.layer.borderWidth = 1;
        _txtProEndTime.tag = 2;
        _txtProEndTime.layer.borderColor = [UIColor colorWithRed:222 green:222 blue:222].CGColor;
    }
    else
    {
        _txtDesc.placeholder = NSLocalizedString(@"Input Promotion Desc", nil);
        _lbOriginalPrice.layer.opacity = 0;
        _txtOriginalPrice.layer.opacity = 0;
        
        _lblPrice.layer.opacity = 0;
        _txtPrice.layer.opacity = 0;
        
        _lbProDesc.layer.opacity = 0;
        _txtProDesc.layer.opacity = 0;
        
        _lbProTime.layer.opacity = 0;
        _txtProStartTime.layer.opacity = 0;
        _txtProEndTime.layer.opacity = 0;
        
        if ([_txtProEndTime.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView*)_txtProEndTime.superview;
            scroll.scrollEnabled = NO;
        }
    }
    _txtTitle.delegate = self;
    _txtDesc.delegate = self;
}

-(BOOL) checkInput
{
    if (!(_txtTitle.text.length > 0 &&
        _txtTitle.text.length < TITLE_MAX_LENGTH))
    {
        [self reportError:[NSString stringWithFormat:NSLocalizedString(@"PRO_POST_TITLE_LENGTH_ERROR %d", nil), TITLE_MAX_LENGTH]];
        return NO;
    }
    if ([NSString isNilOrEmpty:_txtDesc.text]) {
        [self reportError:NSLocalizedString(@"PRO_POST_DESC_INFO", nil)];
        return NO;
    }
    //如果选择了活动描述，则要求一定要输入有效期。
    if (![NSString isNilOrEmpty:_txtProDesc.text]) {
        if ([NSString isNilOrEmpty:_txtProStartTime.text] || [NSString isNilOrEmpty:_txtProStartTime.text]) {
            [self reportError:NSLocalizedString(@"PRO_POST_DURATION_ERROR", nil)];
            return NO;
        }
    }
    if ([_txtProDesc.text isEqualToString:@""]) {
        return YES;
    }
    NSMutableString *error = [@"" mutableCopy];
    if(![self validateDate:&error])
    {
        [self reportError:error];
        return NO;
    }
    return YES;
}

- (BOOL)validateDate:(NSMutableString **)errorin
{
    if (_publishSource == FSSourcePromotion) {
        return YES;
    }
    if ([_txtProDesc.text isEqualToString:@""]) {
        return YES;
    }
    if (!errorin)
        *errorin = [@"" mutableCopy];
    NSMutableString *error = *errorin;
    if([_dateEndPicker.datePicker.date compare:_datePicker.datePicker.date] != NSOrderedDescending)
    {
        [error appendString:NSLocalizedString(@"PRO_POST_DURATION_DATE_VALIDATE", nil)];;
        return false;
    }
    return true;
}

-(void) dismissKB
{
    if ([_txtTitle isFirstResponder])
        [_txtTitle resignFirstResponder];
    else if ([_txtDesc isFirstResponder])
    {
        [_txtDesc resignFirstResponder];
    } else if ([_txtPrice isFirstResponder])
    {
        [_txtPrice resignFirstResponder];
    }
}

-(void)cleanData
{
    [self hideReRecordButton];
    NSLock* tempLock = [[NSLock alloc]init];
    [tempLock lock];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_recordFileName])
    {
        [[NSFileManager defaultManager] removeItemAtPath:_recordFileName error:nil];
    }
    [tempLock unlock];
    
    _txtTitle.text = @"";
    _txtDesc.text = @"";
    _txtPrice.text = @"";
    _txtOriginalPrice.text = @"";
    _txtProDesc.text = @"";
    _txtProStartTime.text = @"";
    _txtProEndTime.text = @"";
    _btnReRecord = nil;
    _btnRecord = nil;
}

- (IBAction)doSave:(id)sender {
    if ([self checkInput])
    {
        if ([delegate respondsToSelector:@selector(titleViewControllerSetTitle:)])
        {
            [delegate titleViewControllerSetTitle:self];
        }
    }
}

- (IBAction)doCancel:(id)sender {
    if([delegate respondsToSelector:@selector(titleViewControllerCancel:)])
    {
        [delegate titleViewControllerCancel:self];
    }
}

- (IBAction)selDuration:(id)sender {
    UIButton* btn = (UIButton*)sender;
    if (btn.tag == 1) {
        if (!_datePicker) {
            _datePicker = [[TDDatePickerController alloc] init];
            _datePicker.delegate = self;
        }
        [self presentSemiModalViewController:_datePicker];
    }
    else {
        if (!_dateEndPicker) {
            _dateEndPicker = [[TDDatePickerController alloc] init];
            _dateEndPicker.delegate = self;
        }
        [self presentSemiModalViewController:_dateEndPicker];
    }
    [activityObject resignFirstResponder];
}

#pragma mark - TDDatePickerControllerDelegate

- (void)datePickerSetDate:(TDDatePickerController *)viewController
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:NSLocalizedString(@"Year Month Day H&M", nil)];
    if (viewController == _datePicker)
    {
        _txtProStartTime.text = [formater stringFromDate:_datePicker.datePicker.date];
    }
    else if(viewController == _dateEndPicker)
    {
        _txtProEndTime.text = [formater stringFromDate:_dateEndPicker.datePicker.date];
    }
    [self dismissSemiModalViewController:viewController];
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:viewController];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activityObject = textView;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activityObject = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _txtPrice || textField == _txtOriginalPrice) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (textField.text.length > 7) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - record function

- (BOOL)startToRecord
{
    [activityObject resignFirstResponder];
    
    if (_isRecording == NO)
    {
        [theApp initAudioRecoder];
        theApp.audioRecoder.clAudioDelegate = self;
        _isRecording = YES;
        _recordFileName = [NSString stringWithFormat:@"%f.m4a", [[NSDate date] timeIntervalSince1970]];
        theApp.audioRecoder.recorderingFileName = _recordFileName;
        return [theApp.audioRecoder startRecord];
    }
    return NO;
}

- (void)endRecord
{
    _isRecording = NO;
    dispatch_queue_t stopQueue;
    stopQueue = dispatch_queue_create("stopQueue", NULL);
    dispatch_async(stopQueue, ^(void){
        //run in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [theApp.audioRecoder stopRecord];
        });
    });
    //dispatch_release(stopQueue);
}

-(void)endRecordAndDelete
{
    _isRecording = NO;
    dispatch_queue_t stopQueue;
    stopQueue = dispatch_queue_create("stopQueue", NULL);
    dispatch_async(stopQueue, ^(void){
        //run in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [theApp.audioRecoder stopAndDeleteRecord];
        });
    });
    //dispatch_release(stopQueue);
}

-(void)startPlay
{
    if (theApp.audioPlayer) {
        [self pausePlay];
    }
    NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:_recordFileName];
    NSURL *url = [NSURL fileURLWithPath:recordAudioFullPath];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    theApp.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    theApp.audioPlayer.delegate = self;
    [theApp.audioPlayer prepareToPlay];
    _recordState = PTPlaying;
    [animateView startAnimating];
    animateView.hidden = NO;
    playImageView.hidden = YES;
    [theApp.audioPlayer play];
}

-(void)stopPlay
{
    _recordState = PTWaitPlay;
    [animateView stopAnimating];
    animateView.hidden = YES;
    playImageView.hidden = NO;
    theApp.audioPlayer.currentTime = 0;
    [theApp.audioPlayer stop];
}

-(void)pausePlay
{
    animateView.hidden = YES;
    playImageView.hidden = NO;
    _recordState = PTWaitPlay;
    [animateView stopAnimating];
    [theApp.audioPlayer pause];
}

-(void)showReRecordButton
{
    [UIView animateWithDuration:0.3 animations:^{
        //改变尺寸
        CGRect _rect = _btnRecord.frame;
        _rect.size.width -= 80;
        _btnRecord.frame = _rect;
        
        _btnReRecord.alpha = 1.0;
        _rect = _btnReRecord.frame;
        _rect.size.width = 75;
        _rect.origin.x -= 75;
        _btnReRecord.frame = _rect;
        
        //加入播放按钮
        [_btnRecord setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        playImageView.hidden = NO;
    }];
}

-(void)hideReRecordButton
{
    //设置状态
    _recordState = PTStartRecord;
    playImageView.hidden = YES;
    animateView.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        //改变尺寸
        CGRect _rect = _btnRecord.frame;
        _rect.size.width += 80;
        _btnRecord.frame = _rect;
        
        _btnReRecord.alpha = 0;
        _rect = _btnReRecord.frame;
        _rect.size.width = 0;
        _rect.origin.x += 75;
        _btnReRecord.frame = _rect;
    } completion:^(BOOL finished) {
        //加入播放按钮
        [_btnRecord setTitle:@"按住开始录音" forState:UIControlStateNormal];
        //清除文件内容
        NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:_recordFileName];
        NSLock* tempLock = [[NSLock alloc]init];
        [tempLock lock];
        if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:recordAudioFullPath error:nil];
        }
        [tempLock unlock];
        _recordFileName = nil;
    }];
}

#pragma mark - button action

- (IBAction)recordTouchDown:(id)sender
{
    if (_recordState == PTWaitPlay ||
        _recordState == PTPlaying) {
        return;
    }
    _downTime = [NSDate date];
    [_btnRecord setTitle:NSLocalizedString(@"Up To End Record", nil) forState:UIControlStateNormal];
    if (![self startToRecord]) {
        [self endRecord];
        return;
    }
    _recordState = PTRecording;
    
    [self startShowAnimation];
}

- (IBAction)recordTouchUpInside:(id)sender
{
    [self endTouch];
}

- (IBAction)recordTouchUpOutside:(id)sender
{
    [self endTouch];
    //删除录音
//    [sender setTitle:NSLocalizedString(@"Down To Start Comment", nil) forState:UIControlStateNormal];
//    _recordState = PTStartRecord;
//    [self endRecordAndDelete];
//    [self endShowAnimation];
}

- (IBAction)reRecordTouchUpInside:(id)sender {
    [self stopPlay];
    [self hideReRecordButton];
}

-(void)endTouch
{
    if (_recordState == PTWaitPlay) {
        [self startPlay];
    }
    else if(_recordState == PTPlaying) {
        [self pausePlay];
    }
    else if(_recordState == PTRecording){
        [self endShowAnimation];
        NSInteger gap = [[NSDate date] timeIntervalSinceDate:_downTime];
        if (gap < _minRecordGap) {
            //显示提示时间太短对话框
            [self reportError:NSLocalizedString(@"Speak Too Short, Please Say Again", nil)];
            //重新设置为起始状态
            [_btnRecord setTitle:NSLocalizedString(@"Down To Start Record", nil) forState:UIControlStateNormal];
            _recordState = PTStartRecord;
            [self endRecordAndDelete];
        }
        else{
            [_btnRecord setTitle:NSLocalizedString(@"Click To Play", nil) forState:UIControlStateNormal];
            _recordState = PTWaitPlay;
            [self endRecord];
        }
    }
}

#pragma mark - AVAudioPlayDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopPlay];
}

#pragma mark - FSCL_AudioDelegate

-(void)stopRecorderEnd:(CL_AudioRecorder *)_record
{
    //显示重新录入按钮
    [self showReRecordButton];
}

-(void)stopAndDelRecorderEnd:(CL_AudioRecorder*)_record
{
}

-(void)errorRecorderDidOccur:(CL_AudioRecorder*)_record
{
    [self endShowAnimation];
}

#pragma mark - Record Animation

-(void)startShowAnimation
{
    //开启音量检测
    theApp.audioRecoder.audioRecorder.meteringEnabled = YES;
    //设置定时检测
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                  target: self
                                                selector: @selector( levelTimerCallback:)
                                                userInfo: nil
                                                 repeats: YES];
    }
    [_timer fire];
    _audioShowView.hidden = NO;
    [_audioShowView showAudioViewInUpload];
}

#define AudioLabel_Height 47

//音量检测
- (void)levelTimerCallback:(NSTimer *)timer
{
    //刷新音量数据
    [theApp.audioRecoder.audioRecorder updateMeters];
    //获取音量的平均值
    CGFloat averagePower = [theApp.audioRecoder.audioRecorder averagePowerForChannel:0];
    averagePower = abs(averagePower);
    if (averagePower > AudioLabel_Height) {
        averagePower = AudioLabel_Height;
    }
    averagePower = AudioLabel_Height - averagePower;
    if (averagePower < 5) {
        averagePower = 5;
    }
    
    NSLog(@"averagePower:%.2f", averagePower);
    //更改UI的图形效果
    [_audioShowView updateAudioLabelFrame:averagePower];
}

-(void)endShowAnimation
{
    [_timer invalidate];
    _timer = nil;
    _audioShowView.hidden = YES;
}

@end
