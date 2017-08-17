//
//  MusicManager.m
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicManager.h"

@interface MusicManager ()
///
@property(nonatomic ,strong)NSMutableArray * allMusicModelArray;//存放所有模型

@end

@implementation MusicManager

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static MusicManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[MusicManager alloc]init];
        
    });
    return manager;
}

#pragma mark - 请求数据 并返回
- (void)requstAllDataDidFinish:(void (^)(NSMutableArray *))result
{
    NSURL * url=[NSURL URLWithString:kMusicUrl];
    //同步请求 要添加子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //拆解数据 封装模型
        NSArray * array=[NSArray arrayWithContentsOfURL:url];
        for (NSDictionary *item in array) {
            MusicModel  *model=[[MusicModel alloc]init];
            [model setValuesForKeysWithDictionary:item];
            [self.allMusicModelArray addObject:model];
        }
        //主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知它刷新并把数组传过去
            result (self.allMusicModelArray);
        });
    });
    
    
    
}

#pragma mark - 根据下标返回模型

-(MusicModel *)getMusicModelWithIndex:(NSInteger)index
{
    MusicModel * model=[self.allMusicModelArray objectAtIndex:index];
    NSError * error = nil;
    NSLog(@"function==%s, line==%d error==%@",__FUNCTION__,__LINE__,error);
    return model;
}

//懒加载

- (NSMutableArray *)allMusicModelArray
{
    
    if (!_allMusicModelArray) {
        _allMusicModelArray=[NSMutableArray array];
    }
    return _allMusicModelArray;
}
//歌曲数组个数
-(NSInteger)countMusic
{
    
    return self.allMusicModelArray.count;
    
}








@end
