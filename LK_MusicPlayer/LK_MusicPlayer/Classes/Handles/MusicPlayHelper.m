//
//  MusicPlayHelper.m
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicPlayHelper.h"

@interface MusicPlayHelper ()
{
    BOOL isPlaying;
}

@property(nonatomic ,weak)NSTimer * timer;
          
@end

static  AVPlayer * avPlayer;

@implementation MusicPlayHelper

#pragma mark - 单例 
+ (instancetype)shareInstance
{
    static MusicPlayHelper * musicHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicHelper=[[MusicPlayHelper alloc]init];
        //初始化音乐播放器
        avPlayer=[[AVPlayer alloc] init];
    });
    return musicHelper;
}
//重写初始化方法
-(instancetype)init
{
   self= [super init];
    if (self) {
        //注册通知 当音乐播放完成后执行绑定方法 系统自动发送的
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}

#pragma mark - 设置音乐播放器
-(void)setAVPlayerWithUrl:(NSString *)url
{
    //包装url初始化item
    AVPlayerItem * item=[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:url]];
    //一首一首替换item
    [avPlayer replaceCurrentItemWithPlayerItem:item];
    
    //开始播放
    [self playMusic];
   
    
}

-(void)volumn:(CGFloat)value
{
    avPlayer.volume=value;
}

#pragma mark 播放音乐
-(void)playMusic
{
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingAction) userInfo:nil repeats:YES ];
    isPlaying=YES;
    [avPlayer play];//播放
   
    
}

#pragma mark  暂停播放
-(void)pauseMusic
{
    isPlaying=NO;
    [avPlayer pause];
    [self.timer invalidate];//暂停时计时不可用
    self.timer=nil;
}

#pragma mark 暂停或播放
-(BOOL)playOrPauseMusic
{
    if (isPlaying) {
        [self pauseMusic];
        return NO;
    }
    else{
        
        [self playMusic];
        return YES;
        
    }
}

#pragma mark 从指定时间开始播放
-(void)seekToTimePlay:(CGFloat)time
{
    //先暂停
    [self pauseMusic];
    //将时间设置为制定时间
    [avPlayer seekToTime:CMTimeMakeWithSeconds(time, avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            //开始播放
            [self playMusic];
        }
    }];
    
}

#pragma mark  - 私有方法

#pragma mark  播放过程中执行(协议方法)

-(void)playingAction
{
   //把当前播放时间(进度)给音乐播放界面
    CGFloat time=avPlayer.currentTime.value/avPlayer.currentTime.timescale;//等于秒
    if(self.mydelegate && [self.mydelegate performSelector:@selector(playingWithProgress:)])
        [self.mydelegate playingWithProgress:time];
}

-(void)musicDidFinish
{
    if (self.mydelegate && [self.mydelegate performSelector:@selector(playDidToEnd)]) {
        [self.mydelegate playDidToEnd];
    }
    
    
}

















@end
