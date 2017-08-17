//
//  MusicPlayViewController.h
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayViewController : UIViewController

@property(nonatomic ,assign)NSInteger index;

@property(nonatomic ,strong)MusicModel * model;

+(instancetype)shareInstance;

@property (weak, nonatomic) IBOutlet UITableView *LyricTableView;

//

@end
