//
//  MusicListTableViewCell.m
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell


//重写setter方法
-(void)setModel:(MusicModel *)model
{
    [self.singImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.singerLab.text=model.name;
    self.singNameLab.text=model.artists_name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

}


//测试回滚

//111111111111111111111111111111111111111

//2222222222222222222222222222222222222222

//555555555555555555555555555555555555555

//88888888888888888888888888888888888888888888
















@end
