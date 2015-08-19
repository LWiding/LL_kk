//
//  MusicManager.h
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

/**
 *  音乐管理类
 */

#import <Foundation/Foundation.h>

@interface MusicManager : NSObject

/**
 *  单例
 */
+ (instancetype)shareInstance;

/**
 *  根据url请求数据
 */

- (void)requstAllDataDidFinish:(void(^)(NSMutableArray *dataArr))result;

/**
 *  根据下标返回模型
 */

-(MusicModel *)getMusicModelWithIndex:(NSInteger)index;

/**
 *  返回数组个数
 */
-(NSInteger)countMusic;




@end
