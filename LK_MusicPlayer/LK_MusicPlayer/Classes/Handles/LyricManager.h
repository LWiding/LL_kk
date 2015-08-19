//
//  LyricManager.h
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

/**
 *  歌词管理类
 */
#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

/**
 *  单例
 */

+ (instancetype)shareInstance;

/**
 *  <#Description#>
 */

/**
 *  格式化歌词
 */

- (void)formatLyricModelWithLyric:(NSString *)lyric;

/**
 *  返回数组个数
 */
- (NSInteger)countLyricAray;


/**
 *  根据下标获取歌词(显示歌词时调用)
 */

-(NSString *)lyricAtIndex:(NSInteger)index;


/**
 *  根据时间返回下标(滚动显示歌词调用)
 */

- (NSInteger)indexOfCurrentTime:(CGFloat)time;

/**
 *  根据下标指定播放时间(拖动滑竿时调用)
 */

- (CGFloat)progressAtIndex:(NSInteger)index;






@end
