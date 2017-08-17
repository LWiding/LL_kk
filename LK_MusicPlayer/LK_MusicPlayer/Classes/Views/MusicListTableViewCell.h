//
//  MusicListTableViewCell.h
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewCell : UITableViewCell

@property(nonatomic ,strong)MusicModel * model;

@property (weak, nonatomic) IBOutlet UILabel *singerLab;


@property (weak, nonatomic) IBOutlet UIImageView *singImgView;

@property (weak, nonatomic) IBOutlet UILabel *singNameLab;


@property (nonatomic, strong) NSString *mmmm;

@end
