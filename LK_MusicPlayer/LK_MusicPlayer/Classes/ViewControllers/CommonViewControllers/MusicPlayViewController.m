//
//  MusicPlayViewController.m
//  LK_MusicPlayer
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicPlayViewController.h"

@interface MusicPlayViewController ()<MusicPlayingDelegate,UITableViewDataSource,UITableViewDelegate>

{
    NSInteger _currentIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *singerImagView;

- (IBAction)lastBUT:(UIButton *)sender;

- (IBAction)nextBut:(UIButton *)sender;


- (IBAction)playOrPauseBUT:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

@property (weak, nonatomic) IBOutlet UILabel *currentimeLab;

@property (weak, nonatomic) IBOutlet UILabel *durationLab;


@end

@implementation MusicPlayViewController

//单例
+(instancetype)shareInstance{
    static MusicPlayViewController * musicHandle=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicHandle=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"musicVC"];
    });
    return musicHandle;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex=-1;
    //设置代理
    [MusicPlayHelper shareInstance].mydelegate=self;
    //设置imageView
    [self setImageView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_currentIndex == self.index) {
        return;
    } else {
        _currentIndex = self.index;
        [self updataUI];
    }
    
    
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//     [MusicPlayHelper shareInstance].mydelegate=nil;
//    
//    
//}


#pragma mark 更新界面
-(void)updataUI{
  
    //设置音乐播放器
    [[MusicPlayHelper shareInstance]setAVPlayerWithUrl:self.model.mp3Url];
    //设置图片
    [self.singerImagView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]];
    //设置slider
    CGFloat duretion=[self.model.duration floatValue]/1000;
    self.musicSlider.maximumValue=duretion;
    
    //加载歌词 刷新界面
    [[LyricManager shareInstance] formatLyricModelWithLyric:self.model.lyric];
    [self.LyricTableView reloadData];
    
    //添加背景图片
    UIImageView * backView = [[UIImageView alloc]init];
    [backView sd_setImageWithURL:[NSURL URLWithString:self.model.picUrl]placeholderImage:nil];
    self.LyricTableView.backgroundView=backView;
    
    
    
}

#pragma mark 设置 ImageView
-(void)setImageView
{
   //设置圆角
    [self .singerImagView layoutIfNeeded ];
    self.singerImagView.layer.cornerRadius=CGRectGetWidth(self.singerImagView.frame)/2;
    //设置圆角
    self.singerImagView.layer.masksToBounds=YES;//不打开设置不成圆角
    //设置其实角度为0
    self.singerImagView.transform=CGAffineTransformMakeRotation(0);
    
}


#pragma mark 获取模型

-(MusicModel *)model
{
   MusicModel *model= [[MusicManager shareInstance]getMusicModelWithIndex:_currentIndex];
    return model;
}
//音量控制
- (IBAction)VoiceSlider:(UISlider *)sender {
    [[MusicPlayHelper shareInstance] volumn:sender.value];
    
}


#pragma mark - MusicPlayManager 代理方法
#pragma mark 播放过程中执行
-(void)playingWithProgress:(CGFloat)progress
{
    //图片旋转
    self.singerImagView.transform=CGAffineTransformRotate(self.singerImagView.transform, M_2_PI/180);
    //进度条
    self.musicSlider.value=progress;
    //当前播放时间
    self.currentimeLab.text=[self changeFormatWithTime:progress];
    //剩余时间
    CGFloat  dutation=[[self.model duration] floatValue]/1000;
    self.durationLab.text=[self changeFormatWithTime: dutation- progress];
    //歌词滚动显示
    //先获取下标
    NSInteger index = [[LyricManager shareInstance] indexOfCurrentTime:progress];//根据当前时间返回下标
    //组拼indexPath
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.LyricTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];//歌词滚动显示
    
    
}

#pragma mark 时间滑竿拖动事件  从指定时间播放

- (IBAction)timerSliderAction:(UISlider *)sender

{
    CGFloat duration = [[self.model duration] floatValue]/1000;
    if (sender.value>=duration) {
        [[MusicPlayHelper shareInstance] pauseMusic];
        return;
    }
    
    [[MusicPlayHelper shareInstance]seekToTimePlay:sender.value];
    
    
}

//转换时间格式
-(NSString *)changeFormatWithTime:(CGFloat)time{
    
    //计算分钟
    int minute = time/60;
    //计算秒
    int seconds = (int)time%60;
    NSString * timeFormat=[NSString stringWithFormat:@"%02d:%02d",minute,seconds];
    return timeFormat;
    
}
#pragma mark 播放结束执行
-(void)playDidToEnd
{
    _currentIndex++;
    //如果播到最后一首歌,切换到第一首歌
    if (_currentIndex>[[MusicManager shareInstance] countMusic]-1) {
        _currentIndex=0;
    }
    //刷新界面相关信息
    [self updataUI];
}


//上一曲歌曲
- (IBAction)lastBUT:(UIButton *)sender {
    //先暂停播放
    [[MusicPlayHelper shareInstance] pauseMusic];
    _currentIndex -- ;
    if (_currentIndex<0) {
        _currentIndex=[[MusicManager shareInstance] countMusic]-1;
    }
    
    [self updataUI];
}

//下一首
- (IBAction)nextBut:(UIButton *)sender {
    [[MusicPlayHelper shareInstance] pauseMusic];//先暂停
    _currentIndex++;
    if (_currentIndex>[[MusicManager shareInstance] countMusic]-1) {
        _currentIndex=0;
    }
    
    [self updataUI];
}
//暂停或播放
- (IBAction)playOrPauseBUT:(UIButton *)sender {
    BOOL isplaying=[[MusicPlayHelper shareInstance] playOrPauseMusic];
    if (isplaying) {
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        
    }else{
        [sender setTitle:@"播放" forState:UIControlStateNormal];
    }
    

    
}

#pragma mark - tableView代理方法

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[LyricManager shareInstance] countLyricAray];
}

//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"lyricCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lyricCell"];
    }
    
    //居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //每行歌词
    cell.textLabel.text = [[LyricManager shareInstance] lyricAtIndex:indexPath.row];
    
    //cell背景图片(设置成黑色半透明)
    cell.backgroundColor=[UIColor clearColor];//一定要设为透明的不然背景图片显示不出来
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor=[UIColor blackColor];
    cell.backgroundView=backView;
    backView.alpha = 0.5;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    //选中cell背景图片
    UIView * selectView = [[UIView alloc]init];
    selectView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectView;
    
    
    //高亮随机颜色
    cell.highlighted = YES;//必须打开
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:(arc4random()% 256/256.0) green:(arc4random()% 256/256.0) blue:(arc4random()% 256/256.0) alpha:1];
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

//点击那一行歌词slider改变滑动位置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据下标返回时间
    CGFloat time = [[LyricManager shareInstance] progressAtIndex:indexPath.row];
    //从指定时间播放
    [[MusicPlayHelper shareInstance]seekToTimePlay:time];
    
    
}















@end
