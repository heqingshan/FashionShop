//
//  FSAudioButton.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-29.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAudioButton.h"
#import "CL_VoiceEngine.h"

@interface FSAudioButton(){
    UILabel *timeLb;
    UIImageView *soundImageView;
    UIActivityIndicatorView *activity;
    UIImageView *playImageView;
    UIImageView *animateView;
    
    NSMutableData * receiveData;
    NSString *fileName;
}

@end

@implementation FSAudioButton
@synthesize fullPath;
@synthesize state;

-(void)setTitleFrame:(CGRect)_rect
{
    timeLb.frame = _rect;
    timeLb.font = [UIFont boldSystemFontOfSize:12];
    timeLb.textAlignment = UITextAlignmentCenter;
}

-(void)setPlayButtonFrame:(CGRect)_rect
{
    activity.frame = _rect;
    playImageView.frame = _rect;
    animateView.frame = _rect;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }
    return self;
}

-(void)initControl
{
    //设置按钮属性
    [self setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:@"play_normal.png"];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    
    //添加时间标签
    timeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/1.5, self.frame.size.height)];
    timeLb.font = [UIFont boldSystemFontOfSize:10];
    timeLb.backgroundColor = [UIColor clearColor];
    timeLb.textAlignment = UITextAlignmentCenter;
    timeLb.textColor = RGBCOLOR(0, 0, 0);
    [self addSubview:timeLb];
    
    double xOffset = self.frame.size.width / 3 * 2;
    double height = self.frame.size.height/2;
    CGRect _rect = CGRectMake(xOffset, height/2, height/5*4, height);
    
    //添加加载
    activity = [[UIActivityIndicatorView alloc] initWithFrame:_rect];
    activity.hidden = YES;
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self addSubview:activity];
    
    //添加播放图标
    playImageView = [[UIImageView alloc] initWithFrame:_rect];
    playImageView.image = [UIImage imageNamed:@"play_icon.png"];
    [self addSubview:playImageView];
    
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
    [self addSubview:animateView];
    
    [self addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    self.state = Normal;
}

-(void)setAudioTime:(NSString *)audioTime
{
    _audioTime = audioTime;
    timeLb.text = audioTime;
}

-(void)setState:(AudioState)aState
{
    state = aState;
    switch (state) {
        case Normal:
        {
            activity.hidden = YES;
            playImageView.hidden = NO;
            animateView.hidden = YES;
        }
            break;
        case Playing:
        {
            activity.hidden = YES;
            playImageView.hidden = YES;
            animateView.hidden = NO;
        }
            break;
        case Stop:
        {
            activity.hidden = YES;
            playImageView.hidden = NO;
            animateView.hidden = YES;
        }
            break;
        case Pause:
        {
            activity.hidden = YES;
            playImageView.hidden = NO;
            animateView.hidden = YES;
        }
            break;
        case Loading:
        {
            activity.hidden = NO;
            playImageView.hidden = YES;
            animateView.hidden = YES;
        }
            break;
        default:
            break;
    }
}

-(void)clickToPlay:(UIButton*)sender
{
    if (_audioDelegate && [_audioDelegate respondsToSelector:@selector(clickAudioButton:)]) {
        [_audioDelegate clickAudioButton:self];
    }
    if (state == Playing) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        [self pause];
    }
    else{
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [self play];
    }
}

-(void)play
{
    if (state == Playing) {
        self.state = Pause;
        [theApp.audioPlayer pause];
        [animateView stopAnimating];
    }
    else if(state == Loading) {
        [activity stopAnimating];
        self.state = Normal;
    }
    else if(state == Pause) {
        self.state = Playing;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [theApp.audioPlayer play];
        [animateView startAnimating];
    }
    else{
        [self startPlay];
    }
}

-(void)startPlay
{
    //首先检测该文件是否已经存在缓存列表中，如果存在，则直接使用播放
    fileName = [fullPath lastPathComponent];
    NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
    {
        NSLog(@"recordAudioFullPath:%@", recordAudioFullPath);
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        theApp.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:recordAudioFullPath] error:nil];
        theApp.audioPlayer.delegate = self;
        [theApp.audioPlayer prepareToPlay];
        [theApp.audioPlayer play];
        self.state = Playing;
        [animateView startAnimating];
    }
    else{
        NSLog(@"fullPath:%@", fullPath);
        NSURL * url = [[NSURL alloc] initWithString:fullPath];
        NSURLRequest * urlRequest = [[NSURLRequest alloc] initWithURL:url];
        //异步请求数据
        [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        //给状态栏加菊花
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

-(void)stop
{
    [theApp.audioPlayer stop];
    theApp.audioPlayer.currentTime = 0;
    self.state = Stop;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

-(void)pause
{
    [theApp.audioPlayer pause];
    self.state = Pause;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

-(BOOL)isPlaying
{
    return [theApp.audioPlayer isPlaying];
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    receiveData = [[NSMutableData alloc] init];
    self.state = Loading;
    [activity startAnimating];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receiveData  appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //缓冲完成后关闭菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    /*
     将下载好的数据写入沙盒的cache目录下
     */
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:kRecorderDirectory]) {
        [fm createDirectoryAtPath:kRecorderDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath=[kRecorderDirectory  stringByAppendingPathComponent:fileName];
    [receiveData writeToFile:filePath atomically:YES];
    [self performSelector:@selector(showPlay:) withObject:filePath afterDelay:1.5];
}
-(void)showPlay:(NSString*)filePath
{
    //以该路径初始化一个url,然后以url初始化player
    NSError * error;
    NSURL * url = [NSURL fileURLWithPath:filePath];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    theApp.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    theApp.audioPlayer.delegate = self;
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    [theApp.audioPlayer prepareToPlay];
    [theApp.audioPlayer play];
    self.state = Playing;
    [animateView startAnimating];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //网络连接失败，关闭菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    self.state = Normal;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.state = Stop;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

@end
