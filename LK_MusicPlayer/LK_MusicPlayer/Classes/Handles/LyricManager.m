//
//  LyricManager.m
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "LyricManager.h"

@interface LyricManager ()
//存放一首歌的歌词数组
@property(nonatomic ,strong)NSMutableArray * allLyricModelArray;

@end


@implementation LyricManager

#pragma mark  -  单例
+ (instancetype)shareInstance
{
    static LyricManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[LyricManager alloc] init];
        //初始化数组
        manager.allLyricModelArray=[NSMutableArray array];
    });
    return manager;
    
}

#pragma mark - 格式化歌词 (遍历歌词数组 格式化歌词 组装模型 存进数组)

- (void)formatLyricModelWithLyric:(NSString *)lyric
{
    //先移除数组中的数据
    [self.allLyricModelArray removeAllObjects];
    
    //切分每一行歌词 根据换行符\n
   NSArray * contentArray =  [lyric componentsSeparatedByString:@"\n"];
   //遍历歌词数组 格式化数组 组装模型 并存进数组
    for (int i=0; i< contentArray.count-1; i++) {
        //获得每一行歌词源数据
        NSString * souceStr = contentArray[i];
        //拆分歌词为 时间 歌词
        NSArray * lyricArray = [souceStr componentsSeparatedByString:@"]"];
        //如果字符串长度小于1 直接跳出
        if ([lyricArray.firstObject length]<1) {
            break;
        }
        //时间  lyricArray.firstObject格式为 "[ 00:45.23" 所以所需要从1开始获取
        NSString * timerStr = [lyricArray.firstObject substringFromIndex:1];
        ////timeStr的格式为 00:45.23 所以需要去掉 ":"
        NSArray * timerArray = [timerStr componentsSeparatedByString:@":"];
        //算出时间 秒为单位
        CGFloat timeTotal=[timerArray.firstObject floatValue] * 60 + [timerArray.lastObject floatValue];
        
        //歌词
        NSString * lyricStr = lyricArray.lastObject;
        
        //初始化歌词模型
        LyricModel * model = [[LyricModel alloc]init];
        
        //歌词时间
        model.time = timeTotal;
        //歌词
        model.lyric = lyricStr;
        
        //将模型存放近数组
        [self.allLyricModelArray addObject:model];
        
       
        
    }
    
}

#pragma mark - 返回数组个数

- (NSInteger)countLyricAray
{
    return _allLyricModelArray.count;
    
}

#pragma mark - 根据下标返回歌词

- (NSString *)lyricAtIndex:(NSInteger)index
{
     LyricModel * lyricModel = _allLyricModelArray[index];
    
    return lyricModel.lyric;
}

#pragma mark - 根据当前播放时间返回下标

-(NSInteger)indexOfCurrentTime:(CGFloat)time
{
    NSInteger index = 0;
    for (int i=0; i<self.allLyricModelArray.count-1; i++) {
        LyricModel * lyricModel = _allLyricModelArray[i];
        if (lyricModel.time>time) {
            index = i - 1>0? i-1 : 0;
            break;
        }
        
    }
    
    return index;
    
}

#pragma mark - 根据下标返回播放时间
- (CGFloat)progressAtIndex:(NSInteger)index
{
    LyricModel * lyricModel = _allLyricModelArray[index];
    CGFloat time = lyricModel.time;
    return time;
    
    
}




@end
