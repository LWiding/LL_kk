//
//  MusicPlayHelper.h
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//
/**
 *  播放管理类
 */
////////////////////////////////
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//协议
@protocol MusicPlayingDelegate <NSObject>

//歌曲播放过程中执行此方法  根据播放时间进度
- (void)playingWithProgress:(CGFloat)progress;

//歌曲执行结束执行
-(void)playDidToEnd;//播放结束执行事件

@end

@interface MusicPlayHelper : NSObject

//代理属性
@property(nonatomic ,assign)id<MusicPlayingDelegate> mydelegate;

/**
 *  单例
 */

+ (instancetype)shareInstance;

/**
 *  根据url设置音乐播放器  音乐播放地址
 */

-(void)setAVPlayerWithUrl:(NSString *)url;

/**
 *  播放
 */

-(void)playMusic;

/**
 *  暂停
 */

-(void)pauseMusic;

/**
 *  暂停或播放
 */
-(BOOL)playOrPauseMusic;

/**
 *  从指定时间开始播放
 */

-(void)seekToTimePlay:(CGFloat)time;


/**
 *  音量控制
 */

-(void)volumn:(CGFloat)value;







@end
